Puppet::Type.type(:cloud_vm).provide(:rackspace) do
  desc "Rackspace provider that uses fog to launch instances on Rackspace
    cloud."

  require 'fog'

  def self.connect
    conn = Fog::Compute.new(
      :provider => 'Rackspace'
    )

    #We are going to refresh the servers collection method while we are here.
    conn.list_servers

    return conn
  end

  def self.instances

    connection = connect

    inst = []

    vm = {}

    connection.servers.all.each { |i|
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

      inst << new(vm)
    }

    inst

  end

  def exists?
    @property_hash[:ensure] != :absent
  end

  def create

    connection = self.class.connect

    connection.servers.create(
      :flavor_id => @resource[:size].to_i,
      :image_id  => @resource[:type].to_i,
      :name      => @resource[:name]
    )

    end

  def destroy

    connection = self.class.connect

    connection.servers.all.find { |i|
      i.name == @resource[:name]
    }.destroy

  end

end
