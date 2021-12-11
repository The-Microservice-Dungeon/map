FROM ruby:3.0.2

RUN apt-get update -qq && apt-get install -y postgresql-client
WORKDIR /map

# Set up the dependencies ( Gems )
COPY Gemfile /map/Gemfile
COPY Gemfile.lock /map/Gemfile.lock
RUN bundle install

COPY . /map

# # Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Configure the main process to run when running the image
EXPOSE 3000
CMD ["rails", "s", "-b", "0.0.0.0", "-p", "3000"]
