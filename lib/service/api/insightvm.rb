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

  # Fetchs all resources
  #
  # @param [String]
  # @param [Hash] optional parameters: page, size, type, name, sort
  def fetch_all(endpoint, opts = {}, &block)
    params = {
      page: 0,
      size: 100,
      read_timeout: 5
    }.merge opts
    loop do
      full_url = @base_url.dup
      full_url.path += endpoint
      full_url.query = URI.encode_www_form(
        params
      )
      request = Net::HTTP::Get.new(full_url)
      request['Authorization'] = @base_auth
      @http.read_timeout = params[:read_timeout]
      response = @http.request(request)
      unless response.is_a?(Net::HTTPSuccess)
        puts "Error with code #{response.code}"
        break
      end

      json_response = JSON.parse(response.body)
      resources = json_response['resources']
      break if resources.nil?

      resources.each(&block) # equivalent to resources.each {|resource| yield resource}

      # Check if this is the last page
      current_page = json_response['page']&.[]('number') || 0
      pages = json_response['page']&.[]('totalPages') || 0
      break if params[:page] >= pages
      break if current_page + 1 >= pages

      params[:page] += 1
    end
  rescue Net::ReadTimeout
    opts[:read_timeout] = 2 * params[:read_timeout] || 30
    raise 'Fail after multiple attempts' if opts[:read_timeout] > 300

    puts "Increase the timeout to #{opts[:read_timeout]}"
    fetch_all(endpoint, opts, &block)
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
    # Send the request
    response = @http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      # puts 'Success!'
      # You can parse the response body if needed
      JSON.parse(response.body)
    else
      puts "Error with status code: #{response.code}, Response body: #{response.body}"
      nil
    end
  end

  def delete(endpoint, id, attempts = 0)
    uri = URI("#{@base_url}#{endpoint}/#{id}")
    request = Net::HTTP::Delete.new(uri)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = @base_auth
    # Send the requesbody
    response = @http.request(request)
    case response
    when Net::HTTPSuccess
      puts "#{endpoint}/#{id} deleted successfully."
    when Net::ReadTimeout
      delete(endpoint, id, attempts + 1) if attempts < 5
    else
      puts "Error deleting #{endpoint}/#{id} Status code: #{response.code}, Response body: #{response.body}"
    end
  end

  def patch(endpoint, body)
    # Construct the request
    uri = URI("#{@base_url}#{endpoint}")
    request = Net::HTTP::Patch.new(uri)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = @base_auth
    request.body = JSON.generate(body)
    # Send the requesbody
    response = @http.request(request)

    return if response.is_a?(Net::HTTPSuccess)

    puts "Error PATCH #{endpoint}. Status code: #{response.code}\n Response body: #{response.body}"
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

    return if response.is_a?(Net::HTTPSuccess)

    puts "Error PUT #{endpoint}. Status code: #{response.code}, Response body: #{response.body}"
  end

  def fetch(endpoint, attempts = 0)
    max_retries = 5
    uri = URI("#{@base_url}#{endpoint}")
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = @base_auth
    response = @http.request(request)
    raise "HTTP Error #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

    yield JSON.parse(response.body)
  rescue Net::ReadTimeout => e
    puts "Attempts #{attempts}"
    raise "Network error after #{max_retries} #{e.message}" unless attempts < max_retries

    sleep 2**attempts
    fetch(endpoint, attempts + 1)
  else
    # TODO
  end
end
