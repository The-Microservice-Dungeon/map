# Map Service

The Map API for The Microservice Dungeon project

## Requirements

- Install Ruby 3.0.2 [Installation Guide](https://www.ruby-lang.org/de/documentation/installation/)
- Install Rails 6.1+ [Installation Guide](https://guides.rubyonrails.org/v5.0/getting_started.html#installing-rails)
- Install Postgresql 9.3+ [Postgres.app (MacOS)](https://postgresapp.com/)

## Setup Dev Environment

**With docker**

- Clone the repo
- Run `docker compose up --build`

**Without docker**

- Clone the repo
- Make sure you have Ruby 3.0.2 installed by running `ruby -v`
- Make sure you have Rails 6.1+ installed by running `rails -v`
- Run `bundle install` to install all dependencies
- Start your postgresql service
- Run `rails db:setup` to setup the postgresql database
- Run `rails db:migrate` to run all database migrations
- Run `rails s` to start the server

## Running tests

- Run `bundle exec rspec` to run all spec files

## Kafka Producers

- Run `docker compose -f kafkabroker.yml up`
- Run `rails s`

Produced Kafka messages should now arrive through zookeeper/kafka in docker through `'bootstrap_servers': 'localhost:29092'`
