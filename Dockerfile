FROM centos:centos7
RUN mkdir /ezbake
ADD . /ezbake
RUN yum localinstall -y http://yum.puppetlabs.com/puppet/puppet-release-el-7.noarch.rpm
RUN yum clean all
RUN yum localinstall -y http://osmirror.delivery.puppetlabs.net/sles-12-x86_64/RPMS.os/systemd-rpm-macros-2-7.161.noarch.rpm
RUN yum install -y ruby-devel java-1.8.0-openjdk-devel @"Development Tools" puppet-agent
RUN gem install --no-ri --no-rdoc rake fpm
WORKDIR /ezbake
RUN curl -o /usr/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
RUN chmod 0755 /usr/bin/lein
RUN lein
RUN lein clean && lein install
RUN yum clean all
RUN rm -rf /var/cache/yum
WORKDIR /
RUN git config --global user.email "root@example.com"
RUN git config --global user.name "EZBake builder"
