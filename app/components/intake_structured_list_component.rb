# frozen_string_literal: true

# @see IntakeFormComponent

# Binds through the model's `<attr>_attributes=` setter, which expects index-keyed
# params (`solution_intake[current_affiliations_attributes][0][name]`) and drops
# fully-blank rows. See SolutionProperties::HasStoreModelLists.
class IntakeStructuredListComponent < ApplicationComponent
  CONTROLLER = "intake-structured-list-component--intake-structured-list-component"

  # @return [ActionView::Helpers::FormBuilder]
  attr_reader :form

  # @return [Symbol]
  attr_reader :attr

  # @return [String, nil]
  attr_reader :labelled_by

  # @return [String, nil]
  attr_reader :description

  # @param [ActionView::Helpers::FormBuilder] form
  # @param [Symbol] attr the StoreModel list attribute, e.g. :current_affiliations
  # @param [<Symbol>, nil] fields item fields to render (default: the item model's attributes)
  # @param [String, nil] labelled_by id of the group label, for aria-labelledby
  # @param [String, nil] description intro text rendered above the rows
  def initialize(form:, attr:, fields: nil, labelled_by: nil, description: nil)
    @form = form
    @attr = attr
    @fields = fields
    @labelled_by = labelled_by
    @description = description
  end

  # @return [String]
  def controller_id
    CONTROLLER
  end

  # @return [Class] the store-model class backing each row
  def element_class
    SolutionProperty.find(attr.to_s).store_model_type_name.constantize
  end

  # @return [<Symbol>]
  def fields
    @fields || element_class.attribute_names.map(&:to_sym)
  end

  # @return [<Object>]
  def rows
    form.object.public_send(attr).presence || [element_class.new]
  end

  # @return [ActiveSupport::SafeBuffer]
  def render_row(item, index)
    field_divs = fields.map { |field| render_field(item, index, field) }

    helpers.content_tag(:li, class: "intake-structured-list__row", data: { "#{controller_id}-target": "row" }) do
      helpers.safe_join(field_divs + [remove_button])
    end
  end

  private

  def render_field(item, index, field)
    id = field_id(index, field)
    value = item.public_send(field)
    input =
      if field.to_s == "url"
        helpers.url_field_tag(field_name(index, field), value, id:)
      else
        helpers.text_field_tag(field_name(index, field), value, id:)
      end

    helpers.content_tag(:div, class: "intake-structured-list__field") do
      helpers.safe_join([helpers.label_tag(id, field_label(field)), input])
    end
  end

  def remove_button
    helpers.content_tag(
      :button, "Remove",
      type: "button",
      class: "m-button m-button--sm intake-structured-list__remove",
      aria: { label: "Remove row" },
      data: { action: "#{controller_id}#remove" }
    )
  end

  # Index-keyed name so the `<attr>_attributes=` setter (which calls `.values`) receives a hash.
  def field_name(index, field)
    "#{form.object_name}[#{attr}_attributes][#{index}][#{field}]"
  end

  def field_id(index, field)
    "#{form.object_name}_#{attr}_#{index}_#{field}"
  end

  def field_label(field)
    field.to_s == "url" ? "URL" : field.to_s.humanize
  end
end
