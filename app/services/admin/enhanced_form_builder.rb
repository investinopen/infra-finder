# frozen_string_literal: true

module Admin
  class EnhancedFormBuilder < ActiveAdmin::FormBuilder
    include Dry::Effects.State(:form_access, default: proc { Hash.new { |h, k| h[k] = 0 }.with_indifferent_access })

    # @param [#to_s] attr
    def controlled_vocabulary(attr)
      record_property_access!(attr)

      connection = object.vocab_connection_for(attr)

      property = connection.property

      options = property.input_options.merge(
        collection: connection.fetch_options!
      )

      input(property.input_attr, **options)
    end

    # @param [#to_s] attr
    def solution_implementation(attr, &)
      obj_type = object.__send__(attr).class

      impl = Implementation.find(attr.to_s)

      record_property_access!(impl.name)

      record_property_access!(impl.enum)

      template.capture do
        input(impl.enum, label: impl.enum_property.input_label, as: :select)

        store_model(attr, heading: false, name: "Details") do |impf|
          yield impf if block_given?

          impf.input :statement, as: :hidden

          if obj_type.has_many_links?
            heading = obj_type.human_attribute_name(:links)

            instructions = I18n.t("implementations.link_messages.many")

            impf.store_model_list(:links, heading:, instructions:, new_record: "Add link") do |lf|
              lf.input :url, as: :url, required: true
              lf.input :label, as: :string, required: false
            end
          elsif obj_type.has_single_link?
            heading = obj_type.human_attribute_name(:link)

            instructions = I18n.t("implementations.link_messages.single")

            impf.store_model(:link, heading:, instructions:) do |lf|
              lf.input :url, as: :url, required: true
              lf.input :label, as: :string, required: false
            end
          end
        end
      end
    end

    # @param [#to_s] attr
    def solution_property(attr)
      record_property_access!(attr)

      property = SolutionProperty.find attr.to_s

      template.capture do
        render_property_input!(property)

        render_free_input_field_for!(property)
      end
    end

    # @param [#to_s] attr
    # @return [void]
    def record_property_access!(attr)
      # :nocov:
      return if /\Alinks\z/.match?(attr)
      return unless Rails.env.local?
      # :nocov:

      form_access[attr] += 1

      # We must explicitly return nil here in order to avoid writing the count to the HTML.
      return nil
    end

    # @param [#to_s] attr
    def store_model(attr, **options, &)
      Admin::StoreModelBuilder.new(self, attr, **options).render(&)
    end

    def store_model_list(*args, **kwargs, &)
      Admin::StoreModelListBuilder.new(self, *args, **kwargs).render(&)
    end

    def store_model_list_property(attr, *args, **kwargs, &)
      record_property_access!(attr)

      prop = SolutionProperty.find attr.to_s

      kwargs[:solution_property] = prop
      kwargs[:heading] = "#{prop.input_label} — Structured"
      kwargs[:instructions] = prop.input_hint

      inputs prop.input_label do
        template.capture do
          store_model_list(attr, *args, **kwargs, &)
          template.concat solution_property(prop.free_input_name)
        end
      end
    end

    private

    # @param [SolutionProperty] property
    def render_property_input!(property)
      return controlled_vocabulary(property.name) if property.has_vocab?

      options = property.input_options

      input property.input_attr, **options
    end

    # @param [SolutionProperty] property
    def render_free_input_field_for!(property)
      return unless property.has_free_input?

      record_property_access!(property.other_property.input_attr.to_s)

      render_property_input!(property.other_property)
    end
  end
end
