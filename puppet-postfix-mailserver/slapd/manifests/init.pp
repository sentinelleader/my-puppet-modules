class slapd {

  package {['slapd','db4.8-util','db4.8-doc','ldap-utils','apg','openssl']:
    ensure => latest
  }

  file {"/etc/ldap/slapd.conf":
    ensure => present,
    owner => 'openldap',
    group => 'openldap',
    mode => '0644',
    content => template("slapd/slapd.conf.erb"),
   require => Package['slapd','db4.8-util','db4.8-doc','ldap-utils']
  }

  file {"/etc/default/slapd":
     ensure => present,
     owner => 'root',
     group => 'root',
     mode => '0644',
     source => 'puppet:///modules/slapd/slapd',
     require => [Package["slapd"]]
    }

   file {"/etc/init.d/slapd":
	ensure => present,
	owner => 'root',
	group => 'root',
	mode => '0755',
	source => 'puppet:///modules/slapd/slapd_init',
	require => Package["slapd"]
	}

    file {"/var/lib/ldap/openldap":
      ensure => directory,
      owner => 'openldap',
      group => 'openldap',
      mode => '0755',
      require => [File["/etc/ldap/slapd.conf"]]
      }

      file {"/etc/ldap/schema":
	ensure => directory,
	owner => 'root',
	group => 'root',
	mode => '0644',
	recurse => true,
	source => 'puppet:///modules/slapd/schema',
	require => [Package["slapd"], File["/etc/ldap/slapd.conf"]]
	}

      file {"/sbin/mkntpwd":
	ensure => present,
	owner => 'root',
	group => 'root',
	mode => '0775',
	source => 'puppet:///modules/slapd/mkntpwd',
	require => File["/etc/ldap/schema"]
	}

      file {"/var/tmp/pop-ldap":
	ensure => directory,
	owner => 'root',
	group => 'root',
	mode =>	'0755',
	recurse => true,
	source => 'puppet:///modules/slapd/pop-ldap',
	require => [File["/sbin/mkntpwd"]]
	}

	file {"/var/tmp/pop-ldap/details.txt":
	 ensure => file,
	 owner => 'root',
	 group => 'root',
	 mode => '0755',
	 content => template("slapd/details.txt.erb"),
	 require => [File["/var/tmp/pop-ldap"], File["/sbin/mkntpwd"]]
	}

	exec {"genldif":
	path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
	command => "/var/tmp/pop-ldap/genldif.sh",
	logoutput => true,
	require => [File["/var/tmp/pop-ldap/details.txt"], File["/var/tmp/pop-ldap"]]
	}

	exec {"import":
	 path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
	 command => "slapadd -f /etc/ldap/slapd.conf -l /var/tmp/pop-ldap/initial.ldif",
	 logoutput => true,
	 require => [Exec["genldif"], File["/var/tmp/pop-ldap/details.txt"]]
	}

        exec {"kill_dummy":
	 path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
	 command => "killall -9 slapd",
	 logoutput => true,
	 require => [Exec["genldif"], Exec["import"]]
	}

	service {"slapd":
	 ensure => running,
	 enable => true,
	 hasstatus => true,
	 hasrestart => true,
	 require => [File["/etc/default/slapd"], File["/etc/ldap/slapd.conf"], Exec["kill_dummy"]]
	}
}
