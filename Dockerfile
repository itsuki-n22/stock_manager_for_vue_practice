FROM ruby:2.7.1


# yarn
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
apt-get install -y nodejs 

RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler
COPY . /myapp
RUN bundle config set path 'vendor/bundle'
RUN cat .bashrc-custom >> /root/.bashrc
RUN bundle install
RUN yarn install --check-files

# Add a script to be executed every time the container starts.
#COPY entrypoint.sh /usr/bin/
#RUN chmod +x /usr/bin/entrypoint.sh
#ENTRYPOINT ["entrypoint.sh"]
#EXPOSE 3000
#
## Start the main process.
#CMD ["rails", "server", "-b", "0.0.0.0"]
