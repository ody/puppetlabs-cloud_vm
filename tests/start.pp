cloud_vm { 'testing':
  #ensure    => absent,
  ensure     => present,
  image      => 'ami-03c49446',
  flavor     => 't1.micro',
  access_key => 'Access',
  region     => 'us-west-1',
  provider   => 'ec2',
}
#cloud_vm { 'foo':
  #ensure   => absent,
#  ensure   => present,
#  image    => 'ami-0c638165',
#  flavor   => 't1.micro',
#  provider => 'ec2',
#}
#cloud_vm { 'bar':
  #ensure   => absent,
#  ensure   => present,
#  image    => 'ami-0c638165',
#  flavor   => 't1.micro',
#  provider => 'ec2',
#}
