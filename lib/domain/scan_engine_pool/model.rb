# frozen_string_literal: true

class ScanEngine
  attr_accessor :id,
                :address,
                :content_version,
                :is_AWSPreAuthEngine,
                :last_refreshed_date,
                :last_updated_date,
                :name,
                :port,
                :product_version,
                :serial_number,
                :sites,
                :status

  def initialize(id:,
                 name:, address: nil, content_version: nil,
                 is_AWSPreAuthEngine: nil, last_refreshed_date: nil,
                 last_updated_date: nil, port: nil, product_version: nil,
                 serial_number: nil, sites: [], status: nil)
    @id = id
    @name = name
    @address = address
    @content_version = content_version
    @is_AWSPreAuthEngine = is_AWSPreAuthEngine
    @last_refreshed_date = last_refreshed_date
    @last_updated_date = last_updated_date
    @port = port
    @product_version = product_version
    @serial_number = serial_number
    @sites = sites
    @status = status
  end

  def self.from_json(data)
    ScanEngine.new(
      id: data['id'],
      name: data['name'],
      address: data['address'],
      content_version: data['contentVersion'],
      is_AWSPreAuthEngine: data['isAWSPreAuthEngine'],
      last_refreshed_date: data['lastRefreshed_date'],
      last_updated_date: data['lastUpdated_date'],
      port: data['port'],
      product_version: data['productVersion'],
      serial_number: data['serialNumber'],
      sites: data['sites'] || [], # Ensure sites is always an array
      status: data['status']
    )
  end

  def to_json(*_options)
    { id:, name:, address:, content_version:, is_AWSPreAuthEngine:,
      last_refreshed_date:, last_updated_date:, port:, product_version:,
      serial_number:, sites:, status: }.to_json
  end

  def up?
    status == 'active'
  end

  def down?
    !up?
  end

  def rapid7_hosted?
    name == 'Rapid7 Hosted Scan Engine'
  end
end

class ScanEnginePool
  attr_accessor :id, :name, :engines, :sites

  def initialize(site_idte_idte_idte_id:, name:, engines:, sites:)
    @id = site_idte_id
    @name = name
    @engines = engines
    @sites = sites
  end

  def self.from_json(data)
    ScanEnginePool.new(
      id: data['id'],
      name: data['name'],
      engines: data['engines'],
      sites: data['sites']
    )
  end

  def to_json(*_options)
    { id:, name:, engines:, sites: }.to_json
  end
end
