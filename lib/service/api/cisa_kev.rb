#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'
require_relative '../../domain/vulnerability/model'

module CisaKevApi
  FEED_URL = 'https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json'

  def self.fetch_vulnerabilities
    uri = URI(FEED_URL)
    response = Net::HTTP.get_response(uri)

    unless response.is_a?(Net::HTTPSuccess)
      raise "Failed to fetch vulnerabilities: #{response.code} #{response.message}"
    end

    json_response = JSON.parse(response.body)
    vulnerabilities = json_response['vulnerabilities']
    vulnerabilities.each do |vulnerability|
      yield CisaKevVulnerability.from_json(vulnerability)
    end
  end

  def self.vulnerabilities
    list = []
    fetch_vulnerabilities do |vulnerability|
      list << vulnerability
    end
    list
  end
end
