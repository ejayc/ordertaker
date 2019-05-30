# Ordertaker

Ordertaker is a Rails app that imports CSV file that contains object state logs. It has the ability to search the logs by passing in 3 parameters: Object type, id and timestamp.

## Pre-requisites

1. Ruby 2.4.0
2. Rails 5.x
3. PostgreSQL 9.x

## Installation
1. `bundle install`
2. `rails db:create`
3. `rails db:migrate`

## Start The Application

Start the server using the command below. If everything went well you should be able to access the application at http://localhost:3000

```
bin/rails s
```

## Running the test
This app is using RSpec for testing. You can run the test suites using: `rspec`
