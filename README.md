# ActsAsResource

Generate rails restful controller for all models.

## Usage

```ruby
###############
# Server Side #
###############

gem 'activeresource'
gem 'activeresource-response' # pagination
gem 'acts_as_resource', github: 'zhulux/acts_as_resource' # widly used restful controller

# routes.rb
mount ActsAsResource::Engine => '/activeresource'

# user.rb
# id   - integer
# name - string
# age  - integer
class User < ApplicationRecord
  scope :name_match ->(name) { where('name like ?', "%#{name}%") }
end

###############
# Client Side #
###############

# application_resource.rb
class ApplicationResource < ActiveResource::Base
  self.site = 'http://127.0.0.1:2000/activeresource'
  add_response_method :my_response
end

# user.rb
class User < ApplicationResource
end

class UsersController < ApplicationController
  # params: page
  # params: per_page
  def index
    users = User.where(age: 10, name_match: 'John')
    @users = Kaminari::PaginatableArray.new(users, {
      limit: users.my_response['X-limit'].to_i,
      offset: users.my_response['X-offset'].to_i,
      total_count: users.my_response['X-total'].to_i
    })
  end
end
```

```bash
./bin/rails c
users = User.all(params: { page: 1, per_page: 1 })
users.my_response.to_hash
```

## Note

The delete method is hard delete.
You can use [paranoia](https://github.com/rubysherpas/paranoia) gem for soft delete.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'acts_as_resource', github: 'zhulux/acts_as_resource'
```

And then execute:
```bash
$ bundle
```

## Scope support
You can modify scopes in models, and call them by passing the parameters with the same names in query string.

Notice that scope **HAVE TO be parameterized** and make sure the client side calls them **with certain params**, which is like the former example, so that you can call it in ActiveResource.

Otherwise, the client side would find the `empty` query strings and **remove them**, then the server side will never know those scopes had been called.

```ruby
# Server side

## Reachable scopes
scope :foo, ->(params) { where(params: params) }
## Unreachable scopes
scope :sorted, -> { order('created_at DESC') }

# Client side

## Good one
Model.where(foo: 'fizzbuzz')
## Bad ones
Model.where(foo: '')
Model.where(foo: [])
Model.where(foo: {})
## Really bad ones
Model.where(sorted)
Model.where(sorted: 1)
```

```
Started GET "/activeresource/investment_preferences.json?filter_location%5B%5D=3&filter_location%5B%5D=4&filter_sector%5B%5D=1&filter_sector%5B%5D=2" for 127.0.0.1 at 2019-12-02 14:54:38 +0800
Processing by ActsAsResource::ResourcesController#index as JSON
  Parameters: {"filter_location"=>["3", "4"], "filter_sector"=>["1", "2"], "resource_name"=>"investment_preferences"}
Creating scope :filter_location. Overwriting existing method InvestmentPreference.filter_location.
Creating scope :filter_sector. Overwriting existing method InvestmentPreference.filter_sector.
  InvestmentPreference Load (47.3ms)  SELECT "investment_preferences".* FROM "investment_preferences"
  ↳ config/initializers/render_views_patch.rb:7
Completed 200 OK in 171ms (Views: 86.9ms | ActiveRecord: 80.3ms)
```

## [Association support](https://github.com/rails/activeresource#associations)

```bash
./bin/rails c
user = User.first
user.investors

## logs
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
