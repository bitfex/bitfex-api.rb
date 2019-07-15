require 'test_helper'

require 'bitfex'

class BitfexTest < Minitest::Test
  def test_initialize
    client = Bitfex::Api.new(server_url: 'http://localhost/')
    assert_equal 'http://localhost/', client.server_url
  end

  def test_default_server_url
    client = Bitfex::Api.new
    assert_equal 'https://bitfex.trade', client.server_url
  end

  def test_set_server_url
    client = Bitfex::Api.new
    client.server_url = 'https://google.com/'
    assert_equal 'https://google.com/', client.server_url
  end

  def test_balances_success
    stub_request(:get, "https://bitfex.trade/api/v1/user")
      .with(headers: { 'X-API-Key' => '123' })
      .to_return(status: 200, body: '{"success":true,"balances":{"BTC":10.5}}')

    client = Bitfex::Api.new(token: '123')
    assert_equal({ 'BTC' => 10.5 }, client.balances)
  end

  def test_balances_failure
    stub_request(:get, "https://bitfex.trade/api/v1/user")
      .with(headers: { 'X-API-Key' => '123' })
      .to_return(status: 403, body: '{"success":false,"errors":["TEST"]}')

    assert_raises Bitfex::ApiError do
      client = Bitfex::Api.new(token: '123')
      client.balances
    end
  end

  def test_orders_list_success
    stub_request(:get, "https://bitfex.trade/api/v1/orders?pair=BTC_RUR")
      .with(headers: { 'X-API-Key' => '123' })
      .to_return(status: 200, body: '{"success":true,"orders":[{"id":1}]}')

    client = Bitfex::Api.new(token: '123')
    assert_equal([{'id' => 1}], client.orders_list('BTC_RUR'))
  end

  def test_orders_list_faulure
    stub_request(:get, "https://bitfex.trade/api/v1/orders?pair=BTC_RUR")
      .with(headers: { 'X-API-Key' => '123' })
      .to_return(status: 403, body: '{"success":false,"errors":["TEST"]}')

    assert_raises Bitfex::ApiError do
      client = Bitfex::Api.new(token: '123')
      client.orders_list('BTC_RUR')
    end
  end

  def test_my_orders_success
    stub_request(:get, "https://bitfex.trade/api/v1/orders/my")
      .with(headers: { 'X-API-Key' => '123' })
      .to_return(status: 200, body: '{"success":true,"orders":[{"id":1}]}')

    client = Bitfex::Api.new(token: '123')
    assert_equal([{'id' => 1}], client.my_orders)
  end

  def test_my_orders_faulure
    stub_request(:get, "https://bitfex.trade/api/v1/orders/my")
      .with(headers: { 'X-API-Key' => '123' })
      .to_return(status: 403, body: '{"success":false,"errors":["TEST"]}')

    assert_raises Bitfex::ApiError do
      client = Bitfex::Api.new(token: '123')
      client.my_orders
    end
  end

  def test_delete_order_success
    stub_request(:delete, 'https://bitfex.trade/api/v1/orders/1')
      .with(headers: { 'X-API-Key' => '123' })
      .to_return(status: 200, body: '{"success":true}')

    client = Bitfex::Api.new(token: '123')
    assert_equal true, client.delete_order(1)
  end

  def test_delete_order_failure
    stub_request(:delete, 'https://bitfex.trade/api/v1/orders/1')
      .with(headers: { 'X-API-Key' => '123' })
      .to_return(status: 400, body: '{"success":false,"errors":["TEST"]}')

    assert_raises Bitfex::ApiError do
      client = Bitfex::Api.new(token: '123')
      client.delete_order(1)
    end
  end

  def test_create_order_success
    stub_request(:post, 'https://bitfex.trade/api/v1/orders')
      .with(body: "{\"order\":{\"pair\":\"BTC_RUR\",\"operation\":\"buy\",\"amount\":1.0,\"price\":60000.0}}",
            headers: { 'X-API-Key' => '123' })
      .to_return(status: 200, body: '{"success":true}')

    client = Bitfex::Api.new(token: '123')
    assert_equal true, client.create_order(:buy, 'BTC_RUR', 1.0, 600_00.0)
  end

  def test_create_order_failure
    stub_request(:post, 'https://bitfex.trade/api/v1/orders')
      .with(
        body: '{"order":{"pair":"BTC_RUR","operation":"buy","amount":1.0,"price":60000.0}}',
        headers: { 'X-API-Key' => '123' }
      )
      .to_return(status: 403, body: '{"success":false,"errors":["TEST"]}')

    assert_raises Bitfex::ApiError do
      client = Bitfex::Api.new(token: '123')
      client.create_order(:buy, 'BTC_RUR', 1.0, 600_00.0)
    end
  end
end
