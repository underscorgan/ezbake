#!/bin/bash


tar xf puppetserver-5.0.0.tar.gz
cd puppetserver-5.0.0
DESTDIR=base bash install.sh install_redhat
cp -r base systemd
DESTDIR=systemd bash install.sh systemd_redhat
cp -r base old_el
DESTDIR=old_el bash install.sh sysv_init_redhat
if [ -n "$LOGROTATE" ]; then
  DESTDIR=systemd bash install.sh logrotate
  DESTDIR=old_el bash install.sh logrotate_legacy
  extras='--logrotate'
fi

time ruby ~/fpm.rb $extras --debug --operating-system el --os-version 7 --name puppetserver --package-version 5.0.0 --release 4 --additional-dependency "puppet-agent >= 4.99.0" --user puppet --group puppet --chdir systemd
time ruby ~/fpm.rb $extras --debug --operating-system suse --os-version 1315 --dist sles12 --name puppetserver --package-version 5.0.0 --release 4 --additional-dependency "puppet-agent >= 4.99.0" --user puppet --group puppet --chdir systemd
time ruby ~/fpm.rb $extras --debug --operating-system el --os-version 6 --name puppetserver --package-version 5.0.0 --release 4 --additional-dependency "puppet-agent >= 4.99.0" --user puppet --group puppet --chdir old_el --source etc,opt,var

cd -

# temporary, deb working!
fpm --output-type deb --input-type dir --name puppetserver --deb-user root --deb-group root --template-scripts --template-value 'user=puppet' --template-value 'group=puppet' --template-value 'project=puppetserver' --template-value 'real_name=puppetserver' --before-install ~/ezbake/deb-pre.sh.erb --after-install ~/ezbake/deb-post.sh.erb --force --depends openjdk-8-jre-headless --depends net-tools --depends adduser --depends procps --depends 'puppet-agent >= 4.99.0' etc lib opt usr var
