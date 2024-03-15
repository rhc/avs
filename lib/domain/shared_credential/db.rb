# frozen_string_literal: true

require 'csv'
require_relative 'model'

class Db
  def fetch_shared_credentials
    fetch_view('shared_credential_view') do |row|
      SharedCredential.from_csv(row)
    end
  end

  def fetch_cyberark_shared_credentials(_country_code)
    credentials = fetch_shared_credentials
    credentials.select do |credential|
    end
  end
end
