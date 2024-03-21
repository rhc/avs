#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'
require 'base64'
require 'openssl'
require_relative '../../domain/api'

class InsightVMApi
  attr_reader :http, :base_auth, :base_url

  def fetch_all(endpoint, name: '', size: 50, &block)
    page = 0

    loop do
      full_url = @base_url.dup
      full_url.path += endpoint
      full_url.query = URI.encode_www_form({ page:, size:, name: })
      request = Net::HTTP::Get.new(full_url)
      request['Authorization'] = @base_auth
      response = @http.request(request)
      break unless response.is_a?(Net::HTTPSuccess)

      json_response = JSON.parse(response.body)
      resources = json_response['resources']
      # puts "resources #{resources}"
      resources.each(&block) # equivalent to resources.each {|resource| yield resource}

      # Check if this is the last page
      pages = json_response['page']&.[]('totalPages') || 0
      break if page >= pages

      page += 1
    end
  end

  def initialize(base_url, username, password)
    @base_url = URI(base_url)
    @http = Net::HTTP.new(@base_url.host, @base_url.port)
    @http.use_ssl = true
    @http.verify_mode = OpenSSL::SSL::VERIFY_NONE # Reminder: Adjust for production use
    @base_auth = ['Basic', Base64.strict_encode64("#{username}:#{password}")].join(' ')
  end

  private

  # return the response.body.to_json if Success
  # else response,message and response.status if failure
  def post(endpoint, params)
    # Construct the request
    uri = URI("#{@base_url}#{endpoint}")
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = @base_auth
    request.body = params.to_json
    p request.body
    # Send the request
    response = @http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      puts 'Success!'
      # You can parse the response body if needed
      JSON.parse(response.body)
    else
      puts "Error creating site. Status code: #{response.code}, Response body: #{response.body}"
      nil
    end
  end

  def delete(endpoint, id)
    uri = URI("#{@base_url}#{endpoint}/#{id}")
    request = Net::HTTP::Delete.new(uri)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = @base_auth
    # Send the requesbody
    response = @http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      puts 'Success!'
    else
      puts "Error deleting #{endpoint}/#{id} Status code: #{response.code}, Response body: #{response.body}"
    end
  end

  def put(endpoint, body)
    # Construct the request
    uri = URI("#{@base_url}#{endpoint}")
    request = Net::HTTP::Put.new(uri)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = @base_auth
    request.body = JSON.generate(body)
    # Send the requesbody
    response = @http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      puts 'Success!'
      # You can parse the response body if needed
      parsed_response = JSON.parse(response.body)
      puts parsed_response
    else
      puts "Error creating site. Status code: #{response.code}, Response body: #{response.body}"
    end
  end

  def fetch(endpoint)
    uri = URI("#{@base_url}#{endpoint}")
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = @base_auth

    response = @http.request(request)

    case response
    when Net::HTTPSuccess
      yield JSON.parse(response.body)
    else
      raise "Error: #{response.code} - #{response.message}"
    end
  end
end
