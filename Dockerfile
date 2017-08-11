# Need debian because of the systemd plugin got dependencies on systemd stuff..
FROM fluent/fluentd:v0.14-debian-onbuild

ENV FLUENT_UID=0

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev git" \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && sudo gem install \
        # fluent-plugin-splunkhec \
        fluent-plugin-kubernetes_metadata_filter \
        fluent-plugin-systemd \
        fluent-plugin-prometheus \

    # splunk hec, while waiting for gem to update it to 1.1
    && git clone https://github.com/cmeerbeek/fluent-plugin-splunkhec.git \
    && cd fluent-plugin-splunkhec/ \
    && sudo gem install bundler \
    && bundle install \
    && bundle exec rake install \
    && sudo gem install pkg/fluent-plugin-splunkhec-1.1.gem \
    && cd .. \

    && sudo gem sources --clear-all \
    && SUDO_FORCE_REMOVE=yes \
        apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps \
    && rm -rf /var/lib/apt/lists/* /home/fluent/.gem/ruby/2.3.0/cache/*.gem
