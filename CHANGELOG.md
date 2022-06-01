## Unreleased

### Changes

* Support discard gem for soft deletes
  + [PR#31](https://github.com/yujideveloper/operator_recordable/pull/31)
* Get rid of needless guard clauses for ActiveSupport 5.1 and older
  + [PR#32](https://github.com/yujideveloper/operator_recordable/pull/32)

### Misc

* Fix RuboCop offenses
  + [PR#33](https://github.com/yujideveloper/operator_recordable/pull/33)


## 1.2.0 (2022-04-26)

### Changes

* Make associations optional
  + [PR#28](https://github.com/yujideveloper/operator_recordable/pull/28)

### Misc

* CI against for Rails 7.0 running on Ruby 3.1
  + [PR#26](https://github.com/yujideveloper/operator_recordable/pull/26)
* Call `super` in `OperatorRecordable::Recorder#initialize`
  + [PR#30](https://github.com/yujideveloper/operator_recordable/pull/30)


## 1.1.0 (2022-01-07)

### Changes

* Add gem metadata
  + [PR#24](https://github.com/yujideveloper/operator_recordable/pull/24)
* Drop Ruby 2.4 support
  + [PR#25](https://github.com/yujideveloper/operator_recordable/pull/25)
* Drop ActiveRecord 5.0 and 5.1 support
  + [PR#25](https://github.com/yujideveloper/operator_recordable/pull/25)

### Misc

* Introduce Appraisal
  + [PR#19](https://github.com/yujideveloper/operator_recordable/pull/19)
* CI against for ActiveRecord 6.1 and 7.0
  + [PR#19](https://github.com/yujideveloper/operator_recordable/pull/19)
  + [PR#22](https://github.com/yujideveloper/operator_recordable/pull/22)
* Use GitHub Actions and stop using Travis CI
  + [PR#20](https://github.com/yujideveloper/operator_recordable/pull/20)
* CI against for Ruby 3.0 and 3.1
  + [PR#23](https://github.com/yujideveloper/operator_recordable/pull/23)
  + [PR#25](https://github.com/yujideveloper/operator_recordable/pull/25)
* Require MFA to release gem
  + [PR#24](https://github.com/yujideveloper/operator_recordable/pull/24)


## 1.0.0 (2020-10-16)

### Changes

* Support Ruby 2.7
  + [PR#14](https://github.com/yujideveloper/operator_recordable/pull/14)


## 0.4.0 (2019-08-22)

### Changes

* Support ActiveRecord 6.0.0
  + [PR#13](https://github.com/yujideveloper/operator_recordable/pull/13)

### Misc

* Improve rspec and CI
  + [PR#11](https://github.com/yujideveloper/operator_recordable/pull/11)


## 0.3.0 (2018-10-05)

### Breaking changes

* Change mixin module from `OperatorRecordable` to `OperatorRecordable::Extension`
  + [PR#5](https://github.com/yujideveloper/operator_recordable/pull/5)


## 0.2.0 (2018-09-27)

### Changes

* Add association name options
  + [PR#2](https://github.com/yujideveloper/operator_recordable/pull/2)
* Modify not to define unnecessary class methods for ActiveRecord model
  + [PR#3](https://github.com/yujideveloper/operator_recordable/pull/3)

### Misc

* Remove unecessary `require`
  + [PR#4](https://github.com/yujideveloper/operator_recordable/pull/4)


## 0.1.1 (2018-09-19)

### Misc

* Refactor internal structures
  + [PR#1](https://github.com/yujideveloper/operator_recordable/pull/1)


## 0.1.0 (2018-09-14)

* Initial release
