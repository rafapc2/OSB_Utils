FROM alpine:3.10
RUN echo 'export PATH="$PATH:/data11g"' >> ~/.bashrc && source ~/.bashrc
RUN apk add --no-cache bash
RUN mkdir /data11g
COPY *.sh /data11g/
WORKDIR /data11g
RUN chmod +x *.sh

# docker build -t "osb11gutil:1.0" .
# docker run -it -v /Users/rprudencio/analisis/osbbancocoLocal:/data11g/osbbancocoLocal osb11gutil:1.0 /bin/bash