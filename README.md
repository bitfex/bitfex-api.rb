[![Gem Version](https://badge.fury.io/rb/bitfex.svg)](https://badge.fury.io/rb/bitfex)

# BitFex API for ruby

Simple implementation of BitFex.Trade API for ruby.

# Documentation

## Init

```ruby
require 'bitfex'

client = Bitfex::Api.new
# make auth
client.auth('user@example.com', 'password')
# call API methods
client.balances # => {'BTC' => 15.0}
```

## Methods

All available methods documentation: http://www.rubydoc.info/gems/bitfex/

# Legal

Released under the MIT License: https://opensource.org/licenses/MIT
