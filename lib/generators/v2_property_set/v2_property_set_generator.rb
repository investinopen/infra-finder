# frozen_string_literal: true

class V2PropertySetGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  SIMPLE_MAPPING = {
    blurb: :string,
    boolean: :boolean,
    contact: :string,
    date: :date,
    email: :string,
    integer: :big_integer,
    other_option: :string,
    single_option: :string,
    store_model_input: :string,
    string: :string,
    timestamp: :datetime,
    url: :string,
  }.freeze

  def v2_property_set
    template "property_set.rb", Rails.root.join("app", "services", "solutions", "revisions", "v2_property_set.rb")
  end

  private

  def attribute_for(attr)
    name = attr.to_s

    prop = SolutionProperty.find name

    type = type_for(prop)

    %[attribute #{name.to_sym.inspect}, #{type}]
  end

  # @param [SolutionProperty] prop
  def type_for(prop)
    case prop.kind
    when :attachment
      %[::Solutions::Revisions::Attachment.to_type]
    when :enum
      %[:string]
    when :implementation
      implementation_type_for(prop)
    when :implementation_enum
      implementation_enum_type_for(prop)
    when :money
      %[::Solutions::Revisions::MoneyValue.to_type]
    when :store_model_list
      store_model_list_type_for(prop)
    when :multi_option
      %{:string_array, default: [].freeze}
    else
      SIMPLE_MAPPING.fetch(prop.kind, :any_json).inspect
    end
  end

  def implementation_type_for(prop)
    %[::#{prop.implementation.type.name}.to_type]
  end

  def implementation_enum_type_for(prop)
    %[:string]
  end

  def store_model_list_type_for(prop)
    %{::#{prop.store_model_type_name}.to_array_type, default: [].freeze}
  end
end
