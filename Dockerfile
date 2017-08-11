# Need debian because of the systemd plugin got dependencies on systemd stuff..
FROM fluent/fluentd:v0.14-debian-onbuild

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev" \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && sudo gem install \
        fluent-plugin-splunkhec:1.1 \
        fluent-plugin-kubernetes_metadata_filter \
        fluent-plugin-systemd \
        fluent-plugin-prometheus \
    && sudo gem sources --clear-all \
    && SUDO_FORCE_REMOVE=yes \
        apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps \
    && rm -rf /var/lib/apt/lists/* /home/fluent/.gem/ruby/2.3.0/cache/*.gem
