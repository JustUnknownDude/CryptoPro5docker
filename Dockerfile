# Базовый образ
FROM ubuntu:22.04 AS cryptopro-generic

RUN apt-get update && apt-get install -y bash
SHELL ["/bin/bash", "-c"]

# Устанавливаем timezone
ENV TZ="Europe/Moscow" \
    docker="1"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# необходимо скачать со страницы https://www.cryptopro.ru/products/csp/downloads
# `КриптоПро CSP 5.0 R3 или новее для Linux (x64, deb)` и скопировать `linux-amd64_deb.tgz` в каталог `dist`

ADD dist /tmp/src
RUN apt-get install -y --no-install-recommends cmake build-essential libboost-dev libxml2-dev python3.11 python3.11-dev unzip apt-transport-https ca-certificates git
RUN cd /tmp/src && \
    #копируем сертификат ЭЦП в контейнер, если не нужно комментируем строчку ниже
    cp cert.pfx /cert.pfx && \
    tar -xf linux-amd64_deb.tgz && \
    linux-amd64_deb/install.sh lsb-cprocsp-devel cprocsp-pki-cades && \
    dpkg -i /tmp/src/linux-amd64_deb/cprocsp-pki-cades-64*.deb && \
    cd /tmp/src && \
    git clone https://github.com/CryptoPro/pycades.git pycades && \
    cd pycades && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j4 && \
    ls -la && \
    sleep 1 && \
    cp pycades.so /opt/cprocsp/lib/amd64/pycades.so && \
    echo 'export PYTHONPATH=/opt/cprocsp/lib/amd64/' >> ~/.bashrc && \
    source ~/.bashrc && \
    # делаем симлинки
    cd /bin && \
    ln -s /opt/cprocsp/bin/amd64/certmgr && \
    ln -s /opt/cprocsp/bin/amd64/cpverify && \
    ln -s /opt/cprocsp/bin/amd64/cryptcp && \
    ln -s /opt/cprocsp/bin/amd64/csptest && \
    ln -s /opt/cprocsp/bin/amd64/csptestf && \
    ln -s /opt/cprocsp/bin/amd64/der2xer && \
    ln -s /opt/cprocsp/bin/amd64/inittst && \
    ln -s /opt/cprocsp/bin/amd64/wipefile && \
    ln -s /opt/cprocsp/sbin/amd64/cpconfig && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1 && \
    #Чтобы установить свою лицензию указываем ее в строке ниже и раскоментируем ее
    #/opt/cprocsp/sbin/amd64/cpconfig -license -set 5050N-00000-00000-00000-00000 && \
    #Если нужно установить сертификат ЭЦП раскоментируем строку ниже и указываем актуальный пароль от вашей ЭЦП
    #/opt/cprocsp/bin/amd64/certmgr -install -pfx -file /cert.pfx -pin 12345678 -newpin 12345678 && \
    # прибираемся
    rm -rf /tmp/src
