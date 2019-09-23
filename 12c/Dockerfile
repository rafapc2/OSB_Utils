FROM alpine:3.10
LABEL \
    maintainer="rafapc2@gmail.com" \
    version="1.0" \
    name="osb12cutil"
RUN echo 'export PATH="$PATH:/data12c"' >> ~/.bashrc && source ~/.bashrc
RUN apk add --no-cache bash
RUN mkdir /data12c
COPY *.sh /data12c/
WORKDIR /data12c
RUN chmod +x *.sh

# docker build -t "osb12cutil:1.0" .
# docker run -it -v /Users/rprudencio/analisis/osbBancoCO_12c:/data12c/osbBancoCO_12c osb12cutil:1.0 /bin/bash
