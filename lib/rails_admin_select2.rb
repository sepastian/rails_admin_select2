require 'rails_admin_select2/engine'

module RailsAdminSelect2
end

module RailsAdmin
  module Config
    module Fields
      module Types
        # Add support for select2 input fields to RailsAdmin.
        #
        # Select2 home with demos: http://ivaynberg.github.io/select2/.
        class Select2 < RailsAdmin::Config::Fields::Base
          RailsAdmin::Config::Fields::Types::register(self)
          # For relations, render a (multi)select select2 field.
          # For strings, render a hidden field for tagging (if :tags is an array).
          def initialize(parent, name, properties)
            super(parent, name, properties)
            # Mongoid allows field aliases (:as).
            # Map both names and aliases to field meta information.
            @fields = Hash[*(abstract_model.model.fields.map{|k,v| [[k.to_sym,v],[v.options[:as].try(:to_sym),v]]}.flatten)].delete_if{|k,v| k.nil?}
            @relation = abstract_model.model.reflect_on_association(name)
            @arity = {
              :embeds_one              => :one,
              :embedded_in             => :one,
              :embeds_many             => :many,
              :belongs_to              => :one,
              :has_one                 => :one,
              :has_many                => :many,
              :has_and_belongs_to_many => :many
            }
          end
          # If tags have been supplied, render a select2 field for tagging.
          # See http://ivaynberg.github.io/select2/#tags.
          #
          # The tags supplied will be available as choices in the tagging field,
          # new tags can be added.
          #
          # To render a tagging field without predefined choices, supply []
          # to tags, like so:
          #
          #     config.model "Model" do
          #       edit do
          #         field do
          #           tags []
          #         end
          #       end
          #     end
          #
          # If no tags have been supplied, a collection of associated objects
          # will be rendered for selection. See the :collection instance option.
          #
          # To disable tagging (the default) explicitly, set tags to nil.
          register_instance_option(:tags) do
            tagging? ? [] : nil
          end
          register_instance_option(:partial) do
            tagging? ? :form_select2_tags : :form_select2
          end
          # If true, allow selecting multiple associated objects.
          # 
          # This will be true, if the association macro is one of
          # :has_many, :has_and_belongs_to_many, or :embeds_many.
          # 
          # Raise a RuntimeError if tagging? has been enabled.
          register_instance_option(:multiple?) do
            if tagging?
              raise RuntimeError.new "cannot render select2 because #{abstract_model.model.to_s}##{@name} does not define a relation"
            end
            @arity[@relation.macro] == :many
          end
          # Per default, assemble a collection of all objects for this
          # association by class name.
          #
          # For instance, if the association to render is article.article_group,
          # the collection used for the select2 field will contain all ArticleGroups.
          # 
          # If :tags have been supplied, a tagging field will be rendered
          # and no collection is required/will be assembled.
          register_instance_option(:collection) do
            return nil if tagging?
            @relation.class_name.safe_constantize.all.map{ |object| [ object.name, object.id ] }
          end
          # For Mongoid, the method_name for referenced associations is <name>_id[s],
          # e.g. children_ids or parent_id; for embedded documents it is <name> or 
          # <name>s, respectively.
          #
          # Return #{name} for embedded documents, #{name}_id for referenced documents;
          # append 's', if the association references multiple documents.
          #
          # TODO How does this work in AR?
          def method_name
            return @name if tagging?
            embedded = [ :embeds_one, :embeds_many, :embedded_in ].include? @relation.macro
            m = embedded ? @relation.name.to_s.singularize : "#{@relation.name.to_s.singularize}_id"
            multiple? ? m.pluralize : m
          end
          
          private

          # Return true, if this tagging should be enabled for this field.
          # 
          # For tagging to be enabled, the type of the field must be
          # Mongoid::Fields::Standard and the type of the attribute
          # must be String.
          #
          # Tagging is not supported for relation fields (associations).
          def tagging?
            # The name of a relation and the name of the field
            # storing values for the relation differ (<name>_id[s] vs <name>).
            # If @fields does not contain a value for @name,
            # this field is a relation and tagging is not supported.
            return false unless @fields.has_key?(@name)
            # Tagging requires a field of type Mongoid::Fields::Standard
            # with an attribute of type String.
            klass = @fields[@name].class
            type = @fields[@name].options[:type]
            # TODO allow type of String and Array?
            klass == Mongoid::Fields::Standard && [ ::String ].include?(type)
          end
        end
      end
    end
  end
end
