# dockerhubからイメージ取得
FROM ruby:3.1.1

# railsに必要な依存ライブラリー追加(build-essential libpq-dev nodejs)
# 参考： https://docs.docker.jp/compose/rails.html
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

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
