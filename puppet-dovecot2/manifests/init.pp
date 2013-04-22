class dovecot2 {

  $basedn            = hiera('basedn')
  $deepofix_password = hiera('deepofix_password')
  $imap_concurrency  = hiera('imap_concurrency')
  $pop3_concurrency  = hiera('pop3_concurrency')

  package { [ 'dovecot-common', 'dovecot-imapd','dovecot-pop3d','dovecot-ldap' ]:
    ensure => 'installed'
    } 

  file {'/etc/dovecot/dovecot.conf':
    ensure => 'present',
    mode   => '0755',
    source => 'puppet:///modules/dovecot2/dovecot.conf',
    owner  => 'root'
    }
   file {'/etc/dovecot/conf.d':
    ensure  => directory,
    recurse => true,
    force   => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/dovecot2/conf.d'
    }
  file {'/etc/dovecot/dovecot-ldap.conf':
    ensure  => 'present',
    mode    => '0755',
    owner   => 'root',
    content => template('dovecot/dovecot-ldap.conf.erb')
    }

  file {'/etc/dovecot/dovecot-ldap-userdb.conf':
    ensure => link,
    target => '/etc/dovecot/dovecot-ldap.conf'
    }

  file {'/var/easypush/etc/mda':
    ensure => directory,
    mode   => '0755'
    }

  file {'/var/run/dovecot':
    ensure => directory,
    mode   => '0755'
    }

  file {'/var/easypush/etc/mda/POP3CONCURRENCY':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    content => inline_template('<%= pop3_concurrency %>')
    }

   file {'/var/easypush/etc/mda/IMAPCONCURRENCY':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    content => inline_template('<%= imap_concurrency %>')
    }
  
  common::sv {'dovecot-imap':
    name    => 'dovecot-imap',
    namemod => 'dovecot',
    require => [File['/etc/dovecot/dovecot-ldap.conf'],File['/etc/dovecot/dovecot.conf']]
    }
  common::srv {'dovecot-imap':
    subscribe => [File['/etc/dovecot/dovecot-ldap.conf'],File['/etc/dovecot/dovecot.conf'],File['/var/easypush/etc/mda/IMAPCONCURRENCY']],
    require   => Common::Sv['dovecot-imap']
    }

  common::sv {'dovecot-imaps':
    name    => 'dovecot-imaps',
    namemod => 'dovecot-imaps',
    require => [File['/etc/dovecot/dovecot-ldap.conf'],File['/etc/dovecot/dovecot.conf']]
    }
  common::srv {'dovecot-imaps':
    subscribe => [File['/etc/dovecot/dovecot-ldap.conf'],File['/etc/dovecot/dovecot.conf'],File['/var/easypush/etc/mda/IMAPCONCURRENCY']],
    require   => Common::Sv['dovecot-imaps']
    }

  common::sv {'dovecot-pop3':
    name    => 'dovecot-pop3',
    namemod => 'dovecot-pop3',
    require => [File['/etc/dovecot/dovecot-ldap.conf'],File['/etc/dovecot/dovecot.conf']]
    }
  common::srv {'dovecot-pop3':
    subscribe => [File['/etc/dovecot/dovecot-ldap.conf'],File['/etc/dovecot/dovecot.conf'],File['/var/easypush/etc/mda/POP3CONCURRENCY']],
    require   => Common::Sv['dovecot-pop3']
    }

  common::sv {'dovecot-pop3s':
    name    => 'dovecot-pop3s',
    namemod => 'dovecot-pop3s',
    require => [File['/etc/dovecot/dovecot-ldap.conf'],File['/etc/dovecot/dovecot.conf']]
    }
  common::srv {'dovecot-pop3s':
    subscribe => [File['/etc/dovecot/dovecot-ldap.conf'],File['/etc/dovecot/dovecot.conf'],File['/var/easypush/etc/mda/POP3CONCURRENCY']],
    require   => Common::Sv['dovecot-pop3s']
    }

}  
