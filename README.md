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
  class Api::V1::UsersController < ApplicationController
    options do
      {
        schemas: {
          accepts: Company.json_schema,
          returns: Company.json_schema
        },
        meta: { max_per_page: 100 }
      }
    end
  end
```

You can also respond differently depending on request information.

Specifically, you get route details param
coming from Rails routing mechanism and it's a simple hash.
However, you have access to the regular request/response context inside the block,
because just before is being called its context is changed to a controller's method,
defined by this gem. Hence, you can access
[request](http://api.rubyonrails.org/classes/ActionDispatch/Request.html),
[response](http://api.rubyonrails.org/v5.0.1/classes/ActionDispatch/Response.html),
[params](http://api.rubyonrails.org/classes/ActionController/Parameters.html) etc,
like a regular controller method.


```ruby
  class Api::V1::UsersController < ApplicationController
    options do |route_details|
      if route_details[:id] #member route
        {
          schemas: { #params is available through context switching
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
    end
  end
```

The response is always in JSON, but if you need something else (like yaml or XML),
you can always override the default
[`options`](https://github.com/kollegorna/rails_http_options/blob/master/lib/rails_http_options.rb#L16-L25) method.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kollegorna/rails_http_options.
