#!/bin/ruby

require 'open3'
require 'optparse'
require 'ostruct'

options = OpenStruct.new
# settin' some defaults
options.certs_package = 'ca-certificates'
options.systemd = 0
options.sysvinit = 0
options.systemd_el = 0
options.systemd_sles = 0
options.old_el = 0
options.old_sles = 0
options.sles = 0
options.java = 'java-1.8.0-openjdk-headless'
options.release = 1
options.is_pe = false
options.replaces = {}
options.additional_dependencies = []
options.user = 'puppet'
options.group = 'puppet'
options.additional_dirs = []
options.sources = ['etc','opt','usr','var']
options.debug = false
options.logrotate = false

OptionParser.new do |opts|
  opts.on('-o', '--operating-system OS', [:fedora, :el, :suse], 'Select operating system (fedora, el, suse)') do |o|
    options.operating_system = o
  end
  opts.on('--os-version VERSION', Integer, 'VERSION of the operating system to build for') do |v|
    options.os_version = v
  end
  opts.on('-n', '--name PROJECT', 'Name of the PROJECT to build') do |n|
    options.name = n
  end
  opts.on('--package-version VERSION', 'VERSION of the package to build') do |v|
    options.version = v
  end
  opts.on('--release RELEASE', 'RELEASE of the package') do |r|
    options.release = r
  end
  opts.on('--[no-]enterprise-build', 'Whether or not this is a PE build') do |e|
    options.is_pe = e
  end
  opts.on('--replaces <PKG,VERSION>', Array, 'PKG and VERSION replaced by this package. Can be passed multiple times.') do |pkg,ver|
    options.replaces[pkg] = ver
  end
  opts.on('--additional-dependency DEP', 'Additional dependency this package has. Can be passed multiple times.') do |dep|
    options.additional_dependencies << dep
  end
  opts.on('-u', '--user USER', 'word something') do |user|
    options.user = user
  end
  opts.on('-g', '--group GROUP', 'words') do |group|
    options.group = group
  end
  opts.on('--create-dir DIR', 'The package should additionally create DIR') do |dir|
    options.additional_dirs << dir
  end
  opts.on('--realname NAME', 'The realname') do |name|
    options.realname = name
  end
  opts.on('--chdir DIR', 'The dir to chdir to before building') do |dir|
    options.chdir = dir
  end
  opts.on('--source <DIR>', Array, 'comma-separated list of source dirs') do |dir|
    options.sources = dir
  end
  opts.on('--dist NAME', 'the dist tag') do |dist|
    options.dist = dist
  end
  opts.on('--[no-]debug', 'for debugging purposes') do |d|
    options.debug = d
  end
  opts.on('--[no-]logrotate', 'to logrotate or not to logrotate') do |l|
    options.logrotate = l
  end
end.parse!

# validation
fail "--name is required!" unless options.name
options.realname = options.name if options.realname.nil?
fail "--package-version is required!" unless options.version
fail "--operating-system is required!" unless options.operating_system
fail "--os-version is required!" unless options.os_version
options.dist = "#{options.operating_system}#{options.os_version}" if options.dist.nil?
options.chdir = options.dist if options.chdir.nil?

if options.debug
  puts "=========================="
  puts "OPTIONS HASH"
  puts options
  puts "=========================="
end

fpm_opts = Array('')

options.app_logdir = "/var/log/puppetlabs/#{options.realname}"
options.app_rundir = "/var/run/puppetlabs/#{options.realname}"
options.app_prefix = "/opt/puppetlabs/server/apps/#{options.realname}"
options.app_data = "/opt/puppetlabs/server/data/#{options.realname}"

fpm_opts << "--rpm-rpmbuild-define 'rpmversion #{options.version}'"
fpm_opts << "--rpm-rpmbuild-define '_app_logdir #{options.app_logdir}'"
fpm_opts << "--rpm-rpmbuild-define '_app_rundir #{options.app_logdir}'"
fpm_opts << "--rpm-rpmbuild-define '_app_prefix #{options.app_prefix}'"
fpm_opts << "--rpm-rpmbuild-define '_app_data #{options.app_data}'"

if options.operating_system == :fedora # all supported fedoras are systemd
  options.systemd = 1
  options.systemd_el = 1
elsif options.operating_system == :el && options.os_version >= 7 # systemd el
  options.systemd = 1
  options.systemd_el = 1
elsif options.operating_system == :el # old el
  options.sysvinit = 1
  options.old_el = 1
elsif options.operating_system == :suse && options.os_version >= 1210
  options.systemd = 1
  options.systemd_sles = 1
  options.sles = 1
  options.certs_package = 'ca-certificates-mozilla'
  options.java = 'java-1_8_0-openjdk-headless'
elsif options.operating_system == :suse #old sles
  options.sysvinit = 1
  options.old_sles = 1
end

fpm_opts << "--rpm-rpmbuild-define '_with_sysvinit #{options.sysvinit}'"
fpm_opts << "--rpm-rpmbuild-define '_with_systemd #{options.systemd}'"
fpm_opts << "--rpm-rpmbuild-define '_old_sles #{options.old_sles}'"
fpm_opts << "--rpm-rpmbuild-define '_systemd_el #{options.systemd_el}'"
fpm_opts << "--rpm-rpmbuild-define '_systemd_sles #{options.systemd_sles}'"
fpm_opts << "--rpm-rpmbuild-define '_old_el #{options.old_el}'"


fpm_opts << "--rpm-rpmbuild-define '_sysconfdir /etc'"
fpm_opts << "--rpm-rpmbuild-define '_prefix #{options.app_prefix}'"
fpm_opts << "--rpm-rpmbuild-define '_rundir /var/run'"
fpm_opts << "--rpm-rpmbuild-define '__jar_repack 0'"

