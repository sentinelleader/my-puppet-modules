class dovecot {



  user {"vmail":
  comment => "vmail",
  home    => "/var/vmail",
  shell   => "/bin/bash",
  uid     => 5000,
  gid     => 5000,
  managehome => 'true',
  }
  
  group { "vmail":
    gid => 5000
   }

  package {["dovecot-common","dovecot-imapd","dovecot-pop3d"]:
    ensure => installed
  }

  file {"/etc/dovecot/dovecot.conf":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '0644',
    source => 'puppet:///modules/dovecot/dovecot.conf',
    require => Package["dovecot-common","dovecot-imapd","dovecot-pop3d"]
  }

  file {"/etc/dovecot/dovecot-ldap.conf":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('dovecot/dovecot-ldap.conf.erb'),
    require => File["/etc/dovecot/dovecot.conf"]
  }

  service {"dovecot":
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    subscribe => File["/etc/dovecot/dovecot.conf"],
    require => [Package["dovecot-common","dovecot-imapd","dovecot-pop3d"], File["/etc/dovecot/dovecot-ldap.conf"]]
  }
}
