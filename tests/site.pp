cloud_vm { 'testing':
  ensure   => present,
  user_id  => 'auser',
  api_key  => 'akey',
  size     => '2',
  type     => '49',
  provider => 'rackspace',
}
