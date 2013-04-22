class qmail::service {

   package {"runit":
   	ensure => latest
   }

   file {"/etc/sv/qmail-smtpd":
   	ensure => directory,
   	owner => 'root',
   	group => 'root',
   	mode  => '0755',
   	recurse => true,
   	source => "puppet:///modules/qmail/qmail-smtpd",
   	require => Package ["runit"]
   }
  
   file {"/etc/sv/qmail-send":
   	ensure => directory,
   	owner => 'root',
   	group => 'root',
   	mode  => '0755',
   	recurse => true,
   	source => "puppet:///modules/qmail/qmail-send",
   	require => Package ["runit"]
   }

   file {"/etc/service/qmail-smtpd":
   	ensure => link,
   	target => "/etc/sv/qmail-smtpd",
   	require => File ["/etc/sv/qmail-smtpd"],
   }
   
   file {"/etc/service/qmail-send":
   	ensure => link,
   	target => "/etc/sv/qmail-send",
   	require => File ["/etc/sv/qmail-send"],
   }

   exec {"wait-5-sec":
    	command => 'sleep 5',
    	path    => '/usr/bin:/usr/sbin:/bin:/sbin',
    	require => [File ["/etc/service/qmail-smtpd"], File ["/etc/service/qmail-send"]]
  }

   service {"qmail-smtpd":
   	ensure => running,
   	provider => runit,
   	hasrestart => true,
   	hasstatus => true,
   	enable => true,
   	require => [Package ["runit"], Exec ["wait-5-sec"]],
   	subscribe => File ["/etc/service/qmail-smtpd"]
   }
  
   service {"qmail-send":
   	ensure => running,
   	provider => runit,
   	hasrestart => true,
   	hasstatus => true,
   	enable => true,
   	require => [Package ["runit"], Exec ["wait-5-sec"]],
   	subscribe => File ["/etc/service/qmail-send"]
   }

}
