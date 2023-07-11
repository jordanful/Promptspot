# Start with the official Ruby 3.0 image
FROM ruby:3.0.5

# Install Dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Install the necessary libraries
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

# Create a directory for the application and use it
RUN mkdir /promptspot
WORKDIR /promptspot

# Add the Gemfile and install the Gems
ADD Gemfile /promptspot/Gemfile
ADD Gemfile.lock /promptspot/Gemfile.lock
RUN bundle install

# Add the rest of the application
ADD . /promptspot

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Expose the port
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
