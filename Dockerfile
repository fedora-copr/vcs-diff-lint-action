FROM registry.fedoraproject.org/fedora:40

MAINTAINER copr-team@redhat.com

COPY container/ /

RUN dnf -y update && \
    dnf -y install dnf-plugins-core && \
    dnf -y copr enable @copr/vcs-diff-lint && \
    dnf -y copr enable @codescan/csutils && \
    dnf install -y vcs-diff-lint git && \
    dnf clean all

CMD /cmd
