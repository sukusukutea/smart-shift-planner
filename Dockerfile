FROM ruby:3.2

RUN apt-get update -qq && \
   apt-get install -y build-essential libpq-dev curl && \
   apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
   apt-get install -y nodejs && \
   npm install -g yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

COPY . .

# 本番用のアセットプリコンパイル
RUN RAILS_ENV=production bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bash", "-c", "bundle exec rails server -b 0.0.0.0 -p 3000"]