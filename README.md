## docker-tibco
Docker image of Tibco EMS CE (Community Edition)

###
![build](https://github.com/0x100/docker-tibco/workflows/build/badge.svg?branch=master)

### Build image

    docker build -t tibco:8.5.1 .

### Run

    docker run -p 7222:7222 -d --name tibco tibco:8.5.1
