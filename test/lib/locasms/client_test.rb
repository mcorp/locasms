require 'minitest/autorun'

module LocaSMS
  class ClientTest < Minitest::Test
    def setup
      @rest_client = 'rest_client mock'
      @subject = Client.new :login,
        :password, rest_client: @rest_client, callback: nil
    end

    def test_endpoint_default_url
      domain = LocaSMS::Client::DOMAIN

      endpoint = LocaSMS::Client::ENDPOINT[@subject.type]
      assert_equal endpoint, "http://#{domain}/painel/api.ashx"
    end

    def test_endpoint_shortcode
      domain = LocaSMS::Client::DOMAIN
      subject = LocaSMS::Client.new :login, :password, type: :shortcode

      endpoint = LocaSMS::Client::ENDPOINT[subject.type]
      assert_equal endpoint, "http://#{domain}/shortcode/api.ashx"
    end

    def test_initialize
      assert_equal :login, @subject.login
      assert_equal :password, @subject.password
    end

    def test_deliver__sends_sms
      @subject.expects(:numbers).once.with([:a, :b, :c]).returns('XXX')

      @rest_client.expects(:get).once
        .with(:sendsms, msg: 'given message', numbers:'XXX', url_callback: nil)
        .returns({})

      @subject.deliver 'given message', :a, :b, :c
    end

    def test_deliver__raises_exception
      @subject.expects(:numbers).once.with([:a, :b, :c])
        .raises(LocaSMS::Exception)

      @rest_client.expects(:get).never

      assert_raises LocaSMS::Exception do
        @subject.deliver('given message', :a, :b, :c)
      end
    end

    def test_deliver__with_callback
      @subject.expects(:numbers).once.with([:a, :b, :c]).returns('XXX')

      @rest_client.expects(:get).once
        .with(:sendsms, msg: 'given message', numbers:'XXX', url_callback: 'something')
        .returns({})

      @subject.deliver 'given message', :a, :b, :c, url_callback: 'something'
    end

    def test_deliver__uses_default_callback
      client = LocaSMS::Client.new :login, :password, rest_client: @rest_client, url_callback: 'default'

      client.expects(:numbers).once.with([:a, :b, :c]).returns('XXX')

      @rest_client.expects(:get).once
        .with(:sendsms, msg: 'given message', numbers:'XXX', url_callback: 'default')
        .returns({})

      client.deliver 'given message', :a, :b, :c
    end

    def test_deliver_at__should_send_sms
      @subject.expects(:numbers).once.with([:a, :b, :c]).returns('XXX')

      @rest_client.expects(:get).once
        .with(:sendsms, msg: 'given message', numbers:'XXX', jobdate: 'date', jobtime: 'time', url_callback: nil)
        .returns({})

      LocaSMS::Helpers::DateTimeHelper.expects(:split)
        .once.with(:datetime).returns(%w[date time])

      @subject.deliver_at 'given message', :datetime, :a, :b, :c
    end

    def test_deliver_at__raises_exception
      @subject.expects(:numbers).once.with([:a, :b, :c]).raises(LocaSMS::Exception)

      LocaSMS::Helpers::DateTimeHelper.expects(:split)
        .once.with(:datetime).returns(%w[date time])

      @rest_client.expects(:get).never

      assert_raises LocaSMS::Exception do
        @subject.deliver_at('given message', :datetime, :a, :b, :c)
      end
    end

    def test_deliver_at__with_callback_option
      @subject.expects(:numbers).once.with([:a, :b, :c]).returns('XXX')

      LocaSMS::Helpers::DateTimeHelper.expects(:split)
        .once.with(:datetime).returns(%w[date time])

      @rest_client.expects(:get).once
        .with(:sendsms, msg: 'given message', numbers:'XXX', jobdate: 'date', jobtime: 'time', url_callback: 'something')
        .returns({})

      @subject.deliver_at 'given message', :datetime, :a, :b, :c, url_callback: 'something'
    end

    def test_deliver_at__uses_default_callback
      client = LocaSMS::Client.new :login, :password, rest_client: @rest_client, url_callback: 'default'

      client.expects(:numbers).once.with([:a, :b, :c]).returns('XXX')

      LocaSMS::Helpers::DateTimeHelper.expects(:split)
        .once.with(:datetime).returns(%w[date time])

      @rest_client.expects(:get).once
        .with(:sendsms, msg: 'given message', numbers:'XXX', jobdate: 'date', jobtime: 'time', url_callback: 'default')
        .returns({})

      client.deliver_at 'given message', :datetime, :a, :b, :c
    end

    def test_balance__check_params
      @rest_client.expects(:get).once.with(:getbalance).returns({})

      @subject.balance
    end

    def test_campaign_methods__getstatus
      @rest_client.expects(:get).once.with(:getstatus, id: '12345').returns({})
      @subject.campaign_status '12345'
    end

    def test_campaign_methods__holdsms
      @rest_client.expects(:get).once.with(:holdsms, id: '12345').returns({})
      @subject.campaign_hold '12345'
    end

    def test_campaign_methods__releasesms
      @rest_client.expects(:get).once.with(:releasesms, id: '12345').returns({})
      @subject.campaign_release '12345'
    end
  end
end
