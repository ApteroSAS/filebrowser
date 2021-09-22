FROM ubuntu:20.04
#instll build tool
RUN apt update && apt install -y wget

#node
#https://github.com/nodesource/distributions/blob/master/README.md#debinstall
RUN apt install -y nodejs && apt install -y npm

#go
RUN wget https://golang.org/dl/go1.17.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.17.1.linux-amd64.tar.gz
RUN export PATH=$PATH:/usr/local/go/bin && go version
ENV PATH="${PATH}:/usr/local/go/bin"
ENV GOPATH="${HOME}/go"
ENV GOBIN="/usr/local/go/bin"

RUN go get github.com/GeertJohan/go.rice && go get github.com/GeertJohan/go.rice/rice && rice --help

#install npm dep
COPY ./frontend/package.json ./frontend/package.json
COPY ./frontend/package-lock.json ./frontend/package-lock.json
RUN cd /frontend && npm install

#build
COPY . .

#build frontend
RUN cd /frontend && npm run build

#build backend
RUN go mod download
RUN cd /http && rice embed-go
RUN go build

################
# create final image
################
FROM alpine:latest
RUN apk --update add ca-certificates \
                     mailcap \
                     curl

HEALTHCHECK --start-period=2s --interval=5s --timeout=3s \
  CMD curl -f http://localhost/health || exit 1

VOLUME /srv
EXPOSE 80

COPY .docker.json /.filebrowser.json
COPY --from=0 filebrowser /filebrowser

ENTRYPOINT [ "/filebrowser" ]