# Build: 
# docker build -t usbloadergx-build .
# docker create --name usbloadergx-build usbloadergx-build
# docker cp usbloadergx-build:/projectroot/boot.dol .
# docker cp usbloadergx-build:/projectroot/boot.elf .
# docker rm usbloadergx-temp

FROM debian:buster AS usbloader
ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/London"
RUN apt-get update -y && apt-get install -y \ 
    xz-utils make git

COPY Libraries/devkitPPC-r41-2-linux_x86_64.pkg.tar.xz /
COPY Libraries/libogc-2.3.1-1-any.pkg.tar.xz /
COPY Libraries/devkitppc-rules-1.1.1-1-any.pkg.tar.xz /
COPY Libraries/general-tools-1.2.0-2-linux_x86_64.pkg.tar.xz /
COPY Libraries/gamecube-tools-1.0.3-1-linux_x86_64.pkg.tar.xz /

RUN tar -xf /devkitPPC-r41-2-linux_x86_64.pkg.tar.xz opt/devkitpro/devkitPPC --strip-components=1 && \
    tar -xf /libogc-2.3.1-1-any.pkg.tar.xz opt/devkitpro/libogc --strip-components=1 && \
    tar -xf /devkitppc-rules-1.1.1-1-any.pkg.tar.xz opt/devkitpro/devkitPPC --strip-components=1 && \
    tar -C /usr/local/bin -xf /general-tools-1.2.0-2-linux_x86_64.pkg.tar.xz opt/devkitpro/tools/bin/bin2s --strip-components=4 && \
    tar -C /usr/local/bin -xf /gamecube-tools-1.0.3-1-linux_x86_64.pkg.tar.xz opt/devkitpro/tools/bin/elf2dol --strip-components=4 && \
    mkdir /projectroot 

ENV DEVKITPRO=/devkitpro
ENV DEVKITPPC=/devkitpro/devkitPPC

COPY . /projectroot/
RUN cd /projectroot && make
