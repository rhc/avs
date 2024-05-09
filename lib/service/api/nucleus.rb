# frozen_string_literal: true

require 'typhoeus'
require 'json'

class NucleusApi
  BASE_URL = 'https://orangecyberdefense.nucleussec.com/nucleus/api'

  def initialize(api_key)
    @options = {
      headers: {
        'Accept' => 'application/json',
        'x-apikey' => api_key
      }
    }
  end

  def fetch(model_class)
    get(model_class.url_path).map do |data|
      # p data
      model_class.new(data)
    end
  end

  # Generic GET request
  def get(path)
    request = Typhoeus::Request.new(
      "#{BASE_URL}#{path}",
      method: :get,
      headers: @options[:headers]
    )
    run_request(request)
  end

  # Generic POST request
  def post(path, body)
    request = Typhoeus::Request.new(
      "#{BASE_URL}#{path}",
      method: :post,
      headers: @options[:headers],
      body: body.to_json
    )
    run_request(request)
  end

  # Generic PUT request
  def put(path, body)
    request = Typhoeus::Request.new(
      "#{BASE_URL}#{path}",
      method: :put,
      headers: @options[:headers],
      body: body.to_json
    )
    run_request(request)
  end

  # Runs the request and handles the response
  def run_request(request)
    response = request.run
    if response.success?
      JSON.parse(response.body)
    elsif response.timed_out?
      { error: 'Request timed out' }
    elsif response.code == 0
      { error: response.return_message }
    else
      { error: 'HTTP request failed', status_code: response.code }
    end
  end

  def download(path)
    download_request = Typhoeus::Request.new(
      "#{BASE_URL}#{path}",
      method: :get,
      headers: @options[:headers].merge('Accept' => 'application/octet-stream')
    )
    download_file(download_request)
  end

  def download_file(request)
    response = request.run
    if response.success?
      response.body
    else
      puts "Failed to download file: HTTP #{response.code}"
      nil
    end
  end




end
