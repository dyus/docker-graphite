# docker build -t dyus/graphite

FROM telminov/ubuntu-14.04-python3.5
MAINTAINER dyuuus@yandex.ru

RUN apt-get -qqy update && apt-get install -qqy \
                                                 python3.5 \
                                                 python-pip3 \
                                                 python-cairo \
                                                 python-django \
                                                 python-django-tagging \
                                                 libapache2-mod-wsgi \
                                                 python-twisted \
                                                 python-memcache \
                                                 python-pysqlite2 \
                                                 python-simplejson
RUN pip3 install whisper carbon graphite-web

ADD conf/ /opt/graphite/conf/

WORKDIR /opt/graphite/webapp/graphite
RUN python manage.py migrate
RUN chown -R www-data:www-data /opt/graphite/storage/
RUN a2ensite graphite
RUn /opt/graphite/bin/carbon-cache.py start
RUN /etc/init.d/apache2 restart
