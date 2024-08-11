# frozen_string_literal: true

require 'csv'
require 'pg'
require 'ruby-progressbar'
require_relative '../domain/db'

class Db
  attr_reader :host, :db, :user, :port, :connection

  def initialize(host:, db:, user:, port:)
    @host = host
    @db = db
    @user = user
    @port = port
    @connection = PG.connect(host:, dbname: db, port:, user:)
  end

  def all(model_class)
    sql = "SELECT * FROM #{model_class.table_name}"
    result = @connection.exec(sql)
    result.map do |row|
      model_class.new(row)
    end
  end

  def select(model_class, view_name)
    sql = "SELECT * FROM #{view_name}"
    result = @connection.exec(sql)
    result.map do |row|
      model_class.new(row)
    end
  end

  def find_by(model_class, attribute, value)
    sql = "SELECT * FROM #{model_class.table_name} WHERE #{attribute} = $1"
    result = @connection.exec_params(sql, [value])
    result.map do |row|
      model_class.new(row)
    end
    return nil if result.ntuples.zero?

    model_class.new(result.first.symbolize_keys)
  end

  def grant_view_access(user, role, schema = 'public')
    puts "user, role,schema #{[user, role, schema]}"
    grant_existing_view_access(user, role, schema)
    grant_future_view_access(user, role, schema)
    @connection.close
  end

  def grant_existing_view_access(user, role, schema)
    query = <<-SQL
    DO $$
    DECLARE
      r RECORD;
    BEGIN
      FOR r IN (SELECT table_schema, table_name
                FROM information_schema.views v
                JOIN pg_views pv
                  ON v.table_schema = pv.schemaname
                  AND v.table_name = pv.viewname
                WHERE table_schema = '#{schema}'
                  AND pv.viewowner = '#{role}'
                ) LOOP
        EXECUTE 'GRANT SELECT ON ' || quote_ident(r.table_schema) || '.' || quote_ident(r.table_name) || ' TO ' || '#{user}';
      END LOOP;
    END $$ LANGUAGE plpgsql;
    SQL

    puts "query #{query}"

    @connection.exec(query)
  end

  def grant_future_view_access(user, role, schema)
    query = <<-SQL
    ALTER DEFAULT PRIVILEGES FOR ROLE #{role} IN SCHEMA #{schema} GRANT SELECT ON TABLES TO #{user};
    SQL
    @connection.exec(query)
  end

  def bulk_copy(models = [])
    return if models.empty?

    model = models.first
    table_name = model.class.table_name
    columns = model.class.columns
    data = models.map(&:to_csv)
    bulk_copy_csv(table_name:, columns:, data:)
  end

  def bulk_copy_csv(table_name:, columns: [], data: [])
    column_names = columns.empty? ? '' : "( #{columns.join(',')})"
    progress_bar = ProgressBar.create(
      title: "Copy to #{table_name}",
      total: data.length,
      format: '%a %B %p%% %t'
    )
    @connection.copy_data("COPY #{table_name} #{column_names} from STDIN with (FORMAT csv)") do
      data.each do |row|
        sanitized_row = row.map { |cell| escape_csv_value(cell) }
        connection.put_copy_data(sanitized_row.join(',') + "\n")
        progress_bar.increment
      end
    end
  end

  def upsert(model)
    table_name = model.class.table_name
    columns = model.class.columns
    column_names = columns.join(', ')
    placeholders = columns.map.with_index(1) { |_, i| "$#{i}" }.join(', ')
    conflict_target = model.class.primary_key.join(', ') # Unique identifier assumption

    # puts "---- conflict_target: #{conflict_target}"
    # puts "---- table_name: #{table_name}"
    # puts "---- model.class: #{model.class}"
    # puts "---- model.class.primary_key: #{model.class.primary_key}"

    update_assignments = columns.map do |column|
      "#{column} = EXCLUDED.#{column}"
    end.join(', ')

    sql = <<-SQL
      INSERT INTO #{table_name} (#{column_names})
      VALUES (#{placeholders})
      ON CONFLICT (#{conflict_target}) DO UPDATE SET
      #{update_assignments};
    SQL

    @connection.exec_params(sql, model.to_csv)
  rescue PG::Error => e
    puts "An error occurred: #{e.message}"
  end

  def upsert_without_primary_key(model)
    table_name = model.class.table_name
    columns = model.class.columns
    column_names = columns.join(', ')
    placeholders = columns.map.with_index(1) { |_, i| "$#{i}" }.join(', ')

    sql = <<-SQL
      INSERT INTO #{table_name} (#{column_names})
      VALUES (#{placeholders})
    SQL

    @connection.exec_params(sql, model.to_csv)
  rescue PG::Error => e
    puts "An error occurred: #{e.message}"
  end

  def fetch_view(view, &block)
    ENV['PGPASSFILE'] = '/Users/ckyony/.pgpass'
    command = "psql -d #{db} -U #{user} -h '#{host}' -p #{port} -c \"\\copy (SELECT * FROM #{view}) to STDOUT with CSV HEADER;\""
    result = `#{command}`
    rows = CSV.new(result, headers: true, header_converters: :symbol)
    rows.map(&block)
  end

  def bulk_upsert(models = [])
    return if models.empty?

    model_class = models.first.class
    table_name = model_class.table_name
    columns = model_class.columns
    column_names = columns.join(', ')
    placeholders = columns.map.with_index(1) { |_, i| "$#{i}" }.join(', ')
    conflict_target = model_class.primary_key.join(', ')

    update_assignments = columns.map do |column|
      "#{column} = EXCLUDED.#{column}"
    end.join(', ')

    sql = <<-SQL
      INSERT INTO #{table_name} (#{column_names})
      VALUES (#{placeholders})
      ON CONFLICT (#{conflict_target}) DO UPDATE SET
      #{update_assignments};
    SQL

    progress_bar = ProgressBar.create(
      title: "Upserting to #{table_name}",
      total: models.length,
      format: '%a %B %p%% %t'
    )

    @connection.prepare('bulk_upsert_statement', sql)

    @connection.transaction do
      models.each do |model|
        @connection.exec_prepared('bulk_upsert_statement', model.to_csv)
        progress_bar.increment
      end
    end
  rescue PG::Error => e
    puts "An error occurred: #{e.message}"
  ensure
    @connection.exec('DEALLOCATE bulk_upsert_statement')
  end

  private

  def escape_csv_value(value)
    value = value.to_s
    return '' if value.nil?

    if value.include?(',') || value.include?('"') || value.include?("\n")
      value = value.gsub('"', '""')
      value = "\"#{value}\""
    end
    value
  end
end
