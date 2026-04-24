FROM registry.fedoraproject.org/fedora:43

MAINTAINER copr-team@redhat.com

COPY container/ /

COPY fedora-infra.repo /etc/yum.repos.d/

RUN dnf -y update && \
    dnf -y install dnf-plugins-core && \
    dnf install -y vcs-diff-lint git git-lfs jq && \
    dnf clean all

CMD /cmd
