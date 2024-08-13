# frozen_string_literal: true

require_relative '../model'

# SharedCredential represents a credential that can be used across multiple sites in the system.
#
# This class serves as a representation of shared credentials, which are primarily managed through
# the API, as there is no corresponding dimension in the database.
#
class SharedCredential < Domain::Model
  attr_accessor :id,
                :description,
                :host_restriction,
                :port_restriction,
                :name,
                :account,
                :site_assignment,
                :sites

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
