#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require_relative 'model'

class InsightVMApi
  @shared_credentials = nil

  def all_shared_credentials
    @all_shared_credentials ||= fetch_all_shared_credentials
  end

  # TODO: use directly country code 2024-04-25 08:53
  def fetch_country_cyberark(country)
    credentials = all_shared_credentials
    credentials.find { |credential| credential.cyberark?(country) }
  end

  def list_shared_credential_utr_sites(credential, utr_sites)
    site_ids = credential.sites
    utr_sites.select { |site| site_ids.include?(site.id) }
  end

  def remove_shared_credential_utr_sites(credential, utr_sites)
    site_ids = utr_sites.select(&:utr?).map(&:id)
    remove_shared_credential_sites(credential, site_ids)
  end

  def remove_shared_credential_sites(credential, site_ids = [])
    to_be_removed = credential.sites & site_ids
    return if to_be_removed.empty?

    endpoint = "/shared_credentials/#{credential.id}"
    credential.sites -= to_be_removed
    put(endpoint, credential)
  end

  def fetch_domain_cyberark(domains = [])
    puts domains
    credentials = Set.new
    domains.map(&:downcase)
           .each do |domain|
      if domain.include?('eswitch.sbicdirectory.com')
        credentials.add 'CyberArk South Africa SBICZA01'
        credentials.add 'CyberArk South Africa ESWITCH'
      elsif domain.include?('branches.sbicdirectory.com')
        credentials.add 'CyberArk South Africa SBICZA01'
      elsif domain.include?('scmbdicdirectory.com')
        credentials.add 'CyberArk South Africa SBICZA01'
      elsif domain.include?('za.sbicdirectory')
        credentials.add 'CyberArk South Africa SBICZA01'
      elsif domain.include?('stanlibdirectory.com')
        credentials.add 'CyberArk South Africa STANLIB'
      end
    end
    # puts "Credentials #{credentials}"
    return [] if credentials.empty?

    all_shared_credentials.select do |shared_credential|
      credentials.include?(shared_credential.name)
    end
  end

  # Add the site_id to the shared credential sites
  def update_shared_credential_sites(credential:, site_ids: [])
    new_site_ids = site_ids - credential.sites
    if new_site_ids.empty?
      puts "#{credential.name} contains already sites #{site_ids}"
      return
    end

    credential.sites += new_site_ids
    endpoint = "/shared_credentials/#{credential.id}"
    put(endpoint, credential)
  end

  def fetch_shared_credentials
    fetch_all('/shared_credentials') do |resource|
      yield SharedCredential.from_json(resource)
    end
  end

  def fetch_shared_credential(id)
    fetch("/shared_credentials/#{id}") do |data|
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
