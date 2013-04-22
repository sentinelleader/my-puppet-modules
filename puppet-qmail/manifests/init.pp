class qmail {

$default_dom = " "
$base_dn = "dc= ,dc= "
$bind_dn = " "
$bind_pass = " "  

    package {["libldap2-dev","openssl","libssl-dev","zlib1g-dev","ipsvd"]:
       ensure => latest 
    }   

    file {"/opt/qmail-1.03-patched.tar.gz":
   
   	 ensure => present,
    	 mode => '0777',
    	 owner => 'root',
    	 group => 'root',
    	 source => "puppet:///modules/qmail/qmail-1.03-patched.tar.gz",
    	 require => Package ["libldap2-dev","openssl","libssl-dev","zlib1g-dev","ipsvd"]
    }

    exec {"untar":
    	 path =>'/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    	 command => "tar xvzf qmail-1.03-patched.tar.gz",
    	 cwd  => "/opt",
    	 logoutput => true,
    	 require => File ["/opt/qmail-1.03-patched.tar.gz"]
    }

    file {"/opt/useradd.sh":
   	 ensure => present,
    	 owner => 'root',
   	 group => 'root',
   	 mode => '0755',
   	 source => "puppet:///modules/qmail/useradd.sh",
   	 require => Exec ["untar"]
    }

    exec {"useradd":
   	 command => "/opt/useradd.sh",
   	 logoutput => true,
   	 require => [File ["/opt/useradd.sh"], File ["/opt/qmail-1.03-patched.tar.gz"]]
    }

    exec {"qmail-make":
 	path =>'/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    	cwd => '/opt/qmail-1.03',
    	command => "make && make setup",
    	logoutput => true,
    	require => [ Exec ["untar"], Exec ["useradd"]],
    	notify => File ["/var/qmail/control"]
    }
   
    file {"/var/qmail/control":
    	 ensure => directory,
   	 recurse => true,
    	 owner => 'root',
   	 group => 'qmail',
   	 mode => '0755',
   	 source => "puppet:///modules/qmail/control",
    }

    file {"/var/qmail/control/defaultdomain":
   	 ensure => present,
    	 owner => 'root',
   	 group => 'root',
   	 mode => '0644',
   	 content => template ('qmail/defaultdomain.erb'),
   	 require => File ["/var/qmail/control"]
    }
    
    file {"/var/qmail/control/ldapbasedn":
   	 ensure => present,
   	 owner => 'root',
    	 group => 'root',
   	 mode => '0644',
   	 content => template ('qmail/ldapbasedn.erb'),
   	 require => File ["/var/qmail/control"]
    }
   
    file {"/var/qmail/control/ldaplogin":
   	 ensure => present,
   	 owner => 'root',
    	 group => 'root',
   	 mode => '0644',
   	 content => template ('qmail/ldaplogin.erb'),
   	 require => File ["/var/qmail/control"]
    }

    file {"/var/qmail/control/ldapmailhost":
   	 ensure => present,
   	 owner => 'root',
   	 group => 'root',
   	 mode => '0644',
      	 content => template ('qmail/ldapmailhost.erb'),
   	 require => File ["/var/qmail/control"]
    }

    file {"/var/qmail/control/ldappassword":
   	 ensure => present,
   	 owner => 'root',
   	 group => 'root',
   	 mode => '0644',
   	 content => template ('qmail/ldappassword.erb'),
   	 require => File ["/var/qmail/control"]
    }
 
    file {"/var/qmail/control/locals":
   	 ensure => present,
   	 owner => 'root',
   	 group => 'root',
   	 mode => '0644',
   	 content => template ('qmail/locals.erb'),
   	 require => File ["/var/qmail/control"]
    }

    file {"/var/qmail/control/me":
   	 ensure => present,
   	 owner => 'root',
   	 group => 'root',
   	 mode => '0644',
   	 content => template ('qmail/me.erb'),
   	 require => File ["/var/qmail/control"]
    }

    file {"/var/qmail/control/rcpthosts":
   	 ensure => present,
   	 owner => 'root',
   	 group => 'root',
   	 mode => '0644',
   	 content => template ('qmail/rcpthosts.erb'),
   	 require => File ["/var/qmail/control"]
    }

}
