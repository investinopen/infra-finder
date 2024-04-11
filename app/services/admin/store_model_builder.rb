# frozen_string_literal: true

module Admin
  class StoreModelBuilder < SimpleDelegator
    include Admin::StoreModelLogic

    def initialize(form_builder, attr, **options)
      super form_builder

      @attr = attr
      @store_model_type = find_store_model_type!
      @options = extract_custom_settings!(options.dup)
      @options.reverse_merge!(for: attr)
      @options[:class] = [options[:class], "inputs", "has-many-fields"].compact.join(" ")
    end

    def render(&)
      html = "".html_safe
      html << template.content_tag(:h3, class: "has-many-fields-title") { heading } if heading.present?
      html << render_instructions
      html << template.capture { render_store_model_form(&) }
      html = wrap_div_or_li(html)
      template.concat(html) if template.output_buffer
      html
    end

    private

    def extract_custom_settings!(options)
      @heading = options.key?(:heading) ? options.delete(:heading) : default_heading
      @instructions = options.delete(:instructions)

      options
    end

    def render_store_model_form(&)
      without_wrapper do
        inputs(attr, options) do |form_builder|
          yield form_builder
        end
      end.presence || "".html_safe
    end

    # @param [String] html
    # @return [String]
    def wrap_div_or_li(html)
      tag = already_in_an_inputs_block ? :li : :div

      template.content_tag(tag, html, class: "has_many_container")
    end
  end
end
