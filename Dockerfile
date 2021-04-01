FROM python:alpine3.12

#Install pandas stuff + wget and unzip
RUN apk add --no-cache --update \
    python3 python3-dev gcc \
    gfortran musl-dev g++ \
    libffi-dev openssl-dev \
    libxml2 libxml2-dev \
    libxslt libxslt-dev \
    libjpeg-turbo-dev zlib-dev \
    wget unzip

#Install bash to run sh command
RUN apk add --no-cache bash

#Update pip
RUN pip install --upgrade pip
RUN pip install pandas==1.2.3

#Copy shell to download and python to clean
COPY get_file.sh /
COPY process_data.py /

#Cronjob
COPY crontab /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron
RUN crontab /etc/cron.d/hello-cron
RUN touch /var/log/cron.log

RUN chmod 777 get_file.sh

CMD ["crond", "-f"]