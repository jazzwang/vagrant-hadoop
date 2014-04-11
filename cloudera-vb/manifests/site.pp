node 'node1.etu.im' {
  class { 'cloudera':
    cm_server_host => 'node1.etu.im',
    use_parcels => false,
  } ->
  class { 'cloudera::cm::server': }
}
