# === Build stage ===
FROM ruby:3.0.5 as Builder

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get update -qq \
    && apt-get install -y nodejs build-essential \
    && npm install --global yarn

WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem update --system
RUN bundle update --bundler
RUN bundle install

COPY app/assets/images /myapp/assets/images
COPY . /myapp

# === Production stage ===
FROM ruby:3.0.5

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get update -qq \
    && apt-get install -y nodejs build-essential wget gnupg2 apt-transport-https ca-certificates vim \
    && npm install --global yarn

RUN apt-get install -y default-mysql-client

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

RUN wget -q --no-check-certificate -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$(curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip \
    && unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver

WORKDIR /myapp

COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY . /myapp
COPY --from=Builder /myapp/public /myapp/public

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
