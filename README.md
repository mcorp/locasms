# locasms [![Build Status](https://travis-ci.org/mcorp/locasms.png?branch=master)](https://travis-ci.org/mcorp/locasms) [![Dependency Status](https://gemnasium.com/mcorp/locasms.png)](https://gemnasium.com/mcorp/locasms)

Client to consume [LocaSMS api's][0].

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

cli = LocaSMS::Client.new 'LOGIN', 'PASSWORD'

# delivering message to one mobile
cli.deliver 'my message', '1155559999'

# delivering the same message to multiple mobliles at once
cli.deliver 'my message', '1199998888,5500002222'
cli.deliver 'my message', '1199998888', '5500002222'
cli.deliver 'my message', ['1199998888', '5500002222']
cli.deliver 'my message', %w(1199998888 5500002222)

# scheduling the deliver of a message to one mobile
cli.deliver_at 'my message', '2013-10-12 20:33:00', '1155559999'

# scheduling the deliver of a message to multiple mobiles at once
cli.deliver_at 'my message', '2013-10-12 20:33:00', '1199998888,5500002222'
cli.deliver_at 'my message', '2013-10-12 20:33:00', '1199998888', '5500002222'
cli.deliver_at 'my message', '2013-10-12 20:33:00', ['1199998888', '5500002222']
cli.deliver_at 'my message', '2013-10-12 20:33:00', %w(1199998888 5500002222)

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

[0]: http://locasms.com.br/#page_2/
