# frozen_string_literal: true

class Site
  attr_accessor :id, :name, :description, :risk_score, :scan_engine, :scan_template

  def initialize(id:, name:, description:, risk_score:, scan_engine:, scan_template:)
    @id = id
    @name = name
    @description = description
    @risk_score = risk_score
    @scan_engine = scan_engine
    @scan_template = scan_template
  end

  # data json comes from the API sites/get
  def self.from_json(data)
    Site.new(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      risk_score: data['risk_score'],
      scan_engine: data['scanEngine'],
      scan_template: data['scanTemplate']
    )
  end

  def to_s
    [id, name, scan_engine, scan_template].join ','
  end

  # returns true if the site ends with _UTR followed by 5 digits
  def utr?
    # Define the regular expression pattern
    utr_pattern = /:UTR\d{5}$/

    # Check if the site ends with "_UTR" followed by one or more digits
    !!(name =~ utr_pattern)
  end
end

class CmdbAsset
  attr_accessor :id,
                :country_code,
                :business_unit,
                :sub_area,
                :application,
                :utr,
                :fqdn,
                :host_name,
                :ip_address,
                :operating_system,
                :server_environment,
                :server_category,
                :host_key,
                :country

  def initialize(id:,
                 country_code:,
                 business_unit:,
                 sub_area:,
                 application:,
                 utr:,
                 fqdn:,
                 host_name:,
                 ip_address:,
                 operating_system:,
                 server_environment:,
                 server_category:,
                 host_key:,
                 country:)
    @id = id
    @country_code = country_code
    @business_unit = business_unit
    @sub_area = sub_area
    @application = application
    @utr = utr
    @fqdn = fqdn
    @host_name = host_name
    @ip_address = ip_address
    @operating_system = operating_system
    @server_category = server_category
    @server_environment = server_environment
    @host_key = host_key
    @country = country
  end

  def site_name
    ['', country_code, business_unit, sub_area, application, utr].join(':')
  end

  def self.from_csv(row)
    CmdbAsset.new(id: row[:id],
                  country_code: row[:country_code],
                  country: row[:country],
                  business_unit: row[:business_unit],
                  sub_area: row[:sub_area],
                  application: row[:application],
                  utr: row[:utr],
                  fqdn: row[:fqdn],
                  ip_address: row[:ip_address],
                  host_name: row[:host_name],
                  host_key: row[:host_key],
                  operating_system: row[:operating_system],
                  server_environment: row[:server_environment],
                  server_category: row[:server_category])
  end

  def to_s
    [id, site_name, fqdn, ip_address].join ','
  end
end

class CmdbSite
  attr_accessor :name, :country_code, :business_unit, :sub_area, :application, :utr

  def initialize(name:, country_code:, business_unit:, sub_area:, application:, utr:)
    @name = name
    @country_code = country_code
    @business_unit = business_unit
    @sub_area = sub_area
    @application = application
    @utr = utr
  end

  def self.from_csv(row)
    CmdbSite.new(
      name: row[:site],
      country_code: row[:country_code],
      business_unit: row[:business_unit],
      sub_area: row[:sub_area],
      application: row[:application],
      utr: row[:utr]
    )
  end

  def to_s
    [name, country_code, business_unit, sub_area, application, utr].join ','
  end
end

class ScanEnginePool
  attr_accessor :id, :name, :engines, :sites

  def initialize(id:, name:, engines:, sites:)
    @id = id
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

  def initialize(id:, name:, address: nil, content_version: nil,
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
