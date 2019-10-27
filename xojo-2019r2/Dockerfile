ARG base_tag="desktop-runtime"
FROM kmaehashi/xojo-docker:${base_tag}

ENV XOJO_VERSION  2019r2
ENV XOJO_CHECKSUM da98c5d410fb22f9f0c48dab29970b7ef52b307cac79880bb1100701ef204fac

COPY xojo${XOJO_VERSION}.deb /tmp
RUN cd /tmp && \
    echo "${XOJO_CHECKSUM}  xojo${XOJO_VERSION}.deb" | sha256sum -cw --quiet - && \
    dpkg -i "xojo${XOJO_VERSION}.deb" && \
    ln -snf xojo${XOJO_VERSION} /opt/xojo/xojo

CMD ["/opt/xojo/xojo/Xojo"]
