# OperatorRecordable

[![Gem Version](https://badge.fury.io/rb/operator_recordable.svg)](https://badge.fury.io/rb/operator_recordable)
[![Build](https://github.com/yujideveloper/operator_recordable/workflows/Build/badge.svg)](https://github.com/yujideveloper/operator_recordable/actions?query=workflow%3ABuild)
[![Maintainability](https://api.codeclimate.com/v1/badges/aaa0fcd567da9232a847/maintainability)](https://codeclimate.com/github/yujideveloper/operator_recordable/maintainability)

OperatorRecordable is a Rails plugin gem that makes your ActiveRecord models to be saved or logically deleted with automatically set `created_by`, `updated_by`, and `deleted_by`.
Also it makes `creator`, `updater`, and `deleter` `belongs_to` association if a class has `created_by`, `updated_by`, or `deleted_by`.

This gem is inspired by [RecordWithOperator](https://github.com/nay/record_with_operator).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'operator_recordable'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install operator_recordable

## Usage

### Configuration

#### Initialize `OperatorRecordable`

``` ruby
# config/initializers/operator_recordable.rb
OperatorRecordable.config = {
  operator_class_name: "Operator",
  creator_column_name: "created_by",
  updater_column_name: "updated_by",
  deleter_column_name: "deleted_by",
  creator_association_name: "creator",
  updater_association_name: "updater",
  deleter_association_name: "deleter",
  operator_association_options: {},
  operator_association_scope: nil,
  store: :thread_store
}
```

##### Options

| Name | Type | Description | Default |
|:-----|:-----|:------------|:--------|
| `operator_class_name` | String | class name of your operator model. | `"Operator"` |
| `creator_column_name` | String | column name of creator. | `"created_by"` |
| `updater_column_name` | String | column name of updater. | `"updated_by"` |
| `deleter_column_name` | String | column name of deleter. | `"deleted_by"` |
| `creator_association_name` | String | association name of creator. | `"creator"` |
| `updater_association_name` | String | association name of updater. | `"updater"` |
| `deleter_association_name` | String | association name of deleter. | `"deleter"` |
| `operator_association_options` | Hash | options of operator associations. e.g. `{ touch: true }` | `{}` |
| `operator_association_scope` | Proc | The scope of operator associations. e.g. `-> { with_deleted }`  | `nil` |
| `store` | Enum | operator store. any value of `:thread_store`, `:request_store` or `:current_attributes_store` | `:thread_store` |

#### Include `OperatorRecordable` in your model

``` ruby
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include OperatorRecordable::Extension
end
```

#### Activate `OperatorRecordable` in your model

You can specify which action you want to save operator like this.
``` ruby
class Post < ApplicationRecord
  record_operator_on :create, :update, :destroy
end
```

OperatorRecordable needs to know who is currently operating. For that, you need to set operator through a following way in a `before_action` callback, etc.
``` ruby
OperatorRecordable.operator = current_operator
```

### Stores

#### `:thread_store`

This store is implemented by `Thread.current`.  
This is default store.


#### `:request_store`

This store is implemented by using [RequestStore gem](https://github.com/steveklabnik/request_store).  
So, this requires RequestStore gem.

RequestStore must be loaded before OperatorRecordable.

``` ruby
gem "request_store"
gem "operator_recordable"
```
Or

``` ruby
require "request_store"
require "operator_recordable"
```

Otherwise, you need to load it yourself.
``` ruby
require "operator_recordable/store/request_store"
```

#### `:current_attributes_store`

This store is implemented by using [`ActiveSupport::CurrentAttributes`](https://api.rubyonrails.org/v5.2.0/classes/ActiveSupport/CurrentAttributes.html).  
So, this requires ActiveSupport 5.2 or later.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yujideveloper/operator_recordable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
