# frozen_string_literal: true

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
                :country,
                :matching_fqdn,
                :matching_host_name,
                :matching_ip_address,
                :is_subnet_in_server_range,
                :reported_decommissioned,
                :onboard_asset,
                :business_unit_code

  def initialize(
    id:,
    country_code:,
    business_unit:,
    business_unit_code:,
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
    country:,
    matching_fqdn:,
    matching_host_name:,
    matching_ip_address:,
    is_subnet_in_server_range:,
    reported_decommissioned:,
    onboard_asset:
  )

    @id = id
    @country_code = country_code
    @business_unit = business_unit
    @business_unit_code = business_unit_code
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
    @matching_fqdn = matching_fqdn
    @matching_host_name = matching_host_name
    @matching_ip_address = matching_ip_address
    @is_subnet_in_server_range = is_subnet_in_server_range
    @reported_decommissioned = reported_decommissioned
    @onboard_asset = onboard_asset
  end

  def onboard?
    onboard_asset
  end

  def site_name
    ['', country_code, business_unit_code, sub_area, application, utr].join(':')
  end

  def utr_tag_names
    app_utr = [application, utr].join ' - '
    [business_unit_code, sub_area, app_utr, country]
  end

  def self.from_csv(row)
    CmdbAsset.new(
      id: row[:id],
      country_code: row[:country_code],
      country: row[:country],
      business_unit: row[:business_unit],
      business_unit_code: row[:business_unit_code],
      sub_area: row[:sub_area],
      application: row[:application],
      utr: row[:utr],
      fqdn: row[:fqdn],
      ip_address: row[:ip_address],
      host_name: row[:host_name],
      host_key: row[:host_key],
      operating_system: row[:operating_system],
      server_environment: row[:server_environment],
      server_category: row[:server_category],
      matching_fqdn: row[:matching_fqdn],
      matching_host_name: row[:matching_host_name],
      matching_ip_address: row[:matching_ip_address],
      is_subnet_in_server_range: row[:is_subnet_in_server_range],
      reported_decommissioned: row[:reported_decommissioned],
      onboard_asset: row[:onboard_asset]
    )
  end

  def to_s
    [id, site_name, fqdn, ip_address].join ','
  end
end
