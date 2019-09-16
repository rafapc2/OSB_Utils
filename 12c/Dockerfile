FROM alpine:3.10
RUN echo 'export PATH="$PATH:/data11g"' >> ~/.bashrc && source ~/.bashrc
RUN apk add --no-cache bash
RUN mkdir /data12c
COPY *.sh /data12c/
WORKDIR /data12c
RUN chmod +x *.sh

# docker build -t "osb12cutil:1.0" .
# docker run -it -v /Users/rprudencio/analisis/osbbancocoLocal:/data112c/osbbancocoLocal osb12cutil:1.0 /bin/bash