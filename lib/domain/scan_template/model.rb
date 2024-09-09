# frozen_string_literal: true

require_relative '../model'

class ScanTemplate < Domain::Model
  attr_accessor :id, :name, :description, :discovery_only, :enable_windows_services, :enhanced_logging,
                :max_parallel_assets, :max_scan_processes, :policy_enabled, :vulnerability_enabled, :web_enabled, :checks, :database, :discovery, :policy, :telnet, :web

  def initialize(attributes = {})
    @checks = Checks.new(attributes[:checks]) if attributes[:checks]
    @database = Database.new(attributes[:database]) if attributes[:database]
    @discovery = Discovery.new(attributes[:discovery]) if attributes[:discovery]
    @policy = Policy.new(attributes[:policy]) if attributes[:policy]
    @telnet = Telnet.new(attributes[:telnet]) if attributes[:telnet]
    @web = Web.new(attributes[:web]) if attributes[:web]
    super(attributes)
  end

  class Checks < Domain::Model
    attr_accessor :correlate, :potential, :unsafe, :categories, :individual, :types

    def initialize(attributes = {})
      @categories = Category.new(attributes[:categories]) if attributes[:categories]
      @individual = Category.new(attributes[:individual]) if attributes[:individual]
      @types = Category.new(attributes[:types]) if attributes[:types]
      super(attributes)
    end

    class Category < Domain::Model
      attr_accessor :disabled, :enabled
    end
  end

  class Database < Domain::Model
    attr_accessor :db2, :oracle, :postgres
  end

  class Discovery < Domain::Model
    attr_accessor :asset, :performance, :service

    def initialize(attributes = {})
      @asset = Asset.new(attributes[:asset]) if attributes[:asset]
      @performance = Performance.new(attributes[:performance]) if attributes[:performance]
      @service = Service.new(attributes[:service]) if attributes[:service]
      super(attributes)
    end

    class Asset < Domain::Model
      attr_accessor :collect_whois_information, :fingerprint_minimum_certainty,
                    :fingerprint_retries, :ip_fingerprinting_enabled,
                    :send_arp_pings, :send_icmp_pings, :tcp_ports,
                    :treat_tcp_reset_as_asset, :udp_ports
    end

    class Performance < Domain::Model
      attr_accessor :packet_rate, :parallelism, :retry_limit, :scan_delay, :timeout

      def initialize(attributes = {})
        @packet_rate = PacketRate.new(attributes[:packet_rate]) if attributes[:packet_rate]
        @parallelism = Parallelism.new(attributes[:parallelism]) if attributes[:parallelism]
        @scan_delay = ScanDelay.new(attributes[:scan_delay]) if attributes[:scan_delay]
        @timeout = Timeout.new(attributes[:timeout]) if attributes[:timeout]
        super(attributes)
      end

      class PacketRate < Domain::Model
        attr_accessor :defeat_rate_limit, :maximum, :minimum
      end

      class Parallelism < Domain::Model
        attr_accessor :maximum, :minimum
      end

      class ScanDelay < Domain::Model
        attr_accessor :maximum, :minimum
      end

      class Timeout < Domain::Model
        attr_accessor :initial, :maximum, :minimum
      end
    end

    class Service < Domain::Model
      attr_accessor :service_name_file, :tcp, :udp

      def initialize(attributes = {})
        @tcp = PortConfig.new(attributes[:tcp]) if attributes[:tcp]
        @udp = PortConfig.new(attributes[:udp]) if attributes[:udp]
        super(attributes)
      end

      class PortConfig < Domain::Model
        attr_accessor :additional_ports, :excluded_ports, :method, :ports
      end
    end
  end

  class Policy < Domain::Model
    attr_accessor :enabled, :recursive_windows_fs_search, :store_scap
  end

  class Telnet < Domain::Model
    attr_accessor :character_set, :failed_login_regex, :login_regex,
                  :password_prompt_regex, :questionable_login_regex
  end

  class Web < Domain::Model
    attr_accessor :dont_scan_multi_use_devices, :include_query_strings,
                  :paths, :patterns, :performance, :test_common_usernames_and_passwords,
                  :test_xss_in_single_scan, :user_agent

    def initialize(attributes = {})
      @paths = Paths.new(attributes[:paths]) if attributes[:paths]
      @patterns = Patterns.new(attributes[:patterns]) if attributes[:patterns]
      @performance = Performance.new(attributes[:performance]) if attributes[:performance]
      super(attributes)
    end

    class Paths < Domain::Model
      attr_accessor :boostrap, :excluded, :honor_robot_directives
    end

    class Patterns < Domain::Model
      attr_accessor :sensitive_content, :sensitive_field
    end

    class Performance < Domain::Model
      attr_accessor :http_daemons_to_skip, :maximum_directory_levels,
                    :maximum_foreign_hosts, :maximum_link_depth,
                    :maximum_pages, :maximum_retries, :maximum_time,
                    :response_timeout, :threads_per_server
    end
  end
end
