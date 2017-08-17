FROM centos:centos7

ENV JENKINS_HOME /var/lib/jenkins
ARG user=jenkins
ARG group=jenkins
ARG uid=22002
ARG gid=624

RUN groupadd -g ${gid} ${group} \
    && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}
RUN mkdir -p "$JENKINS_HOME/workspace/ezbake"
ADD . "$JENKINS_HOME/workspace/ezbake"
RUN yum localinstall -y http://yum.puppetlabs.com/puppet/puppet-release-el-7.noarch.rpm && yum localinstall -y http://osmirror.delivery.puppetlabs.net/sles-12-x86_64/RPMS.os/systemd-rpm-macros-2-7.161.noarch.rpm && yum install -y ruby-devel java-1.8.0-openjdk-devel @"Development Tools"
RUN gem install --no-ri --no-rdoc rake fpm
WORKDIR "$JENKINS_HOME"
RUN curl -o /usr/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && chmod 0755 /usr/bin/lein && chown -R jenkins:jenkins "$JENKINS_HOME"
RUN yum clean all && yum install -y puppet-agent && yum clean all && rm -rf /var/cache/yum
USER jenkins
RUN lein && git config --global user.email "ci@puppet.com" && git config --global user.name "Jenkins CI"
RUN echo 'hi'
