FROM rockylinux/rockylinux:9-minimal AS base

ADD as-root.sh .
RUN ./as-root.sh

WORKDIR /home/louis
USER louis

ADD as-user.sh as-user.sh
RUN ./as-user.sh

ENTRYPOINT ["./steamcmd.sh"]