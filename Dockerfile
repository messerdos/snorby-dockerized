FROM centos:centos7

RUN \
    yum update -y && \
    yum install -y epel-release && \
    yum install -y tar wget git libxml2-devel libxslt-devel mariadb mariadb-devel wkhtmltopdf postgresql-devel which git-core && \
     # Prepare ruby for Snorby
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
    curl -sSL https://get.rvm.io | bash -s stable --ruby=2.2.8 && \
    source /usr/local/rvm/scripts/rvm && \
    source /etc/profile.d/rvm.sh && \
    export PATH=$PATH:/usr/local/rvm/rubies/ruby-2.2.8/bin && \
    gem update --system && \
    gem install bundler && \
    # Get Latest Snorby
    git clone git://github.com/Snorby/snorby.git /usr/local/src/snorby && \
    gem install activesupport railties rails dm-mysql-adapter do_mysql && \
    cd /usr/local/src/snorby && \
    sed -i 's/do_mysql (~> 0.10.6)/do_mysql (~> 0.10.17)/' Gemfile.lock && \
    sed -i 's/do_mysql (0.10.16)/do_mysql (0.10.17)/' Gemfile.lock && \
    bundle install

COPY container-files /

ENV DB_ADDRESS=127.0.0.1 DB_USER=user DB_PASS=new-password SNORBY_CONFIG=/usr/local/src/snorby/config/snorby_config.yml

ENTRYPOINT ["/bootstrap.sh"]