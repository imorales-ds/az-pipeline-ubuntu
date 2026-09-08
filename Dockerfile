FROM ubuntu:24.04
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lsb-release \
    software-properties-common \
    wget \
    openjdk-8-jdk \
    openjdk-11-jdk \
    openjdk-17-jdk \
    npm \
    dotnet-sdk-8.0 \
    gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/microsoft.gpg && \
    echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/ubuntu/24.04/prod $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/microsoft-prod.list && \
    apt-get update && \
    apt-get install -y azure-cli powershell && \
    rm -rf /var/lib/apt/lists/*

# Set JAVA_Home_Variables
ENV JAVA_HOME_8_X64=/usr/lib/jvm/java-8-openjdk-amd64
ENV JAVA_HOME_11_X64=/usr/lib/jvm/java-11-openjdk-amd64
ENV JAVA_HOME_17_X64=/usr/lib/jvm/java-17-openjdk-amd64

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

ENTRYPOINT [ "./start.sh" ]
