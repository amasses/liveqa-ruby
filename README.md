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
  config.api_key = 'your-api-key'
end
```

## Usage

```ruby
LiveQA.track('my event', { 
    user_id: 42,
    properties: {
        order_id: 84 
    }
});
```

## Issues

If you have any issue you can report them on github, or contact support@liveqa.io
