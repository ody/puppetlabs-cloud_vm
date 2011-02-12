cloud_vm { 'testing':
  ensure   => present,
  image    => 'ami-0c638165',
  flavor   => 't1.micro',
  provider => 'ec2',
}
