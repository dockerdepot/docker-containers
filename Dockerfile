FROM centos
MAINTAINER Paul Hudson
RUN yum install wget -y
RUN wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN wget http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
RUN rpm -Uvh epel-release-6*.rpm
RUN rpm -Uvh remi-release-6*.rpm
RUN rpm -Uvh nginx-release-centos-6-0.el6.ngx.noarch.rpm

RUN yum clean all
RUN yum update -y

#RUN curl -sSL https://get.rvm.io | bash -s stable
#RUN source /etc/profile.d/rvm.sh
#RUN rvm install 1.9.3
#RUN rvm use 1.9.3 --default

RUN yum install which htop nano tar git mod_ssl openssl httpd php php-devel php-fpm monit mysql-server mysql php-mysql -y
# Nginx dependency requires install after above batch
RUN ldconfig
RUN yum install nginx -y

#RUN chkconfig httpd on
#RUN chkconfig --levels 235 mysqld on
#RUN chkconfig nginx on

#RUN service nginx restart

# Generate private key
#RUN openssl genrsa -out ca.key 2048

# Generate CSR
#RUN openssl req -new -key ca.key -out ca.csr

# Generate Self Signed Key
#RUN openssl x509 -req -days 365 -in ca.csr -signkey ca.key -out ca.crt

# Copy the files to the correct locations
#RUN cp ca.crt /etc/pki/tls/certs
#RUN cp ca.key /etc/pki/tls/private/ca.key
#RUN cp ca.csr /etc/pki/tls/private/ca.csr

#RUN git clone https://github.com/paulhudson/puppet-drupalstack.git && ~/puppet-drupalstack/lib/deploy.sh

#VOLUME ["/Users/huders2000/Documents/sites/hudsondigital/html_site"]

COPY site /var/www/vhosts/mysite.com/
COPY httpd.conf /etc/httpd/conf/httpd.conf
COPY vhost-mysite.com.conf /etc/httpd/conf.d/vhost-mysite.com.conf

# Monit config
COPY monit.conf /etc/monit/monit.conf
COPY monit-services.conf /etc/monit.d/monit-services.conf

# Perusio Nginx

RUN cd / && git clone https://github.com/paulhudson/drupal-with-nginx.git drupal-with-nginx
RUN cp -prv ./drupal-with-nginx/* /etc/nginx/

RUN cp /etc/nginx/sites-available/example.com.conf /etc/nginx/sites-available/mysite.com.conf

# Perusio PHP-FPM
RUN mkdir /etc/php5
RUN mkdir /etc/php5/fpm
RUN git clone git://github.com/perusio/php-fpm-example-config php-fpm-example-config
RUN cp -pv ./php-fpm-example-config/fpm/php5-fpm.conf /etc/php5/fpm
RUN cp -rv ./php-fpm-example-config/fpm/pool.d /etc/php5/fpm
#RUN service php-fpm restart
#RUN chkconfig php-fpm on

RUN git clone https://github.com/perusio/nginx_ensite.git nginx_ensite
RUN cp ./nginx_ensite/nginx_* /usr/sbin
#RUN ls -la ./nginx_ensite
#RUN ls -la ./nginx_ensite/bash_completion.d
#RUN cd ./nginx_ensite/bash_completion.d && source nginx-ensite
#RUN /nginx_ensite/bash_completion.d/nginx_ensite mysite.com

RUN nginx_ensite mysite.com.conf

#RUN nginx -t
#RUN service nginx restart

#RUN yum -y install supervisor
#RUN chkconfig supervisord on
#RUN chmod 600 /etc/supervisord.conf
#RUN rm -fvr /var/log/supervisor

#CMD service nginx restart && service httpd restart && service php-fpm restart

# supervisor base configuration
#ADD supervisord.conf /etc/supervisord.conf

EXPOSE 80
EXPOSE 443
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082
EXPOSE 2812

# default command
#CMD ["supervisord", "-c", "/etc/supervisord.conf"]
#CMD ["supervisord", "-n"]
#CMD ["monit", "-d 10 -Ic /etc/monit.conf"]
CMD ["monit", "-I"]

