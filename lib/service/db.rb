# frozen_string_literal: true

require 'csv'
require_relative '../domain/db'

class Db
  attr_reader :host, :db, :user, :port

  def initialize(host:, db:, user:, port:)
    @host = host
    @db = db
    @user = user
    @port = port
  end

  def fetch_cmdb
    fetch_view('utr_asset_view') do |row|
      CmdbAsset.from_csv(row)
    end
  end

  private

  def fetch_view(view, &block)
    ENV['PGPASSFILE'] = '/Users/ckyony/.pgpass'
    command = "psql -d #{db} -U #{user} -h '#{host}' -p #{port} -c \"\\copy (SELECT * FROM #{view}) to STDOUT with CSV HEADER;\""
    result = `#{command}`
    p result
    rows = CSV.new(result, headers: true, header_converters: :symbol)
    rows.map(&block)
  end
end
