require_relative 'model'

# Reopen the App class or module to add the 'asset' command
class App
  extend GLI::App

  desc 'Describe asset here'
  arg_name 'Describe arguments to asset here'
  command :asset do |c|
    c.desc 'Describe a switch to asset'
    c.switch :s

    c.desc 'Describe a flag to asset'
    c.default_value 'default'
    c.flag :f
    c.action do |_global_options, _options, _args|
      # Your command logic specific to 'asset' here
      assets = [
        CmdbAsset.new(
          id: 100,
          country_code: 'cd',
          business_unit: 'bu',
          sub_area: 'sa',
          application: 'ewallet',
          utr: 'UTR01966',
          fqdn: 'fqdn.co.za',
          host_name: 'fqdn',
          ip_address: '172.16.19.66',
          operating_system: 'ubuntu',
          server_environment: 'linux',
          server_category: 'linux',
          host_key: 'xxxx',
          country: 'DRC'
        ),
        CmdbAsset.new(
          id: 200,
          country_code: 'mw',
          business_unit: 'bu',
          sub_area: 'sa',
          application: 'atm',
          utr: 'UTR01966',
          fqdn: 'fqdn.co.za',
          host_name: 'fqdn',
          ip_address: '198.172.19.66',
          operating_system: 'ubuntu',
          server_environment: 'linux',
          server_category: 'linux',
          host_key: 'xxxx',
          country: 'Malawi'
        ),
        CmdbAsset.new(
          id: 300,
          country_code: 'bw',
          business_unit: 'bu',
          sub_area: 'sa',
          application: 'forex',
          utr: 'UTR01986',
          fqdn: 'fqdn.co.za',
          host_name: 'fqdn',
          ip_address: '10.12.19.66',
          operating_system: 'ubuntu',
          server_environment: 'linux',
          server_category: 'linux',
          host_key: 'xxxx',
          country: 'Botswana'
        )
      ]
      puts 'list assets'
      assets.each do |asset|
        puts asset
      end
    end
  end
end
