# frozen_string_literal: true

# Shared Credential can be used in multiple sites
# NOTE: There is no dimension, so the API is the source of truth
class SharedCredential
  attr_accessor :id, :description, :host_restriction, :port_restriction, :name, :account, :site_assignment, :sites

  def initialize(id:,
                 name:,
                 account:,
                 site_assignment:,
                 sites:,
                 description:,
                 host_restriction:,
                 port_restriction:)
    @account = account
    @description = description
    @host_restriction = host_restriction
    @id = id
    @name = name
    @port_restriction = port_restriction
    @site_assignment  = site_assignment
    @sites = sites
  end

  def domain
    @account['domain']
  end

  def service
    @account['service']
  end

  def service_name
    @account['serviceName']
  end

  def user_name
    @account['userName']
  end

  def permission_elevation
    @account['permissionElevation']
  end

  def permission_elevation_user_name
    @account['permissionElevationUsername']
  end

  def self.from_json(data)
    SharedCredential.new(
      account: data['account'],
      description: data['description'],
      host_restriction: data['hostRestriction'],
      id: data['id'],
      name: data['name'],
      port_restriction: data['portRestriction'],
      site_assignment: data['siteAssignment'],
      sites: data['sites']
    )
  end

  def to_json(*_options)
    {
      account: @account,
      description: @description,
      hostRestriction: @host_restriction,
      id: @id,
      name: @name,
      portRestriction: @port_restriction,
      siteAssignment: @site_assignment,
      sites: @sites
    }.to_json
  end

  def to_s
    [id, name, service, domain, user_name].join ','
  end

  def from_csv; end

  def to_csv
    site_ids = sites&.join('|') || ''
    [id, name, account, site_assignment, site_ids].join ','
  end

  # returns true
  # if the name starts with CyberArk
  # and the name contains the country name
  def cyberark?(country)
    name.downcase.include?('cyberark') && name.downcase.include?(country.downcase)
  end
end
