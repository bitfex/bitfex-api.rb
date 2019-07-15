require 'json'
require 'net/http'

module Bitfex
  class Api
    attr_accessor :token

    # @param server_url [String] URL of the main server
    # @param auth_server_url [String] URL of the auth server
    def initialize(token: nil, server_url: 'https://bitfex.trade')
      @token = token
      @_server_url = server_url
    end

    # @return [String] server url
    def server_url
      @_server_url
    end

    # @param url [String] set URL of the server
    def server_url=(url)
      @_server_url = url
    end

    # Return account balances
    # @return [Hash<String, Fixnum>] balances
    def balances
      response = request_get('/api/v1/user')
      raise ApiError.new(response['errors'].to_json) unless response['success']

      response['balances']
    end

    # Return list of orders for all pairs
    # @return [Array<Hash>] list of orders (id, pair, amount, price, operation, completed, updated)
    def orders_list(pair)
      response = request_get("/api/v1/orders?pair=#{pair}")
      raise ApiError.new(response['errors'].to_json) unless response['success']
      response['orders']
    end

    # Return list of my orders
    # @return [Array<Hash>] list of my orders (id, pair, amount, price, operation, completed, updated)
    def my_orders
      response = request_get('/api/v1/orders/my')
      raise ApiError.new(response['errors'].to_json) unless response['success']
      response['orders']
    end

    # Delete order by id
    # @param id [Fixnum] order ID
    # @return [TrueClass]
    # @raise ApiError(error_json) if response not success
    def delete_order(id)
      response = request_delete("/api/v1/orders/#{id}")
      raise ApiError.new(response['errors'].to_json) unless response['success']
      true
    end

    # Create new order
    # @param operation [String] operation - one of (buy/sell)
    # @param pair [String] pair (for example: BTC_RUR)
    # @param amount [Decimal] amount in normal units (roubles or bitcoins)
    # @param price [Decimal] price in normal units (roubles or bitcoins)
    # @return [TrueClass]
    # @raise ApiError(error_json) if response not success
    def create_order(operation, pair, amount, price)
      response = request_post(
        '/api/v1/orders',
        order: {
          pair: pair,
          operation: operation,
          amount: amount,
          price: price
        }
      )
      raise ApiError.new(response['error'].to_json) unless response['success']

      true
    end

    private

    def request_post(endpoint, body)
      request(endpoint, Net::HTTP::Post, body)
    end

    def request_delete(endpoint, body = nil)
      request(endpoint, Net::HTTP::Delete, body)
    end

    def request_get(endpoint)
      request(endpoint, Net::HTTP::Get)
    end

    def request(endpoint, klass, body = nil)
      url = @_server_url + endpoint
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.port == 443

      request = klass.new(uri.request_uri, 'Content-Type' => 'application/json')

      request.add_field('X-API-Key', token) if token
      request.body = JSON.dump(body) if body
      response = http.request(request)

      JSON.parse(response.body || '{}')
    end
  end
end
