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

## [Association support](https://github.com/rails/activeresource#associations)

```bash
Started GET "/activeresource/users.json" for 127.0.0.1 at 2019-04-17 10:58:51 +0800
Processing by ActsAsResource::ResourcesController#index as JSON
  Parameters: {"resource_name"=>"users"}
  User Load (0.6ms)  SELECT "users".* FROM "users"
  ↳ config/initializers/render_views_patch.rb:7
Completed 200 OK in 3ms (Views: 1.7ms | ActiveRecord: 0.6ms)


Started GET "/activeresource/investors.json?user_id=1" for 127.0.0.1 at 2019-04-17 10:58:51 +0800
Processing by ActsAsResource::ResourcesController#index as JSON
  Parameters: {"user_id"=>"1", "resource_name"=>"investors"}
  Investor Load (44.0ms)  SELECT "investors".* FROM "investors" WHERE "investors"."user_id" = $1  [["user_id", 1]]
  ↳ config/initializers/render_views_patch.rb:7
Completed 200 OK in 64ms (Views: 1.4ms | ActiveRecord: 45.2ms)
```

Also, you can use the another way.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
