require_relative '../resource'
require_relative 'aws_ec2_subnet_route_table_association'

module Convection

  module DSL
    ## Add DSL method to template namespace
    module Template
      def ec2_subnet(name, &block)
        r = Model::Template::Resource::EC2Subnet.new(name, self)

        r.instance_exec(&block) if block
        resources[name] = r
      end

      module Resource
        ##
        # Add DSL for RouteTableAssocaition
        module EC2Subnet
          def associate_route_table(table, &block)
            r = Model::Template::Resource::EC2SubnetRouteTableAssociation.new("#{ name }RouteTableAssociation#{ table.name }", @tamplate)
            r.route_table(table.reference)
            r.subnet(reference)

            r.instance_exec(&block) if block
            @template.resources[r.name] = r
          end
        end
      end
    end
  end

  module Model
    class Template
      class Resource
        ##
        # AWS::EC2::Subnet
        ##
        class EC2Subnet < Resource
          include DSL::Template::Resource::EC2Subnet
          include Model::Mixin::CIDRBlock
          include Model::Mixin::Taggable

          def initialize(*args)
            super
            type 'AWS::EC2::Subnet'
          end

          def availability_zone(value)
            property('AvailabilityZone', value)
          end

          def vpc_id(value)
            property('VpcId', value)
          end

          def render(*args)
            super.tap do |resource|
              render_tags(resource)
            end
          end
        end
      end
    end
  end
end
