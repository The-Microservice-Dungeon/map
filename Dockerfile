FROM ruby:3.0.2-alpine as builder

RUN apk update && apk upgrade
RUN apk add --update alpine-sdk tzdata postgresql-client && rm -rf /var/cache/apk/*

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/
ENV RAILS_ENV=production
ENV SECRET_KEY_BASE mykey
RUN bundle install --deployment --jobs=4 --without development test
COPY . $APP_HOME
RUN rm -rf $APP_HOME/tmp/*

FROM ruby:3.0.2-alpine
RUN apk update && apk add --update tzdata && rm -rf /var/cache/apk/*

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY --from=builder /app $APP_HOME
ENV RAILS_ENV=production
ENV SECRET_KEY_BASE mykey
RUN bundle config --local path vendor/bundle
RUN bundle config --local without development:test:assets

EXPOSE 3000:3000
CMD rm -f tmp/pids/server.pid \
  && bundle exec rails db:migrate \
  && bundle exec rails s -b 0.0.0.0 -p 3000
