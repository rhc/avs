# frozen_string_literal: true

require 'typhoeus'
require 'json'
require 'base64'
require_relative '../../domain/api'

# InsightVMApi class provides an interface for interacting with the InsightVM API.
# It handles request building, and response parsing for various API endpoints.
#
# @attr_reader [String] base_url The base URL for the InsightVM API
# @attr_reader [String] base_auth The Basic Authentication string used for requests
#
# @example Initializing the API client
#   api = InsightVMApi.new(
#     base_url: 'https://your-insightvm-instance.com',
#     username: 'your_username',
#     password: 'your_password'
#   )
#
# @example Fetching all sites
#   api.fetch_all('/sites') do |site|
#     puts site['name']
#   end
#
# @example Getting a specific site
#   site = api.get('/sites/1')
#   puts site.inspect
class InsightVMApi
  attr_reader :base_url, :base_auth

  # Initializes a new InsightVMApi instance.
  #
  # @param base_url [String] The base URL for the InsightVM API
  # @param username [String] The username for API authentication
  # @param password [String] The password for API authentication
  def initialize(base_url:, username:, password:)
    @base_url = base_url
    @base_auth = ['Basic', Base64.strict_encode64("#{username}:#{password}")].join(' ')
    @options = {
      headers: {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'Authorization' => @base_auth
      }
    }
  end

  # Fetches all resources from a paginated endpoint.
  #
  # @param endpoint [String] The API endpoint to fetch resources from
  # @param opts [Hash] Additional options for the request (e.g., filters)
  # @yield [resource] Gives each resource to the block
  def fetch_all(endpoint, opts = {}, &block)
    params = {
      page: 0,
      size: 100
    }.merge(opts)

    loop do
      response = get("#{endpoint}?#{URI.encode_www_form(params)}")
      break if response.is_a?(Hash) && response[:error]

      resources = response['resources']
      break if resources.nil?

      resources.each(&block)

      current_page = response['page']&.[]('number') || 0
      pages = response['page']&.[]('totalPages') || 0
      break if params[:page] >= pages || current_page + 1 >= pages

      params[:page] += 1
    end
  end

  # Performs a GET request to the specified path.
  #
  # @param path [String] The API path to send the GET request to
  # @param params [Hash] Query parameters to include in the request
  # @return [Hash] The parsed JSON response or an error hash
  def get(path, params = {})
    run_request(:get, path, params:)
  end

  # Performs a POST request to the specified endpoint.
  #
  # @param endpoint [String] The API endpoint to send the POST request to
  # @param body [Hash] The request body to be sent as JSON
  # @return [Hash] The parsed JSON response or an error hash
  def post(endpoint, body)
    run_request(:post, endpoint, body: body.to_json)
  end

  # Performs a DELETE request to the specified endpoint.
  #
  # @param endpoint [String] The base API endpoint
  # @param id [String, Integer] The ID of the resource to delete
  # @param attempts [Integer] The number of delete attempts (for internal use)
  def delete(endpoint, id, _attempts = 0)
    response = run_request(:delete, "#{endpoint}/#{id}")

    if response.is_a?(Hash) && response[:error]
      puts "Error deleting #{endpoint}/#{id}: #{response[:error]}"
    else
      puts "#{endpoint}/#{id} deleted successfully."
    end
  end

  # Performs a PATCH request to the specified endpoint.
  #
  # @param endpoint [String] The API endpoint to send the PATCH request to
  # @param body [Hash] The request body to be sent as JSON
  def patch(endpoint, body)
    response = run_request(:patch, endpoint, body: body.to_json)

    return unless response.is_a?(Hash) && response[:error]

    puts "Error PATCH #{endpoint}: #{response[:error]}"
  end

  # Performs a PUT request to the specified endpoint.
  #
  # @param endpoint [String] The API endpoint to send the PUT request to
  # @param body [Hash] The request body to be sent as JSON
  def put(endpoint, body)
    response = run_request(:put, endpoint, body: body.to_json)

    return unless response.is_a?(Hash) && response[:error]

    puts "Error PUT #{endpoint}: #{response[:error]}"
  end

  # Fetches data from an endpoint with retry logic.
  #
  # @param endpoint [String] The API endpoint to fetch data from
  # @param attempts [Integer] The number of fetch attempts (for internal use)
  # @yield [response] Gives the successful response to the block
  # @raise [RuntimeError] If the maximum number of retries is exceeded
  def fetch(endpoint, attempts = 0)
    max_retries = 5
    response = get(endpoint)

    if response.is_a?(Hash) && response[:error]
      raise "Network error after #{max_retries} attempts: #{response[:error]}" unless attempts < max_retries

      sleep 2**attempts
      fetch(endpoint, attempts + 1)

    else
      yield response
    end
  end

  private

  # Runs an HTTP request using Typhoeus.
  #
  # @param method [Symbol] The HTTP method (:get, :post, etc.)
  # @param path [String] The API path for the request
  # @param options [Hash] Additional options for the request
  # @return [Hash] The parsed JSON response or an error hash
  def run_request(method, path, options = {})
    request = Typhoeus::Request.new(
      "#{@base_url}#{path}",
      method:,
      headers: @options[:headers],
      **options
    )

    response = request.run

    if response.success?
      JSON.parse(response.body)
    elsif response.timed_out?
      { error: 'Request timed out' }
    elsif response.code.zero?
      { error: response.return_message }
    else
      { error: "HTTP request failed: #{response.code}" }
    end
  end

  def confirm_action(prompt)
    print "#{prompt} (y/n): "
    gets.chomp.downcase == 'y'
  end
end

