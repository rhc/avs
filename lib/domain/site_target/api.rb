#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require_relative 'model'

class InsightVMApi
  @site_targets = nil

  def fetch_site_included_targets(site_id)
    fetch_site_targets(site_id, included: true)
  end

  def fetch_site_excluded_targets(site_id)
    fetch_site_targets(site_id, included: false)
  end

  # Returns included and excluded targets for site id
  def fetch_all_targets(site_id)
    [true, false].reduce([]) do |accu, included|
      accu + fetch_site_targets(site_id, included:)
    end
  end

  def fetch_site_target_domains(site_id)
    targets = fetch_site_included_targets(site_id)
    hosts = targets.select { |target| target.type == 'host' }
    # remove the host part of the fqdns
    hosts.each_with_object(Set.new) do |host, accu|
      domain = remove_first_part(host.target)
      accu.add domain unless domain.nil? || domain.blank?
    end
  end

  private

  def fetch_site_targets(site_id, included: true)
    addresses = []
    targets = included ? 'included_targets' : 'excluded_targets'
    endpoint = "/sites/#{site_id}/#{targets}"
    fetch(endpoint) do |resource|
      addresses = resource['addresses']
    end
    return [] if addresses.nil?

    addresses.map do |target|
      type = contains_letters?(target) ? 'host' : 'ip'
      SiteTarget.new({
                       site_id:,
                       target:,
                       type:,
                       included:,
                       scope: nil
                     })
    end
  end

  def contains_letters?(address)
    address.chars.any? { |char| char.match?(/[a-zA-Z]/) }
  end

  def remove_first_part(fqdn)
    parts = fqdn.split('.')
    parts.drop(1).join('.')
  end
end
