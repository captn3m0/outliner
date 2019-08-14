FROM ruby:2.6-alpine

WORKDIR /outliner
COPY . /outliner/

RUN gem install bundler && \
    bundle install && \
    apk add --no-cache git openssh-client && \
    echo -e "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    mkdir /root/.ssh

ENTRYPOINT ["/outliner/entrypoint.sh"]
