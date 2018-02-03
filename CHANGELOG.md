## 1.7.5 - 2018-01-09
This is a bugfix release.

Bugfix:
  * (SERVER-2068) Improve logic for determining the process ID for stop/start/
    reload commands to make it less likely to pick up an incorrect process.

## 1.7.4 - 2017-12-18
This is a maintenance release.

Maintenance:
  * Add "repo_name" and "nonfinal_repo_name" as targets for Packaging 1.0.x

## 1.7.3 - 2017-12-15
This is a maintenance release.

Maintenance:
  * Set `build_tar: FALSE` in foss build defaults in order to not attempt tar
    signing when undesired.

## 1.7.2 - 2017-12-12
This is a maintenance release.

Maintenance:
  * Use internal artifactory server instead of internal nexus server.
  * Update to [packaging](https://github.com/puppetlabs/packaging) 1.0.x to pick up
    changes to make it more straightforward to ship to the platform 5 repos,
    and to pick up the branch that's most actively maintained.

## 1.7.1 - 2017-11-29
This is a bugfix release.

Bugfix:
  * Generate valid replaces/conflicts in RPM and deb packaging
  * Pass MOCK and COW environment variables through to the jenkins job during
    a `lein ezbake build`.
  * If `repo-target` is unspecified debian artifacts should end up under
    `deb/<platform>` instead of `deb/<platform>/main`.


## 1.7.0 - 2017-11-14
This is a feature release.

Feature:
  * (EZ-111) Add support for RPM triggers. You can now add postinstall triggers
    that run on either installs or upgrades via the
    `redhat-postinst-install-triggers` or `redhat-postinst-upgrade-triggers`
    variables under `:lein-ezbake` in your project.clj. These variables are
    arrays of hashes in the format [ { :package "package", :scripts ["script 1", "script2"] } ]
  * (EZ-113) Add support for Debian triggers. This adds support for activate
    triggers via the `debian-activated-triggers` variable. This variable takes
    an array of trigger names. This also adds support for interest triggers for
    either install or upgrade via the `debian-interested-install-triggers` and
    `debian-interested-upgrade-triggers` variables. These variables are arrays 
    of hashes in the format [ { :interest-name "trigger", :scripts ["script1", "script2"] } ]
    All of these variables are set under `:lein-ezbake` in your project.clj.

## 1.6.7 - 2017-11-29
This is a bugfix release.

Bugfix:
  * If `repo-target` is unspecified debian artifacts should end up under
    `deb/<platform>` instead of `deb/<platform>/main`.

## 1.6.6 - 2017-11-20
This is a bugfix release.

Bugfix:
  * Generate valid replaces/conflicts in RPM and deb packaging
  * Pass MOCK and COW environment variables through to the jenkins job during
    a `lein ezbake build`.

## 1.6.5 - 2017-11-14
This is a bugfix release.

Bugfix:
  * Pass `replaces-pkgs` from ezbake config to FPM packaging
  * Pass `create-dirs` from ezbake config to FPM packaging

## 1.6.4 - 2017-11-10
This release was incorrectly published as 1.6.4. Do not use this release.

## 1.6.3 - 2017-10-02
This is a bugfix release.

Bugfix:
  * We were incorrectly setting the package release to the package version if
    it was not a SNAPSHOT build. The release is now set to 1 unless we have a
    SNAPSHOT build. Behavior for SNAPSHOT builds is unchanged.

## 1.6.2 - 2017-09-25
This is a bugfix release.

Bugfix:
  * We were generating invalid bash (empty if block) if there were no additional
    dependencies specified.
  * We weren't keeping the output tarball with the packaging artifacts.

## 1.6.1 - 2017-09-15
This is a bugfix and maintenance release.

Bugfix:
  * There was a bad version check that caused sles 12 packages to not get init
    scripts. This has been fixed.
  * We were attempting to reuse packaging artifacts but were deleting them after
    each platform was packaged. Moved the delete to after all platforms ran.

Maintenance:
  * Clean up debug output to accurately represent the options hash.
  * Update `help` output to print correct platforms
  * Print the URL for where the packages are going to be staged at the end of
    the `build` step.

## 1.6.0 - 2017-09-13
This is a feature and maintenance release.

Feature:
  * Added `local-build` task to allow building ezbake projects on infrastructure
    outside of Puppet. There is more information available in the README but 
    this addition enables package building on any machine/VM/container/etc with
    the necessary dependencies installed.
  * Changes to `build` task to let it use new infrastructure and CI systems.
    These changes should be transparent with the exception of needing to pass 
    jenkins authorization at runtime. This should be passed in the
    JENKINS_USER_AUTH environment variable as either '<job token>' or
    '<ldap username>:<personal auth token>'.
  * Added `legacy-build` task to preserve the `build` task from previous versions
    of ezbake.

Maintenance:
  * Document installation has been moved into the install.sh script. We were
    previously installing the docs with `%doc` entries and the doc control file.
    The `install.sh` script now installs the docs in the os-specific location to
    enable us to more easily change how we are packaging.

## 1.5.2 - 2017-08-29
Maintenance:
  * Removes Ubuntu Yakkety and Ubuntu Precise from the default COW list as those
    platforms are EOL.

## 1.5.1 - 2017-7-13
Bugs:
  * Get dependencies from requirements which do not have version numbers
    associated with it, as well parent dependencies.

## 1.5.0 - 2017-6-30
This is a feature release.

Feature:
  * (RE-8861) Generate metadata files when building projects.
    Adds a new `manifest` command that creates an 'ext/build_metadata.json' file
    containing dependencies and related metadata to aid in tracking down
    differences between packages built with ezbake.
    This file is also created during the `stage` and `build` actions.

## 1.4.0 - 2017-5-18
This is a feature, maintenance, and bug fix release.

Feature:
  * (RE-8726) Add support for specifying nonfinal vs. final repo targets and
    names.

Maintenance:
  * (RE-4844) Merge together content from the FOSS and PE ezbake templates.

Bugs:
  * (EZ-109) Eliminate some unnecessarily duplicated strings from the
    ezbake.manifest file.
  * (EZ-110) Retain any qualifying attributes (e.g., exclusions) when expanding
    a SNAPSHOT version for a coordinate, allowing exclusions to be reflected 
    properly in the resulting ezbake.manifest file.
  * (EZ-110) For an `additional-uberjar`, build the immediate jar into the final
    uberjar even when the project has defined its own `uberjar` profile.

## 1.3.0 - 2017-5-3
This is a feature release
  * (SERVER-1772) Add support for building and installing additional uberjars.
    An `:additional-uberjars` EZBake setting has been added which allows projects
    to specify a list of versioned dependencies that will be built and installed
    next to the projects own uberjar.
  * (SERVER-1772) Support installing a `cli-defaults.sh` file which can be
    configured by EZBake projects and supply defaults for bash variables in a
    project's cli scripts
  * (EZ-108) Add support for `EZBAKE_ALLOW_UNREPRODUCIBLE_BUILDS` environment
    variable that when defined, will allow staging with undeployed SNAPSHOT
    versions

## 1.2.1 - 2017-4-20
  * (SERVER-1782) Fix for the openjdk8 package name in SLES-12

## 1.2.0 - 2017-4-12
This release removes Java7 support and changes the way that snapshots are deployed

Feature:
  * Remove Java 7 compatibility. Builds now assume Java (openjdk) 8
  * Change EZBake's stage command to:
      * Deploy an artifact to the configured snapshots repository when staging a project with
        a snapshot version.
      * List the deployed snapshot artifact's version as the project's version number in the
        ezbake.manifest & project_data.yaml files.
      * Resolve all dependencies with 'SNAPSHOT' versions to get a deployed snapshot artifact
        from the repository and list that artifact's version number in the ezbake.manifest &
        project_data.yaml. If no deployed snapshot artifacts can be found for the listed
        snapshot version, then an error is thrown and staging is aborted, to prevent
        unreproducible builds.
      * List each dependency's group as well as its name in the ezbake.manifest &
        project_data.yaml

## 1.1.8 - 2017-3-22
  * (SERVER-1763) Adds ca-certificates as a build dependency

## 1.1.7 - 2017-3-13
  * (SERVER-1472) The init scripts should now handle stop and restart operations
     better when the timeout value is exceeded.

## 1.1.6 - 2017-01-12
  * (CPR-400) Require `which` for RPM-based systems.

## 1.1.5 - 2016-11-29
  * Bugfix: (SERVER-1670) Stop autogenerating package dependencies in RPM
     packages - sets "AutoReq: 0"

## 1.1.4 - 2016-11-11
  * (EZ-102) Install SysV files in addition to SystemD files only on
    debian-ish platforms

## 1.1.3 - 2016-10-19
  * (EZ-104) Re-add the XXOutOfMemoryError java arg

## 1.1.2 - 2016-10-13
  * (EZ-103) Create rundir with correct permissions

## 1.1.0 - 2016-09-29

This is a minor feature release, with some maintenance work included.

Feature:

  * (SERVER-1412) Add support for `build-scripts` directory in projects; contents
    will be included in the build tarball for use in packaging tasks, but will not
    be included in final package.

Maintenance:

  * Improvements to validation of ezbake config during staging
  * Run `lein install` before stage, to ensure that we pick up local changes
  * Set umask to 027 in CLI scripts

## 1.0.0 - 2016-09-29
  * (EZ-56) Add service 'reload' to init scripts
  * (EZ-68) Add 'restart-file' ezbake option and reload app subcommand
  * (EZ-70) Modify service 'start' to use new 'start' app subcommand
  * (EZ-88) Support per-project additional build dependencies and adding
  the full contents of the project data directory into packaging
  * (EZ-90) Add 'start' app subcommand
  * (EZ-99) Add 'stop' app subcommand and modify service 'stop' command to use it
  * (EZ-100) Add timeout EzBake and defaults config settings for 'reload' and 'stop'
  
## 0.5.1 - 2016-09-13
* Update to use the new Puppet GPG key for package signing

## 0.5.0 - 2016-08-31
* Add `:logrotate-enabled` setting to allow disabling of logrotate.
  Enabled by default

## 0.4.4 - 2016-08-22
* Update FOSS build templates to work on SLES
* Update branching strategy to point to wiki
* Backport removal of heap dump to stable branch
* Modify project.clj for publishing to clojars

## 0.4.3 - 2016-07-28
 * Add configuration of open file limit to services
 * Set umask 027 on service startup
 * Fix issue where EL init script could create an empty pidfile

## 0.4.2 - 2016-05-20
  * Fix a bug in the new bootstrap `services.d` mode, for compatibility with systemd

## 0.4.1 - 2016-05-13
  * Update build-defaults to build for Ubuntu 16.04 (Xenial)
  * Fixed debian init script naming

## 0.4.0 - 2016-05-11
  * Add Ubuntu 15.10 (Wily) to default build targets
  * Add Ubuntu 16.04 (Xenial) to default build targets
  * Add Debian systemd script support
  * Add split bootstrap functionality to allow for user-configurable service
  entries alongside services that shouldn't be modified.
  * Changed folder structure for staging to add an ezbake/system-config dir

## 0.3.25 - 2016-04-26
  * Change Java dependency for deb platforms to non-virtual package

## 0.3.24 - 2016-04-20

  * Add updated maintainers information in README
  * Remove Fedora21 from default mocks
  * Add 5 second sleep to wait_for_app to help with race conditions on start

## 0.3.23 - 2016-02-18

  * Add restart on failure functionality to systemd services
  * Improved handling of mirrors and/or local repos for dependency resolution

## 0.3.22 - 2016-02-09

  * Update permissions for "projconfdir".

## 0.3.21 - 2015-11-10

  * Update to publish to clojars instead of internal repository.
  * Manage logfile ownership for SLES11 init scripts

## 0.3.20 - 2015-11-03

  * Increase default service startup timeout to 300 seconds
    (5 minutes) to avoid intermittent timeouts in testing.

## 0.3.19 - 2015-10-29

  * Updates to allow pulling in an ezbake.conf from
    the immediate project jar in addition to using the file
    from upstream dependencies.
  * Removes Ubuntu Utopic (14.10) and Fedora 20 build targets

## 0.3.18 - 2015-8-11

  * Fix unterminated 'if' in RPM spec template

## 0.3.17 - 2015-08-10

  * Update permissions on ezbake-functions.sh

## 0.3.16 - 2015-08-06

  * Fix typo (unclosed %if) in the PE rpm spec file

## 0.3.15 - 2015-08-06

  * RPM scriptlet fixes and cleanups
  * Fix RPM packaging for arbitrary dirs using create-dirs
  * Drop unused create-varlib function
  * Update permissions on ezbake-functions.sh
  * Stop hardcoding heap dumps in the init scripts

## 0.3.14 - 2015-07-10

 * Do not obsolete/provide with termini packaging for rpms

## 0.3.13 - 2015-07-06

 * Debian/Ubuntu should now correctly restart the process on upgrade
   if necessary.
 * Set the Vendor string in the RPM templates.

## 0.3.12 - 2015-07-01

 * Ubuntu PE init script template now creates
   PID directory correctly
 * More init script cleanups and synchronizing
   PE and FOSS templates

## 0.3.11 - 2015-06-26

 * Fixes for service account handling on package
   and source based installations
 * Update default startup timeout to 180 seconds
 * Remove EL-5 as a build target
 * Add support for systemd tmpfiles.d configs

## 0.3.10 - 2015-06-23

 * On package upgrade, update service account information (home dir,
   group membership, etc) if necessary

## 0.3.9 - 2015-06-18

 * Packaging: Fix varlibdir to use real_name for PE (so its
   app_data/lib/puppetdb, not app_data/lib/pe-puppetdb)
 * Packaging: In Debian, ignore service stops for services that are already
   stopped during upgrade.
 * Packaging: In Debian, add a prerm section to stop services gracefully on a
   failed upgrade.
 * Packaging: Fixed lots of inconsistencies between PE and FOSS, now we are
   closer then ever.
 * Packaging: Users were being created using the old FOSS based homedirs.
 * Packaging: Removal of log files for FOSS during package uninstall removed old
   non-AIO log file dirs.
 * Packaging: sharedstatedir and localstatedir were no longer used, app_data is
   preferred so these have been removed.
 * Packaging: call install.sh in PE using exec
 * Packaging: Debian with PE was not using the group to set permissions, default
   file and init set correctly.
 * Packaging: Tighten up permissions on application data directories, no longer
   world-readable.

## 0.3.8 - 2015-06-05

 * Packaging: Correct termini install.sh rubylibdir fallback detection for
   source based builds to work.
 * Packaging: Make rubylibdir setting in packaging consistent between PE/FOSS
   and Debian/Redhat.
 * Packaging: Fix: rundir should be created by the rpm package on install/upgrade
 * Packaging: Make install.sh use "localstatedir" variable instad of hardcoding '/var'

## 0.3.7 - 2015-05-29

 * Packaging: Add Ubuntu Precise and SLES for PE builds

## 0.3.6 - 2015-05-21
 * Bugfix: Set sudo HOME for foreground
 * Packaging: Do not build stable or testing for debian
 * Packaging: Set default cow to precise

## 0.3.5 - 2015-05-13
This release updates PE templates for AIO paths

 * Update PE packaging templates to use the AIO paths as specified in
   http://git.io/vUXTv
 * PE packaging templates now depend on 'puppet-agent' where appropriate

## 0.3.4 - 2015-04-24
 * Bugfix: Quiet install.sh debug output by default (can be overridden by
   setting EZ_VERBOSE). It is still enabled for package builds.
 * Update FOSS debian templates to allow the use java 8 if java 7 is not
   available
 * Add Ubuntu Utopic, Debian Jessie as build targets by default
 * Add 'Should-Start' LSB headers to SUSE and EL init script templates
 * Add Fedora 21 build target
 * Fix copy-paste error in EL init script template
 * Use templated :start_timeout value in Debian init scripts.

## 0.3.3 - 2015-04-15
 * Remove Fedora 19 build target

## 0.3.2 - 2015-03-30
 * (EZ-34) Allow ezbake to set apt/yum repo_name to ship to alternate repos

## 0.3.1 - 2015-03-25
 * Feature: Add a full lein dependency tree to the ezbake.manifest file that is
   included in packages.
 * Feature: Support for Fedora 21 as a build target.
 * Bugfix: Update to AIO layout for debian7, ubuntu1404, ubuntu1204 platforms.

## 0.3.0 - 2015-03-12
This release contains bug fixes and AIO path changes.

 * (SERVER-358) Update owner/group of the pid dir and add data dir (599d733)
 * (SERVER-344) Remove quotes around sudo command (070bac0)
 * (SERVER-344) Remove hardcoded puppet user (c13648a)
 * (SERVER-344) Choose best method to become puppet (1335712)
 * (PE-8274) Update oomkill parameter for systemd (f0bc4e9)
 * (SERVER-369) Update run directory for EL-7 (4625cd7)
 * (SERVER-369) Update ezbake to use new AIO directories (2eb3628)
 * (SERVER-387) Update to AIO server confdir layout (ee0a593)

## 0.2.14 - 2016-09-13
 * Packaging: Use new key for package signing

## 0.2.13 - 2016-08-31
 * Feature: Add `:logrotate-enabled` setting to allow disabling of logrotate.
   Enabled by default.

 Note: While technically a minor feature release, this is going to be a Z
 release to avoid branch renaming hassles.

## 0.2.12 - 2016-06-13
 * Backport changes to avoid setting -XX:+HeapDumpOnOutOfMemoryError by default

## 0.2.11 - 2016-03-18
 * Update to publish to clojars instead of internal repository
 * Packaging: Removes Fedora 20 build targets

## 0.2.10 - 2015-05-21
 * Bugfix: Set sudo HOME for foreground
 * Packaging: Do not build stable or testing for debian
 * Packaging: Set default cow to precise

## 0.2.9 - 2015-04-23
 * Bugfix: Quiet install.sh debug output by default (can be overridden by
   setting EZ_VERBOSE). It is still enabled for package builds.

## 0.2.8 - 2015-04-20
 * Fix copy-paste error in EL init script template
 * Use templated :start_timeout value in Debian init scripts.

## 0.2.7 - 2015-04-13
 * Add 'Should-Start' LSB headers to SUSE and EL init script templates
 * Add Fedora 21 build target
 * Remove Fedora 19 build target

## 0.2.6 - 2015-03-20
 * Feature: Add a full lein dependency tree to the ezbake.manifest file that is
   included in packages.

## 0.2.5 - 2015-03-12
 * Bugfix: Foreground script now attempts to use the runuser command to switch
   to the service user if it's available. Otherwise su or sudo are used.

## 0.2.4 - 2015-03-06
 * Feature: Ability to specify actions run as root before
   starting up a service.

## 0.2.3 - 2015-02-20
 * Bugfix: Plumb $rubylibdir into redhat install step.
   * Standardize on "$rubylibdir" variable name in spec files.
 * Bugfix: Use project :real_name in FOSS postinstall.

## 0.2.2 - 2015-02-17
 * Bugfix: Update path to install.sh for debian postins.
 * Bugfix: Fix bug where RPM specs were putting config files in the wrong place.
 * Feature: Add create-dirs key to [:lein_ezbake :vars] to enable creation of
   arbitrary directories with 0700 permissions.
 * Bugfix: Typo in install.sh.erb.
 * Bugfix: Add net-tools dependency for service unit files.

## 0.2.1 - 2015-02-05
 * Bugfix: Pass through local-repo value when making aether requests.

## 0.2.0 - 2015-02-03
 * Rewrite templates to share installation code between install-from-source and
   install-from-package.

## 0.1.0 - 2015-01-13
 * Rewrite ezbake to follow leiningen plugin application model.
