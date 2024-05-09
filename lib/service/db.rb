# frozen_string_literal: true

require 'csv'
require 'pg'
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

  def upsert(model)
    table_name = model.class.table_name
    columns = model.class.columns
    column_names = columns.join(', ')
    placeholders = columns.map.with_index(1) { |_, i| "$#{i}" }.join(', ')
    conflict_target = model.class.primary_key # Unique identifier assumption
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

  def fetch_view(view, &block)
    ENV['PGPASSFILE'] = '/Users/ckyony/.pgpass'
    command = "psql -d #{db} -U #{user} -h '#{host}' -p #{port} -c \"\\copy (SELECT * FROM #{view}) to STDOUT with CSV HEADER;\""
    result = `#{command}`
    rows = CSV.new(result, headers: true, header_converters: :symbol)
    rows.map(&block)
  end
end
