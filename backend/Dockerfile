ARG RUBY_VERSION=3.3.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim

# Rails app lives here
WORKDIR /app

# Set production environment
ENV RAILS_ENV="development"
ENV BUNDLE_PATH="/usr/local/bundle"
ENV EDITOR="nano"

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential default-libmysqlclient-dev git libvips pkg-config

RUN apt-get install nano -y

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Start the server by default, this can be overwritten at runtime
EXPOSE 8000
CMD ["./bin/app", "server"]
