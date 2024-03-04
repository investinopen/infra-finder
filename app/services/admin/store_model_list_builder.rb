# frozen_string_literal: true

module Admin
  # @api private
  class StoreModelListBuilder < SimpleDelegator
    include Admin::StoreModelLogic

    # @return [String]
    attr_reader :heading

    # @return [String, Boolean]
    attr_reader :new_record

    # @return [String]
    attr_reader :remove_record

    def initialize(form_builder, attr, **options)
      super form_builder

      @attr = attr
      @store_model_type = find_store_model_type!
      @options = extract_custom_settings!(options.dup)
      @options[:for] = attr
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
      @new_record = options.key?(:new_record) ? options.delete(:new_record) : true
      @remove_record = options.delete(:remove_record)

      options
    end

    def content_has_many(&)
      form_block = proc do |form_builder|
        render_store_model_list(form_builder, options[:parent], &)
      end

      template.assigns[:has_many_block] = true

      contents = without_wrapper do
        inputs(options, &form_block)
      end

      contents ||= "".html_safe

      js = new_record ? js_for_has_many(options[:class], &form_block) : ""

      contents << js
    end

    # Renders the Formtastic inputs then appends ActiveAdmin delete and sort actions.
    def render_store_model_list(form_builder, parent)
      index = parent && form_builder.send(:parent_child_index, parent)

      template.concat template.capture { yield(form_builder, index) }

      template.concat has_many_actions(form_builder, "".html_safe)
    end

    def has_many_actions(form_builder, contents)
      contents << template.content_tag(:li, class: "input") do
        remove_text = remove_record.is_a?(String) ? remove_record : I18n.t("active_admin.has_many_remove")
        template.link_to remove_text, ?#, class: "button has_many_remove"
      end

      contents
    end

    def js_for_has_many(class_string, &)
      attr_name = store_model_type.name

      placeholder = "NEW_#{attr_name.to_s.underscore.upcase.tr(?/, ?_)}_RECORD"

      opts = {
        for: [attr, store_model_type.new],
        class: class_string,
        for_options: { child_index: placeholder }
      }

      html = template.capture { __getobj__.send(:inputs_for_nested_attributes, opts, &) }

      text = new_record.is_a?(String) ? new_record : I18n.t("active_admin.has_many_new", model: attr_name.demodulize.titleize)

      template.link_to text, ?#, class: "button has_many_add", data: {
        html: CGI.escapeHTML(html).html_safe,
        placeholder:,
      }
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
