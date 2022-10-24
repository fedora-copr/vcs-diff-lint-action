FROM registry.fedoraproject.org/fedora:36

MAINTAINER copr-team@redhat.com

RUN dnf -y install dnf-plugins-core && \
    dnf -y copr enable @copr/vcs-diff-lint && \
    dnf install -y vcs-diff-lint git && \
    dnf clean all

COPY container/ /

CMD /cmd
