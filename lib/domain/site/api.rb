#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'model'

class InsightVMApi
  def fetch_sites
    fetch_all('/sites') do |resource|
      yield Site.from_json(resource)
    end
  end

  def fetch_utr_sites
    sites = []
    fetch_sites do |site|
      sites << site if site.utr?
    end
    sites
  end

  def create_site(
    name:,
    description:,
    engine_id:,
    scan_template_id:,
    importance: 'normal',
    included_targets: [],
    excluded_targets: [],
    included_asset_group_ids: [],
    excluded_asset_group_ids: []
  )
    # Construct the request body
    site_params = {
      name:,
      description:,
      importance:,
      engineId: engine_id,
      scanTemplateId: scan_template_id,
      scan: {
        assets: {
          includedTargets: {
            addresses: included_targets
          },
          excludedTargets: {
            addresses: excluded_targets
          },
          includedAssetGroups: {
            assetGroupIDs: included_asset_group_ids
          },
          excludedAssetGroups: {
            assetGroupIDs: excluded_asset_group_ids
          }
        }
      }
    }
    result = post('/sites', site_params)
    result&.dig('id')
  end

  # return site.id if success
  def create_utr_site_from(site_name:, cmdb_assets:)
    # retrieve the site with the name
    # cmdb_site = cmdb_sites.find { |site| site.name == site_name }

    assets = cmdb_assets.select { |asset| asset.site_name == site_name }
    return if assets.empty?

    country = assets.first.country
    puts "Country #{country}"
    targets = assets.map(&:fqdn)
    scan_engine_pool = fetch_country_scan_engine_pools(country)
    puts "Scan engine pool #{scan_engine_pool}"
    engine_id = scan_engine_pool[:id]
    scan_template_id = 'authentication-test-ssh'
    puts "Creating Site #{site_name}\n #{targets.length} Targets: #{targets} \nEngine: #{scan_engine_pool} "

    site_id = create_utr_site(
      name: site_name,
      description: 'Country UTR',
      targets:,
      engine_id:,
      scan_template_id:
    )
    return if site_id.nil?

    shared_credential = fetch_cyberark(country)
    puts "Creating CyberArk #{shared_credential[:name]}"
    credential_id = shared_credential[:id]
    add_site_shared_credentials(site_id:, credential_id:)
    site_id
  end

  def delete_site(id:)
    delete('/sites', id)
  end

  def create_utr_site(
    name:,
    description:,
    targets:,
    engine_id:,
    scan_template_id:
  )
    create_site(
      name:,
      description:,
      importance: 'high',
      engine_id:,
      scan_template_id:,
      included_targets: targets
    )
  end
end
