require 'dotenv'
require 'mail'

env_path = File.expand_path('../../.env', __dir__)
Dotenv.load(env_path)

class MailService
  attr_reader :smtp_server, :smtp_port, :default_sender, :default_recipients, :retries

  @@instance = nil

  def self.instance
    return @@instance if @@instance

    smtp_server = ENV['SMTP_SERVER']
    smtp_port = ENV['SMTP_PORT'].to_i
    default_sender = ENV['SMTP_SENDER']
    default_recipients = ENV['SMTP_RECIPIENTS']
    retries = 5

    puts "server #{smtp_server}:#{smtp_port} from: #{default_sender} to:#{default_recipients}"
    @@instance = new(smtp_server:, smtp_port:, default_sender:,
                     default_recipients:, retries:)
  end

  private_class_method :new

  def initialize(smtp_server:, smtp_port:, default_sender:, default_recipients:, retries:)
    @smtp_server = smtp_server
    @smtp_port = smtp_port
    @default_sender = default_sender
    @default_recipients = default_recipients
    @retries = retries

    Mail.defaults do
      delivery_method :smtp, {
        address: smtp_server,
        port: smtp_port,
        openssl_verify_mode: 'none'
      }
    end
  end

  def send(subject:,
           body:,
           from: @default_sender,
           to: @default_recipients,
           retries: @retries)
    message = Mail.new do
      from from
      to to
      subject subject
      html_part do
        content_type 'text/html; charset=UTF-8'
        body body
      end
    end
    puts message

    begin
      message.deliver!
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      if retries > 0
        sleep 5
        send(from:, to:, subject:, retries: retries - 1)
      else
        puts 'Retry limit exceeded. Email not sent.'
      end
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end
end
