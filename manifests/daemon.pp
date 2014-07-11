class sauceconnect::daemon($username, $apikey, $tunnel_identifier='') {
  $logdir = '/var/log/sauce'

  file {
    $logdir :
      ensure => directory;

    '/etc/default/sauce-connect' :
      ensure  => present,
      content => "
SAUCE_CONNECT=/usr/share/sauce/sc
API_USER=${username}
API_KEY=${apikey}
USERNAME=
GROUP=
TUNNEL_IDENTIFIER=${tunnel_identifier}
LOG_DIR=${logdir}
LOG_FILE=${logdir}/sc.log
";

    '/etc/init/sauce-connect.conf' :
      ensure => 'present',
      mode   => 0644,
      owner  => 'root',
      group  => 'root',      
      notify => Service['sauce-connect'],
      source => 'puppet:///modules/sauceconnect/init_sauce-connect';

    # Create a symlink to /etc/init/*.conf in /etc/init.d, because Puppet 2.7 looks 
    # there incorrectly (see: http://projects.puppetlabs.com/issues/14297)
    '/etc/init.d/sauce-connect':
      ensure => link,
      target => '/lib/init/upstart-job';
  }

  service {
    'sauce-connect' :
      ensure     => running,
      hasrestart => true,
      hasstatus  => true,
      provider   => 'upstart',
      require    => File['/etc/init.d/sauce-connect'];
  }
}
