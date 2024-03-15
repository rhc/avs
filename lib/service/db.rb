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

  def fetch_country_utr_from_cmdb
    fetch_view('utr_site_view') do |row|
      CmdbSite.from_csv(row)
    end
  end

  def fetch_shared_credentials
    fetch_view('shared_credential_view') do |row|
      SharedCredential.from_csv(row)
    end
  end

  def fetch_cyberark_shared_credentials(_country_code)
    credentials = fetch_shared_credentials
    credentials.select do |credential|
    end
  end

  private

  def fetch_view(view)
    ENV['PGPASSFILE'] = '/Users/ckyony/.pgpass'
    command = "psql -d #{db} -U #{user} -h '#{host}' -p #{port} -c \"\\copy (SELECT * FROM #{view}) to STDOUT with CSV HEADER;\""
    result = `#{command}`
    p result
    rows = CSV.new(result, headers: true, header_converters: :symbol)
    rows.map(&block)
  end
end
