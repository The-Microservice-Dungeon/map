# Map Service

The Map API for the Microservice Dungeon projects

## Requirements

- Ruby 3.0+
- Rails 6.1+
- Postgresql 9.3+

## Docker for Postgres

- Setup Docker for your system
- Edit line 'volumes' (10) in docker-compose.yaml, insert your preferred db folder there
- Run `docker-compos up -d` to start docker container

## Setup Dev Environment

- Run `bundle install` to install the dependencies
- Run `rails db:setup` to setup the postgresql database
- Run `rails s` to start the server

## Running tests

- Run `bundle exec rspec` to run all spec files
