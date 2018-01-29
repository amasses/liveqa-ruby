# LiveQA

[![Build Status](https://travis-ci.org/arkes/liveqa-ruby.svg?branch=master)](https://travis-ci.org/arkes/liveqa-ruby)

LiveQA ruby integration for [LiveQA](https://www.liveqa.io)

## Installation

```sh 
gem install liveqa
```

For Rails in your Gemfile

```ruby
gem 'liveqa'
```

## Configuration

```ruby
LiveQA.configure do |config|
  ## 
  # Account token can be found inside your environment settings
  config.account_token = 'acc_xx'

  ## 
  # Environment token can be found inside your environment settings
  config.environment_token = 'env_xx'
  
  ## 
  # If you use a proxy.
  # default: nil
  # config.proxy_url = ENV['HTTP_PROXY']

  ## 
  # If enabled is set to false nothing is send to the server
  # default: true
  # config.enabled = true

  ## 
  # Extra attributes to be obfuscated
  # default: []
  # config.obfuscated_fields = ['credit_card_number']

  ## 
  # Use an async handler to send data to the liveqa to
  # avoid slowing down your application
  # available option: :sidekiq
  # default: nil
  # config.async_handler = :sidekiq

  ##
  # Options to be passed to the async handler
  # default: {}
  # config.async_options = { queue: 'liveqa' }

  ##
  # Metadata is passed with every request to the server
  # default: nil
  # config.metadata = {
  #.  customer: -> { current_customer.id},
  #.  version: 42
  # }
  #
end
```

## Usage

### Track

Track an event

Attributes:

* `String` event name
* `Hash` event attributes

```ruby
LiveQA.track('my event',
  user_id: 42,
  properties: {
      order_id: 84 
  }
);
```

### Identify

Identify a user

Attributes:

* `String` user id from your database
* `Hash` user attributes

```ruby
LiveQA.identify(42,
  properties: {
    name: 'John Doe' 
  }
);
```

### Watch

Create a watcher

Attributes:

* `String|Integer` template flow name or id
* `Hash` watcher attributes

```ruby
LiveQA.watch('My Flow',
  expected_times: 42
);
```

## Issues

If you have any issue you can report them on github, or contact support@liveqa.io
