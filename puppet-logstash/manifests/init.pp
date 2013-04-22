class logstash {

   package {"openjdk-7-jre":
      ensure => latest
    }

   file {"/var/tmp/logstash-1.1.1-monolithic.jar":
      ensure => present,
      owner  => root,
      group  => root,
      mode   => 0644,
      source => 'puppet:///modules/logstash/logstash-1.1.1-monolithic.jar',
      require => Package ["openjdk-7-jre"]
    }
   
    file {"/var/tmp/logstash.conf":
      ensure => present,
      owner  => root,
      group  => root,
      mode   => 0644,
      source => 'puppet:///modules/logstash/logstash.conf',
      require => File ["/var/tmp/logstash-1.1.1-monolithic.jar"],
      notify  => Service ["logstash"]
     }

     file {"/etc/init.d/logstash":
      ensure => present,
      owner  => root,
      group  => root,
      mode   => 0755,
      source => 'puppet:///modules/logstash/logstash',
      require => [File ["/var/tmp/logstash-1.1.1-monolithic.jar"],File ["/var/tmp/logstash.conf"]],
      notify => Service ["logstash"]
     }

     service {"logstash":
      ensure => running,
      provider => init,
      enable => true,
      hasstatus => true,
      hasrestart => true,
      require => File ["/etc/init.d/logstash"]
     }
}
