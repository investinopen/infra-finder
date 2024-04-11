# frozen_string_literal: true

module Admin
  class EnhancedFormBuilder < ActiveAdmin::FormBuilder
    def solution_implementation(attr, &)
      obj_type = object.__send__(attr).class

      impl_enum = :"#{attr}_implementation"

      title = Solution.human_attribute_name(attr, default: attr.to_s.titleize)

      inputs title do
        input(impl_enum, label: "Implemented?", as: :select)

        store_model(attr, heading: false) do |impf|
          yield impf if block_given?

          if obj_type.has_statement?
            impf.input :statement, as: :text
          end

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

    def store_model(attr, **options, &)
      Admin::StoreModelBuilder.new(self, attr, **options).render(&)
    end

    def store_model_list(*args, **kwargs, &)
      Admin::StoreModelListBuilder.new(self, *args, **kwargs).render(&)
    end
  end
end
