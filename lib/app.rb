# frozen_string_literal: true

require 'dotenv'
env_path = File.expand_path('.env', __dir__)
Dotenv.load(env_path)

require 'gli'
require_relative '../lib/avs'
require_relative '../lib/service/db'
require_relative '../lib/service/api/insightvm'
require_relative '../lib/service/mail'

class App
  extend GLI::App
  # TODO: use the ENV for host, db, port
  def self.api
    @api ||= InsightVMApi.new(
      'https://sbginsightvmconsole.standardbank.co.za:3780/api/3',
      'r7admin',
      'P@ssword1234'
    )
  end

  # TODO:  use the ENV for host, db, port
  def self.db
    @db ||= Db.new(host: '127.0.0.1', db: 'avs', user: 'avs', port: 5433)
  end

  def self.mail
    MailService.instance
  end
end
