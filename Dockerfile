# dockerhubからイメージ取得
FROM ruby:3.1.1

# for nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -

# for yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential nodejs yarn vim zlib1g-dev liblzma-dev patch

RUN node -v
RUN yarn -v

RUN gem uninstall bundler
RUN gem install bundler -v 2.3.9

# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
#   && apt-get update \
#   && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -

# RUN apt-get update -qq && apt-get install -y build-essential \
#   libpq-dev \
#   nodejs \
#   yarn

# railsに必要な依存ライブラリー追加(build-essential libpq-dev nodejs)
# 参考： https://docs.docker.jp/compose/rails.html
# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs \
#   nodejs
  #  \
  # yarn

# APP_PATHという変数をセット
ENV APP_PATH /myapp

# /myappというディレクトリー作成
RUN mkdir $APP_PATH

# /myappというディレクトリー移動
WORKDIR $APP_PATH

# ローカルからGemfileをコンテナの/myappのGemfileにコピー
COPY Gemfile $APP_PATH/Gemfile

# ローカルからGemfile.lockをコンテナの/myappのGemfile.lockにコピー
COPY Gemfile.lock $APP_PATH/Gemfile.lock

# Gemfile, Gemfile/lockを元にgemをインストール
RUN bundle install

# ローカルの全てのrailsファイルをコンテナ側にコピー
COPY . $APP_PATH

EXPOSE 3000

USER root
