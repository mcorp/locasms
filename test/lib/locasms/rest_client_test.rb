require 'test_helper'

module LocaSMS
  class RestClientTest < ActiveSupport::TestCase
    def setup
      @callback = 'http://example.com/callback'
      @params = { lgn: 'LOGIN', pwd: 'PASSWORD', url_callback: @callback }
    end

    def test_initialize
      client = LocaSMS::RestClient.new :url, @params

      assert_equal :url, client.base_url
      assert_equal @params, client.base_params
    end

    def test_get__perform_request_with_params
      action = 'sendsms'
      body = '{"status":1,"data":28,"msg":null}'
      client = LocaSMS::RestClient.new(action, @params)

      Net::HTTP.expects(:get_response)
        .returns(OpenStruct.new(body: body))

      client.get(action, @params)
    end

    def test_params_for
      client = LocaSMS::RestClient.new :url, @params

      assert_equal client.params_for(:action),
                   { action: :action }.merge(@params)
      assert_equal client.params_for(:action, p1: 10),
                   { action: :action, p1: 10 }.merge(@params)
    end

    def test_params_for__no_callback
      callback = nil
      params = { lgn: 'LOGIN', pwd: 'PASSWORD', url_callback: callback }
      client = LocaSMS::RestClient.new :url, params

      assert_equal client.params_for(:action),
                   { action: :action, lgn: 'LOGIN', pwd: 'PASSWORD' }
      assert_equal client.params_for(:action),
                   { action: :action, lgn: 'LOGIN', pwd: 'PASSWORD' }
    end

    def test_parse_response__raises
      client = LocaSMS::RestClient.new :url, @params

      assert_raises LocaSMS::InvalidOperation do
        client.parse_response(:action, '0:OPERACAO INVALIDA')
      end

      error = assert_raises LocaSMS::Exception do
        client.parse_response(:action, '{"status":0,"data":null,"msg":"FALHA EPICA"}')
      end
      assert_match(/FALHA EPICA/, error.message)

      assert_raises LocaSMS::InvalidLogin do
        client.parse_response(:action, '{"status":0,"data":null,"msg":"FALHA AO REALIZAR LOGIN"}')
      end

      assert_equal({ 'status' => 1, 'data' => 'non-json return', "msg" => nil },
                   client.parse_response(:action, 'non-json return'))

      assert_equal({ 'status' => 1, 'data' => 28, "msg" => nil },
                   client.parse_response(:action, '{"status":1,"data":28,"msg":null}'))
    end
  end
end
