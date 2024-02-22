FROM ruby:3.3-alpine3.19

RUN apk add --no-cache git openssh-client rsync && \
    echo -e "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    mkdir /root/.ssh

WORKDIR /outliner
COPY . /outliner/

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc && \
    apk add --no-cache alpine-sdk && \
    gem update --system && \
    gem install bundler && \
    bundle install && \
    apk del --no-cache alpine-sdk && \
    rm ~/.gemrc

ENTRYPOINT ["/outliner/entrypoint.sh"]
