# BitFex API for ruby

Simple implementation of BitFex.Trade API for ruby.

# Documentation

## Init

```ruby
require 'bitfex'

client = Bitfex::Api.new()
# make auth
client.auth('user@example.com', 'password')
# call API methods
client.balances # => {'BTC' => 15.0}
```

## Methods

Methods documentation could be found in source =/

# Legal

Released under the MIT License: https://opensource.org/licenses/MIT
