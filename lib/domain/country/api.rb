#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require_relative 'model'

class InsightVMApi
  @countries = nil

  def all_countries
    @all_countries ||= fetch_all_countries
  end

  def fetch_site_cyberark(site)
    unless site.country_code == 'za'
      country = site.country
      fetch_country_cyberark(country)
    end
  end

  def fetch_cyberark(country)
    credentials = all_countries
    credentials.find { |credential| credential.cyberark?(country) }
  end

  def fetch_cyberark_by(domains:)
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

    countries = fetch_all_countries
    countries.select { |_country| credentials.include?(credential.name) }
  end

  # Add the site_id to the shared credential sites
  def add_site_countries(site_id:, credential_id:)
    # retrieve the credential_id
    credential = fetch_country(credential_id)
    return if credential.sites.include?(site_id)

    credential.sites += [site_id]
    endpoint = "/countries/#{credential_id}"
    put(endpoint, credential)
  end

  def fetch_countries
    fetch_all('/countries') do |resource|
      yield Country.from_json(resource)
    end
  end

  def fetch_country(site_id)
    fetch("/countries/#{site_id}") do |data|
      Country.from_json(data)
    end
  end

  private

  def fetch_all_countries
    list = []
    fetch_countries do |country|
      list << country
    end
    list
  end
end
