# builerではbundle installのみを責務とする。
FROM ruby:3.1.2 as builder

ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

WORKDIR /api

RUN apt-get update -qq && apt-get install -y postgresql-client
# RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs

# # install yarn
# RUN npm install --global yarn

COPY Gemfile ./
COPY Gemfile.lock ./

RUN bundle config set --local disable_checksum_validation true &&\
  bundle config set force_ruby_platform true &&\
  bundle install

FROM ruby:3.1.2

ARG WORKDIR

ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

WORKDIR /api

RUN apt-get update -qq && apt-get install -y postgresql-client

# 前のステージからinstallされたbundel
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY . ./

# CMD実行前にentrypoint.shを通す
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# 開発用サーバーの実行
CMD ["rails", "server", "-b", "0.0.0.0"]
