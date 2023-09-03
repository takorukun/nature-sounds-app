# === Build stage ===
FROM ruby:3.0.5 as Builder

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get update -qq \
    && apt-get install -y nodejs build-essential \
    && npm install --global yarn

RUN yarn --version
RUN node --version
RUN which yarn || true

WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
COPY app/assets/images /myapp/assets/images
RUN gem update --system
RUN bundle update --bundler
RUN bundle install

# === Production stage ===
FROM ruby:3.0.5

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get update -qq \
    && apt-get install -y nodejs build-essential \
    && npm install --global yarn

RUN yarn --version
RUN node --version
RUN which yarn || true

WORKDIR /myapp

COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY . /myapp

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
