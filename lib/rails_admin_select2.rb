require 'rails_admin_select2/engine'

module RailsAdminSelect2
end

module RailsAdmin
  module Config
    module Fields
      module Types
        # Add support for select2 input fields to RailsAdmin.
        class Select2 < RailsAdmin::Config::Fields::Base
          RailsAdmin::Config::Fields::Types::register(self)
          def initialize(parent, name, properties)
            super(parent, name, properties)
            @meta = abstract_model.model.reflect_on_association(name)
            if not [:belongs_to, :has_one, :has_many, :has_and_belongs_to_many].include? @meta.macro
              raise RuntimeError.new('Cannot render select2 for association %s#%s of type %s.' % [@meta.class_name, @meta.name, @meta.macro])
            end            
          end
          register_instance_option(:partial) do
            :form_select2
          end
          register_instance_option(:multiple?) do
            [:has_many, :has_and_belongs_to_many].include? @meta.macro
          end
          register_instance_option(:collection) do
            @meta.class_name.safe_constantize.all.map{ |object| [ object.name, object.id ] }
          end
          # For Mongoid, the method_name required is <name>_id[s],
          # e.g. children_ids or parent_id.
          #
          # To construct method_name, start with the association name and
          # append '_id' or '_ids' for :belongs_to and all other types
          # of associations, respectively.
          #
          # TODO Does this work in AR, too?
          def method_name
            '%s_%s' % [ @meta.name.to_s.singularize, multiple? ? 'ids' : 'id' ]
          end
        end
      end
    end
  end
end
