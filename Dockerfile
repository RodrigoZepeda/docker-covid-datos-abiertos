FROM python:3.9-alpine3.12

#Install pandas stuff + wget and unzip
RUN apk add --no-cache --update \
    python3 python3-dev gcc \
    gfortran musl-dev g++ \
    libffi-dev openssl-dev \
    libxml2 libxml2-dev \
    libxslt libxslt-dev \
    libjpeg-turbo-dev zlib-dev \
    wget unzip

#Update pip
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir pandas==1.2.3

#Copy shell to download and python to clean
ADD get_file.sh /
ADD run_cron.sh /
ADD process_data.py /

#Create dir to connect to volume
RUN mkdir /home/covid-data

#Cronjob
ADD crontab /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron && \ 
    crontab /etc/cron.d/hello-cron && \
    touch /var/log/cron.log && \
    chmod 777 get_file.sh && \
    chmod 777 run_cron.sh

CMD ["/run_cron.sh"]