fpm_opts << "--name #{options.name}"
fpm_opts << "--version #{options.version}"
fpm_opts << "--iteration #{options.release}"
fpm_opts << "--rpm-dist #{options.dist}"
fpm_opts << "--vendor 'Puppet Labs <info@puppetlabs.com>'"

if options.is_pe
  fpm_opts << "--license 'PL Commercial'"
else
  fpm_opts << "--license 'ASL 2.0'"
end

fpm_opts << "--url http://puppet.com"
fpm_opts << "--category 'System Environment/Daemons'"
fpm_opts << "--architecture all"

options.replaces.each do |pkg, version|
  fpm_opts << "--replaces #{pkg} #{version}-1"
  fpm_opts << "--conflicts #{pkg} #{version}-1"
end

if options.old_el == 1
  fpm_opts << "--depends chkconfig"
elsif options.old_sles == 1
  fpm_opts << "--depends aaa_base"
end

if options.systemd_el == 1
  fpm_opts << "--depends systemd"
end

if options.is_pe
  fpm_opts << "--depends pe-java"
  fpm_opts << "--depends pe-puppet-enterprise-release"
else
  fpm_opts << "--depends #{options.java}"
  fpm_opts << "--depends #{options.certs_package}"
end

fpm_opts << "--depends bash"
fpm_opts << "--depends net-tools"
fpm_opts << "--depends /usr/bin/which"
fpm_opts << "--depends procps"

options.additional_dependencies.each do |dep|
  fpm_opts << "--depends '#{dep}'"
end

# termini?

fpm_opts << "--template-scripts"
fpm_opts << "--template-value 'user=#{options.user}'"
fpm_opts << "--template-value 'group=#{options.group}'"
fpm_opts << "--template-value 'project=#{options.name}'"
fpm_opts << "--before-install ~/el-pre.sh.erb" #TODO
fpm_opts << "--after-install ~/el-post.sh.erb" #TODO
fpm_opts << "--before-remove ~/el-preun.sh.erb" #TODO
fpm_opts << "--after-remove ~/el-postun.sh.erb" #TODO

#files/dirs
fpm_opts << "--config-files /etc/puppetlabs/#{options.realname}"
fpm_opts << "--config-files /etc/sysconfig/#{options.name}"

options.additional_dirs.each do |dir|
  fpm_opts << "--directories #{dir}"
end

if options.logrotate
  fpm_opts << "--config-files /etc/logrotate.d/#{options.name}"
end

fpm_opts << "--directories #{options.app_logdir}"
fpm_opts << "--directories /etc/puppetlabs/#{options.realname}"
fpm_opts << "--directories #{options.app_rundir}"
fpm_opts << "--rpm-auto-add-directories"
fpm_opts << "--rpm-auto-add-exclude-directories /etc/puppetlabs"
fpm_opts << "--rpm-auto-add-exclude-directories /opt/puppetlabs"
fpm_opts << "--rpm-auto-add-exclude-directories /opt/puppetlabs/bin" 
fpm_opts << "--rpm-auto-add-exclude-directories /opt/puppetlabs/server" 
fpm_opts << "--rpm-auto-add-exclude-directories /opt/puppetlabs/server/apps" 
fpm_opts << "--rpm-auto-add-exclude-directories /opt/puppetlabs/server/bin" 
fpm_opts << "--rpm-auto-add-exclude-directories /opt/puppetlabs/server/data" 
fpm_opts << "--rpm-auto-add-exclude-directories /usr/lib/systemd" 
fpm_opts << "--rpm-auto-add-exclude-directories /usr/lib/systemd/system" 
fpm_opts << "--rpm-auto-add-exclude-directories /etc/init.d" 
fpm_opts << "--rpm-auto-add-exclude-directories /etc/rc.d" 
fpm_opts << "--rpm-auto-add-exclude-directories /etc/logrotate.d" 
fpm_opts << "--rpm-auto-add-exclude-directories /etc/rc.d/init.d" 
fpm_opts << "--rpm-auto-add-exclude-directories /usr/lib/tmpfiles.d" 
fpm_opts << "--rpm-auto-add-exclude-directories /var/log/puppetlabs" 
fpm_opts << "--rpm-auto-add-exclude-directories /var/run/puppetlabs" 
fpm_opts << "--rpm-attr 750,#{options.user},#{options.group}:/etc/puppetlabs/#{options.realname}"
fpm_opts << "--rpm-attr 700,#{options.user},#{options.group}:#{options.app_logdir}"
fpm_opts << "--rpm-attr -,#{options.user},#{options.group}:#{options.app_data}"
fpm_opts << "--rpm-attr 755,#{options.user},#{options.group}:#{options.app_rundir}"

fpm_opts << "--edit"
fpm_opts << "--force"

fpm_opts << "--output-type rpm"
fpm_opts << "--input-type dir"
fpm_opts << "--chdir #{options.chdir}"
fpm_opts << "#{options.sources.join(' ')}"

if options.debug
  puts "=========================="
  puts "FPM COMMAND"
  puts "FPM_EDITOR=\"sed -i 's/%dir %attr(-/%attr(-/'\" fpm #{fpm_opts.join(' ')}"
  puts "=========================="
end

# TODO: Find a better way to recursively set directory attributes for rpms.
# This is bad and I am bad for doing it.
out, err, stat = Open3.capture3("FPM_EDITOR=\"sed -i 's/%dir %attr(-/%attr(-/'\" fpm #{fpm_opts.join(' ')}")

puts "OUTPUT\n#{out}"
puts "ERR\n#{err}"
