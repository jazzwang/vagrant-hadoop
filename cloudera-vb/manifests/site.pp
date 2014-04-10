node 'node1.etu.me' {
  class { 'cloudera':
    cm_server_host => 'node1.etu.me',
    use_parcels => false,
  } ->
  class { 'cloudera::cm::server': }
}
