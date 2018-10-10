# locasms
[![Gem Version](https://badge.fury.io/rb/locasms.svg)](http://badge.fury.io/rb/locasms) [![Build Status](https://travis-ci.org/mcorp/locasms.png?branch=master)](https://travis-ci.org/mcorp/locasms) [![Code Climate](https://codeclimate.com/github/mcorp/locasms.png)](https://codeclimate.com/github/mcorp/locasms) [![Inline docs](http://inch-ci.org/github/mcorp/locasms.svg?branch=master)](http://inch-ci.org/github/mcorp/locasms)

> :warning: After `February, 10, 2018` the base IP of the service will change as noticed on this [issue](https://github.com/mcorp/locasms/issues/21). If you don't upgrade to version `0.3.1` your app will stop delivering SMS.

Client to consume API's from [LocaSMS][0] and its Short Code SMS version [SMS Plataforma][1].

## Installation

Add this line to your application's Gemfile:

    gem 'locasms'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install locasms

## Usage

Simple example:

```ruby
require 'locasms'

# Default:
cli = LocaSMS::Client.new 'LOGIN', 'PASSWORD'

# Short Code:
cli = LocaSMS::Client.new 'LOGIN', 'PASSWORD', type: :shortcode

# With default url callback (optional):
cli = LocaSMS::Client.new 'LOGIN', 'PASSWORD', url_callback: 'http://url.to/callback'

# delivering message to one mobile
cli.deliver 'my message', '1155559999'

# delivering the same message to multiple mobliles at once
cli.deliver 'my message', '1199998888,5500002222'
cli.deliver 'my message', '1199998888', '5500002222'
cli.deliver 'my message', ['1199998888', '5500002222']
cli.deliver 'my message', %w(1199998888 5500002222)

# delivering message with url callback
cli.deliver 'my message', '1155559999', url_callback: 'http://url.to/callback'

# scheduling the deliver of a message to one mobile
cli.deliver_at 'my message', '2013-10-12 20:33:00', '1155559999'

# scheduling the deliver of a message to multiple mobiles at once
cli.deliver_at 'my message', '2013-10-12 20:33:00', '1199998888,5500002222'
cli.deliver_at 'my message', '2013-10-12 20:33:00', '1199998888', '5500002222'
cli.deliver_at 'my message', '2013-10-12 20:33:00', ['1199998888', '5500002222']
cli.deliver_at 'my message', '2013-10-12 20:33:00', %w(1199998888 5500002222)

# scheduling the deliver of a message with url callback
cli.deliver_at 'my message', '2013-10-12 20:33:00', '1155559999', url_callback: 'http://url.to/callback'

# geting the remaining balance
cli.balance

# geting the status of a campaign
cli.campaign_status '0000'

# holding a campaign
cli.campaign_hold '0000'

# resuming a campaign
cli.campaign_release '0000'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[0]: http://locasms.com.br
[1]: http://smsplataforma.com.br
