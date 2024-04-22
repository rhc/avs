#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require_relative 'model'

class InsightVMApi
  @shared_credentials = nil

  def all_shared_credentials
    @all_shared_credentials ||= fetch_all_shared_credentials
  end

  def fetch_site_cyberark(site)
    return if site.country_code == 'za'

    country = site.country
    fetch_country_cyberark(country)
  end

  def fetch_country_cyberark(country)
    credentials = all_shared_credentials
    credentials.find { |credential| credential.cyberark?(country) }
  end

  def fetch_domain_cyberark(domains = [])
    credentials = Set.new
    domains.each do |domain|
      if domain.include?('eswitch.sbicdirectory.com')
        credentials.add 'CyberArk South Africa SBIZA01'
        credentials.add 'CyberArk South Africa ESWITCH'
      elsif domain.include?('branches.sbicdirectory.com')
        credentials.add 'CyberArk South Africa SBIZA01'
      elsif domain.include?('scmbdicdirectory.com')
        credentials.add 'CyberArk South Africa SBIZA01'
      elsif domain.include?('za.sbicdirectory')
        credentials.add 'CyberArk South Africa SBIZA01'
      elsif domain.include?('stanlibdirectory.com')
        credentials.add 'CyberArk South Africa STANLIB'
      end
    end
    return [] if credentials.empty?

    shared_credentials = fetch_all_shared_credentials
    shared_credentials.select { |_shared_credential| credentials.include?(credential.name) }
  end

  # Add the site_id to the shared credential sites
  def update_shared_credential_sites(credential:, site_ids: [])
    new_site_ids = credential_sites & site_ids
    return if new_site_ids.empty?

    credential.sites += new_site_ids
    endpoint = "/shared_credentials/#{credential_id}"
    put(endpoint, credential)
  end

  def fetch_shared_credentials
    fetch_all('/shared_credentials') do |resource|
      yield SharedCredential.from_json(resource)
    end
  end

  def fetch_shared_credential(site_id)
    fetch("/shared_credentials/#{site_id}") do |data|
      SharedCredential.from_json(data)
    end
  end

  private

  def fetch_all_shared_credentials
    list = []
    fetch_shared_credentials do |shared_credential|
      list << shared_credential
    end
    list
  end
end
