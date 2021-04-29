# Economic::Rest

[![Build Status](https://semaphoreci.com/api/v1/traels-it/economic-rest/branches/master/badge.svg)](https://semaphoreci.com/traels-it/economic-rest)

[![Coverage Status](https://coveralls.io/repos/bitbucket/traels/economic-rest/badge.svg?branch=master)](https://coveralls.io/bitbucket/traels/economic-rest?branch=master)

Ruby wrapper for the e-conomic REST API, that aims at making working with the API bearable.
E-conomic is a web-based accounting system. For their marketing speak, see http://www.e-conomic.co.uk/about/. More details about their API at http://www.e-conomic.co.uk/integration/integration-partner/'.
The documentation can be found at https://restdocs.e-conomic.com


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'economic-rest'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install economic-rest

## Usage

```ruby
require 'economic/rest'

Economic::Demo.hello
```

Filter text can be added to the all query to avoid getting everything. e.g. a method for finding an accounting year for a specific date

```ruby
def get_accounting_year(date)
    Economic::AccountingYearRepo.all(filter_text: "toDate$gte:#{date}$and:fromDate$lte:#{date}")
end
```

note: you need to use Lower Camel Case for variable names.

### Filter Operators

The allowed filtering operators are:

| Operator | Syntax |
| -------- | --------- |
| Equals   | `$eq:` |
| Not equals | `$ne:` |
| Greater than | `$gt:` |
| Greater than or equal | `$gte:` |
| Less than | `$lt:` |
| Less than or equal | `$lte:` |
| Substring match | `$like:` |
| And also | `$and:` |
| Or else | `$or:` |
| In | `$in:` |
| Not In | `$nin:` |

copy pasta from https://restdocs.e-conomic.com/#specifying-operator-affinity

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec m` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://bitbucket.org/traels/economic-rest. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Economic::Rest project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://bitbucket.org/traels/economic-rest/blob/master/CODE_OF_CONDUCT.md).
