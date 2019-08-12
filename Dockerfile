FROM ruby:2.6-alpine

WORKDIR /outliner
COPY . /outliner/

RUN gem install bundler && \
    bundle install

ENTRYPOINT ["/outliner/entrypoint.sh"]
