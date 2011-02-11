Puppet::Type.type(:cloud_vm).provide(:rackspace) do
  desc "Rackspace provider that uses fog to launch instances on Rackspace
    cloud."

  require 'fog'

  def self.instances

    connection = Fog::Compute.new(
      :provider           => 'Rackspace',
      :rackspace_api_key  => @resource[:api_key],
      :rackspace_username => @resource[:user_id]
    )

    inst = []

    vm = {}

    connection.servers.each { |i|
      vm = {
        :name => i.name,
        :status => i.status
      }

      vm[:provider] = self.name

      if vm[:status] == 'ACTIVE'
        vm[:ensure] = :present
      else
        vm[:ensure] = :absent
      end

      inst << vm
    }

    inst

  end

  def exists?
    connection = Fog::Compute.new(
      :provider           => 'Rackspace',
      :rackspace_api_key  => @resource[:api_key],
      :rackspace_username => @resource[:user_id]
    )

    connection.servers.find { |i|
      i.name == @resource[:name]
    }
  end

  def create

  connection = Fog::Compute.new(
    :provider           => 'Rackspace',
    :rackspace_api_key  => @resource[:api_key],
    :rackspace_username => @resource[:user_id]
  )

  connection.servers.create(
    :flavor_id => @resource[:size].to_i,
    :image_id  => @resource[:type].to_i,
    :name      => @resource[:name]
  )

  end

  def destroy

  connection = Fog::Compute.new(
    :provider           => 'Rackspace',
    :rackspace_api_key  => @resource[:api_key],
    :rackspace_username => @resource[:user_id]
  )

  connection.servers.find { |i|
    i.name == @resource[:name]
  }.destroy

  end

end
