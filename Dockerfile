# Need debian because of the systemd plugin got dependencies on systemd stuff..
FROM fluent/fluentd:v1.3-debian-onbuild-1

ENV FLUENT_UID=0

USER root

# fluent-plugin-splunk-hec is splunk's own plugin, but it only support ruby 2.4+, waiting

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev git" \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && sudo gem install \
        fluent-plugin-kubernetes_metadata_filter \
        fluent-plugin-systemd \
        fluent-plugin-prometheus \
        fluent-plugin-splunkhec \
        # fluent-plugin-splunk-hec \
    && sudo gem sources --clear-all \
    && SUDO_FORCE_REMOVE=yes \
        apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps \
    && rm -rf /var/lib/apt/lists/*

USER fluent
