# Крипто Про 5.0 docker
КриптоПро 5.0 R3 в docker контейнере с установленным Pycades

## Содержимое контейнера:

- python 3.11 с установленным расширением pycades
- КриптоПро 5 R3

## Создание образа

0. Скачать с официального сайта в dist/ (необходимо быть залогиненым в системе):
КриптоПро CSP 5.0 R3 или новее для Linux (x64, deb) => dist/linux-amd64_deb.tgz

Так же можно сразу положить в папку dist/ сертификат ЭЦП в формате .pfx => dist/cert.pfx
и раскомментировать в dockerfile соответствующие строки (см. Dockerfile)

Свой лицензионный ключ от Крипто Про так же можем указать в Dockerfile, если не указывать используется триальный ключ на 30 дней.

### 1. Копируем репозиторий
```
git clone https://github.com/JustUnknownDude/CryptoPro5docker.git crypto
```

### 2. Создаем в папке проекта папку dist и кладем туда linux-amd64_deb.tgz и при необходимости сертификат ЭЦП

### 3. Переходим в папку и собираем контейнер:
```
cd crypto && docker build --tag cryptopro/cryptopro .
```

### 4. Запускаем контейнер
```
docker run -it --rm --name cryptopro cryptopro/cryptopro
```
