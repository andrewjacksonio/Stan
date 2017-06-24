node default { 
  package { 'php':
    ensure => installed,
  }

  class { 'apache':                # use the "apache" module
    default_vhost => false,        # don't use the default vhost
    default_mods  => false,        # don't load default mods
    mpm_module    => 'prefork',    # use the "prefork" mpm_module
  }

  include apache::mod::php

  apache::vhost { 'stan.andrewjackson.io-nonssl':    
    port            => '80',    
    docroot         => '/var/www/html',
    directoryindex  => 'default.php',
    redirect_status => 'permanent',
    redirect_dest   => 'https://stan.andrewjackson.io/',
    error_documents => [
      { 'error_code' => '404', 'document' => 'http://hotdot.pro/en/404/' },
    ],
  }

  apache::vhost { 'stan.andrewjackson.io-ssl':
    servername      => 'stan.andrewjackson.io',
    port            => '443',
    docroot         => '/var/www/html',
    ssl             => true,
    directoryindex  => 'default.php',
    error_documents => [
      { 'error_code' => '404', 'document' => 'http://hotdot.pro/en/404/' },
    ],
  }

  include ::openssl

  openssl::x509::generate { 'stan.andrewjackson.io':
    email               => 'jackson.andrew@gmail.com',
    country             => 'AU',
    state               => 'NSW',
    locality            => 'Sydney',
    organization        => 'andrewjackson.io',
    organizational_unit => 'Stan',
    commonname          => 'stan.andrewjackson.io',
    altnames            => ['stan.andrewjackson.io'],
  }

  file { '/var/www/html/info.php':
    ensure => file,
    content => '<?php  phpinfo(); ?>',
  }

  file { '/var/www/html/default.php':
    ensure  => file,
    content => join([ 
      '<?php',
      '$instance_id = file_get_contents("http://169.254.169.254/latest/meta-data/instance-id");',
      'echo $instance_id, "\n";',
      '?>'],' ')
  }
}