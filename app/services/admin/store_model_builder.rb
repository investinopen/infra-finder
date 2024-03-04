# frozen_string_literal: true

module Admin
  class StoreModelBuilder < SimpleDelegator
    include Admin::StoreModelLogic

    # @return [String]
    attr_reader :heading

    # @return [String, Boolean]
    attr_reader :new_record

    def initialize(form_builder, attr, **options)
      super form_builder

      @attr = attr
      @store_model_type = find_store_model_type!
      @options = extract_custom_settings!(options.dup)
      @options.reverse_merge!(for: __getobj__.object.__send__(attr))
      @options[:class] = [options[:class], "inputs has-many-fields"].compact.join(" ")
    end

    def render(&)
      html = "".html_safe
      html << template.content_tag(:h3, class: "has-many-fields-title") { heading } if heading.present?
      html << template.capture { content_has_many(&) }
      html = wrap_div_or_li(html)
      template.concat(html) if template.output_buffer
      html
    end

    private

    def extract_custom_settings!(options)
      @heading = options.key?(:heading) ? options.delete(:heading) : default_heading

      options
    end

    def content_has_many(&)
      form_block = proc do |form_builder|
        render_store_model_obj(form_builder, options[:parent], &)
      end

      template.assigns[:has_many_block] = true

      without_wrapper { inputs(options, &form_block) }.presence || "".html_safe
    end

    def render_store_model_obj(form_builder, parent, &)
      index = parent && form_builder.send(:parent_child_index, parent)

      template.concat template.capture { yield(form_builder, index) }
    end

    # @param [String] html
    # @return [String]
    def wrap_div_or_li(html)
      template.content_tag(
        already_in_an_inputs_block ? :li : :div,
        html,
        class: "has_many_container",
        "data-has-many-association" => attr,
        "data-sortable" => nil,
        "data-sortable-start" => nil
      )
    end
  end
end
