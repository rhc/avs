# frozen_string_literal: true

require 'csv'
require 'pg'
require_relative '../domain/db'

class Db
  attr_reader :host, :db, :user, :port

  def initialize(host:, db:, user:, port:)
    @host = host
    @db = db
    @user = user
    @port = port
    @connection = PG.connect(host:, dbname: db, port:, user:)
  end

  def upsert(model)
    table_name = model.class.table_name
    columns = model.class.columns
    column_names = columns.join(', ')
    placeholders = columns.map.with_index(1) { |_, i| "$#{i}" }.join(', ')
    conflict_target = columns.first # Unique identifier assumption
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
    p result
    rows = CSV.new(result, headers: true, header_converters: :symbol)
    rows.map(&block)
  end
end
