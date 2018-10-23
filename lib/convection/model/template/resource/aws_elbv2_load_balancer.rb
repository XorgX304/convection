require_relative '../resource'

module Convection
  module Model
    class Template
      class Resource
        ##
        # AWS::ElasticLoadBalancingV2::LoadBalancer
        ##
        class ELBV2LoadBalancer < Resource
          include Model::Mixin::Taggable

          type 'AWS::ElasticLoadBalancingV2::LoadBalancer', :elbv2_load_balancer
          property :load_balancer_attributes, 'LoadBalancerAttributes', :type => :list
          property :name, 'Name'
          property :scheme, 'Scheme'
          property :security_group, 'SecurityGroups', :type => :list
          alias security_groups security_group
          property :subnet, 'Subnets', :type => :list
          alias subnets subnet
          property lb_type, 'Type'
          property :subnet_mappings, 'SubnetMappings', :type => :list

          # Append a load_balancer_attribute to load_balancer_attributes
          def load_balancer_attribute(&block)
            attribute = ResourceProperty::ELBV2LoadBalancerAttribute.new(self)
            attribute.instance_exec(&block) if block
            load_balancer_attributes << attribute
          end

          def subnet_mapping(&block)
            subnet_mapping = ResourceProperty::ELBV2LoadBalancerSubnetMapping.new(self)
            subnet_mapping.instance_exec(&block) if block
            subnet_mappings << subnet_mapping
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
