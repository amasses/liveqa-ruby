# LiveQA

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
LiveQA.track('my event', { user_id: 42 }, { order_id: 84 });
```

## Issues

If you have any issue you can report them on github, or contact support@liveqa.io
