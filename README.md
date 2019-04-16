# ActsAsResource

Generate rails restful controller for all models.

## Usage

```ruby
gem 'activeresource'
gem 'acts_as_resource', github: 'zhulux/acts_as_resource'

# routes.rb
mount ActsAsResource::Engine => '/activeresource'

# user.rb
class User < ActiveResource::Base
  self.site = 'http://127.0.0.1:2000/activeresource'
end
```

```bash
./bin/rails c
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'acts_as_resource', github: 'zhulux/acts_as_resource'
```

And then execute:
```bash
$ bundle
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
