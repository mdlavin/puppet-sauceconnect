class sauceconnect($username="", $apikey="", $tunnel_identifier="") {
  $dir = '/usr/share/sauce'

  file {
    $dir :
      ensure => directory;

    "$dir/sc" :
      ensure  => present,
      require => File[$dir],
      source  => 'puppet:///modules/sauceconnect/sc';
  }

  class {
    "sauceconnect::${osfamily}" : ;
    'sauceconnect::daemon' :
      username => $username,
      apikey   => $apikey,
      tunnel_identifier   => $tunnel_identifier;
  }
}
