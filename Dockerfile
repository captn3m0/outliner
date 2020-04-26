FROM ruby:2.7-alpine

WORKDIR /outliner
COPY . /outliner/

RUN gem install bundler && \
    bundle install && \
    apk add --no-cache git openssh-client rsync && \
    echo -e "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    mkdir /root/.ssh

ENTRYPOINT ["/outliner/entrypoint.sh"]
