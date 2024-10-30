# Economic::Rest

[![Build Status](https://semaphoreci.com/api/v1/traels-it/economic-rest/branches/master/badge.svg)](https://semaphoreci.com/traels-it/economic-rest)

[![Coverage Status](https://coveralls.io/repos/bitbucket/traels/economic-rest/badge.svg?branch=master)](https://coveralls.io/bitbucket/traels/economic-rest?branch=master)

Ruby wrapper for the e-conomic REST API, that aims at making working with the API bearable.
E-conomic is a web-based accounting system. For their marketing speak, see http://www.e-conomic.co.uk/about/. More details about their API at http://www.e-conomic.co.uk/integration/integration-partner/.
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

The gem started out with an architecture, that was a bit too hard to work with. Going forward this will change significantly. As of now the changes are not breaking, but the old way will be deprecated as the new architecture is implemented. No further development will be made for the old architecture, instead we aim to incrementally become feature complete using the new architecture.
Once all the old models and repos have been converted to the new architecture, a date will be set for when they will be removed.

### New architecure
#### Repos
The gem maps the API endpoint using classes called `Repos`.
All the end points dealing with one resource will be accessible through one repo, for instance all the actions under `/customers` will be accessible through `Economic::Repos::Customer`:

| HTTP method | Endpoint | Repo method |
| -------- | -------- | --------- |
| GET | `/customers`   | `repo.all` |
| POST | `/customers`   | `repo.create(customer_instance)` |
| GET | `/customers/:customerNumber`   | `repo.find(id_or_object_responding_to_id)` |
| PUT | `/customers/:customerNumber`   | `repo.update(customer_instance_with_updated_data)` |
| PATCH | `/customers/:customerNumber`   | *Special case - not yet implemented* |
| DELETE | `/customers/:customerNumber`   | `repo.destroy(id_or_object_responding_to_id)` |

##### `repo.all`
Returns *all* the records for the repo. If there are more than 1.000, it handles the pagination automatically and returns the records in a single array.
`all` can take a filter text if you are not interested in every single record. The allowed filtering operators are:

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

For more details see https://restdocs.e-conomic.com/#specifying-operator-affinity

For now the attribute names must be in lower camelcase when filtering:
```
Economic::Repos::Customer.all(filter: "corporateIdentificationNumber$eq:22001884")
```

#### Credentials

Repos require credentials to know which e-conomic account to connect to. These can be suuplied in two ways:
1. Setting a global set of credentials through `Economic::Configuration` will apply to any repo you initialize:
    ```
    Economic::Configuration.app_secret_token = "Demo"
    Economic::Configuration.agreement_grant_token = "Demo"

    repo = Economic::Repo::Customer.new
    repo.credentials => #<data Economic::Credentials app_secret_token="Demo", agreement_grant_token="Demo">
    ```
2. Supplying a set of credentials when initializing a repo, sets them for that instance only:
    ```
    credentials = Economic::Credentials.new(app_secret_token: "secret", agreement_grant_token: "grant")
    
    repo = Economic::Repo::Customer.new(credentials: credentials)
    repo.credentials => #<data Economic::Credentials app_secret_token="secret", agreement_grant_token="grant">
    ```

#### Nested repos
Some endpoints are nested under other endpoints, e.g. `/customers/:customerNumber/contacts`. This requires the id of the customer, whose contacts you want to manipulate. Therefore the repo must be initialized with an id or model:
```
customer = Economic::Models::Customer.new(id: 12)
repo = Economic::Repos::Customers::Contact.new(customer).new
repo.all => All instances of Economic::Models::Customers::Contact belonging to the customer
```

#### Error handling
An error is raised when the response from e-conomic has one of the following error codes:

| Error Code | Error class |
| -------- | --------- |
| 400 | Economic::BadRequestError |
| 401 | Economic::UnauthorizedError |
| 403 | Economic::ForbiddedError |
| 404 | Economic::NotFoundError |
| 500 | Economic::InternalError |

The error message is the response body from e-conomic.

### Old architecture

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

Bug reports and pull requests are welcome on GitHub at https://github.com/traels-it/economic-rest. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Economic::Rest project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/traels-it/economic-rest/blob/main/CODE_OF_CONDUCT.md).


