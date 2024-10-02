# CryptoPro5docker
КриптоПро 5.0 R3 в docker контейнере с установленным Pycades

## Содержимое контейнера:

- python 3.11 с установленным расширением pycades
- КриптоПро 5 R3

## Создание образа из исходного кода
"
docker build --tag required/cryptopro .
"
Скачать с официального сайта в dist/ (необходимо быть залогиненым в системе):
КриптоПро CSP 5.0 R3 или новее для Linux (x64, deb) => dist/linux-amd64_deb.tgz
Так же в папку dist/ кладем сертификат ЭЦП в формате .pfx => dist/star.pfx

