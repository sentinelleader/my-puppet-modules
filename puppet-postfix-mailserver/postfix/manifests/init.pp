class postfix {

  package {["postfix","postfix-ldap"]:
    ensure => installed,
  }

  file {"/etc/postfix/main.cf":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('postfix/main.cf.erb'),
    require => Package["postfix"]
  }

  file {"/etc/postfix/master.cf":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '0644',
    source => 'puppet:///modules/postfix/master.cf',
    require => Package["postfix"]
  }

  file {"/etc/postfix/ldap_senders.cf":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '0777',
    content => template('postfix/ldap_senders.cf.erb'),
    require => [Package["postfix"],File["/etc/postfix/master.cf"]]
  }

  file {"/etc/postfix/ldap_virtual_mailalt.cf":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '0777',
    content => template('postfix/ldap_virtual_mailalt.cf.erb'),
    require => [Package["postfix"],File["/etc/postfix/master.cf"]]
  }

  file {"/etc/postfix/ldap_virtual_users.cf":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '0777',
    content => template('postfix/ldap_virtual_users.cf.erb'),
    require => [Package["postfix"],File["/etc/postfix/master.cf"]]
  }

  file {"/etc/mailname":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => "$dom1",
    require => [Package["postfix"],File["/etc/postfix/master.cf"]]
   }
   
  service {"postfix":
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    subscribe => [File["/etc/postfix/main.cf"], File["/etc/postfix/master.cf"]],
    require => [Package["postfix"], File["/etc/postfix/main.cf"]]
  }
 }
