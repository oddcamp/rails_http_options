# RailsHttpOptions

Simple gem that allows you to handle HTTP OPTIONS in Rails.
Ideal for API introspection, like fetching request/response schemas and other
meaningful information.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_http_options'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_http_options

## Usage
Include `RailsHttpOptions` in your application controller.
Then add a Rails route in your routes.rb denoting that you want to handle all
HTTP OPTIONS in `option` method, defined by this gem.

```ruby
  match '*path', {
    controller: 'application',
    action: 'options',
    constraints: { method: 'OPTIONS' },
    via: [:options]
  }
```

Then in any of your resource-based controller, add your options response:

```ruby
  options do
    {
      schemas: {
        accepts: Company.json_schema,
        returns: Company.json_schema
      },
      meta: { max_per_page: 100 }
    }
  end
```

You can also respond differently depending on request information.
Specifically, you get 3 params in the block:
* route details, coming from Rails routing mechanism and it's a simple hash
* (rails) request object (`ActionDispatch::Request`)
* params object (`ActionController::Parameters`)

```ruby
  options do |route_details, request, params|
    if route_details[:id] #member route
      {
        schemas: {
          accepts: Company.find(params[:id]).introspection_schema,
          returns: Company.find(params[:id]).introspection_schema,
        }
      }
    else #collection route
      {
        schemas: {
          returns: [Company.introspection_schema]
        },
        meta: { max_per_page: 100 }
      }
  end
```

The response is always in JSON, but if you need something else (like yaml or XML),
you can always override the default [`options`]() method.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rails_http_options.
