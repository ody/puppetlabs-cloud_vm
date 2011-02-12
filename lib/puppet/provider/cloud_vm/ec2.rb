Puppet::Type.type(:cloud_vm).provide(:ec2) do
  desc "ec2 provider that uses fog to launch instances on AWS."

  require 'fog'

  def self.connect
    Fog::Compute.new(
      :provider => 'AWS'
    )
  end

  def self.instances

    connection = connect

    inst = []

    vm = {}

    connection.servers.each { |i|
      vm = {
        :name    => i.tags['Name'],
        :status  => i.state,
        :managed => i.tags['puppet_prov'],
        :id      => i.id,
        :flavor  => i.flavor_id,
        :image   => i.image_id
      }

      vm[:provider] = self.name

      if vm[:status] == 'running'
        vm[:ensure] = :present
      else
        vm[:ensure] = :absent
      end
      if vm[:name] != nil and vm[:managed] == 'true'
        inst << new(vm)
      end
    }
    debug inst
    inst
  end

  def exists?
    debug @property_hash.inspect
    if @property_hash[:ensure] == :present
      out = true
    elsif @property_hash[:ensure] == :absent or @property_hash.empty?
      if property_hash[:ensure] == :present
        out = true
      end
    end
    out
  end


  def create

    connection = self.class.connect

    id = connection.servers.create(
      :flavor_id => @resource[:flavor],
      :image_id  => @resource[:image]
    ).id

    connection.tags.create(
      :resource_id => id,
      :key         => 'Name',
      :value       => @resource[:name]
    )

    connection.tags.create(
      :resource_id => id,
      :key         => 'puppet_prov',
      :value       => 'true'
    )

  end

  def destroy

    connection = self.class.connect

    server = connection.servers.find { |i|
      i.tags['Name'] == @resource[:name] and i.tags['puppet_prov'] == 'true'
    }

    id = server.id
    connection.delete_tags("#{id}", { 'Name' => "#{@resource[:name]}" })

    server.destroy

  end

end
