# frozen_string_literal: true

require 'dotenv'
env_path = File.expand_path('.env', __dir__)
Dotenv.load(env_path)

require 'gli'
require_relative '../lib/avs'
require_relative '../lib/service/db'
require_relative '../lib/service/api/insightvm'
require_relative '../lib/service/api/nucleus'
require_relative '../lib/service/mail'

class App
  extend GLI::App
  # TODO: use the ENV for host, db, port
  def self.api
    @api ||= InsightVMApi.new(
      base_url: ENV['INSIGHTVM_API_URL'],
      username: ENV['INSIGHTVM_API_USER'],
      password: ENV['INSIGHTVM_API_PASSWORD']
    )
  end

  def self.nucleus
    @nucleus ||= NucleusApi.new(
      base_url: ENV['NUCLEUS_API_URL'],
      api_key: ENV['NUCLEUS_API_KEY'],
      download_dir: ENV['NUCLEUS_DOWNLOAD_DIR'],
      archive_dir: ENV['NUCLEUS_ARCHIVE_DIR']
    )
  end

  # TODO:  use the ENV for host, db, port
  def self.db
    @db ||= Db.new(
      host: ENV['DB_HOST'],
      db: ENV['DB_NAME'],
      user: ENV['DB_USER'],
      port: ENV['DB_PORT']
    )
  end

  def self.mail
    MailService.instance
  end

  def self.parent(options, key)
    options[GLI::Command::PARENT][key]
  end

  def self.backtrace(exception, limit: 8, prefix: "\t ")
    puts "#{prefix} Error occurred: #{exception.message}"
    puts "#{prefix} ----------------------------"
    puts exception.backtrace.first(limit).map { |line| "\t\t#{line}" }.join("\n")
    puts "#{prefix} ----------------------------"
  end

  desc 'Manage Admin rights'
  command :admin do |c|
    c.desc 'Grant access to db views for a user'
    c.command 'db:grant_view_access' do |g|
      g.flag :user, desc: 'The user to grant access'
      g.flag :role, desc: 'The role that creates views'
      g.flag :schema, desc: 'The schema name', default_value: 'public'

      g.action do |_global_options, options, _args|
        user = options[:user]
        role = options[:role]
        schema = options[:schema]

        if user.nil? || role.nil?
          puts 'User and role are required'
          exit 1
        end
        App.db.grant_view_access(user, role, schema)
      end
    end
  end
end
