# frozen_string_literal: true

Dry::Logic::Predicates.predicate :rails_blank? do |input|
  input.blank?
end

Dry::Logic::Predicates.predicate :rails_present? do |input|
  input.present?
end

Dry::Logic::Predicates.predicate :email? do |input|
  format? URI::MailTo::EMAIL_REGEXP, input
end

Dry::Logic::Predicates.predicate :uri_scheme? do |scheme, input|
  return false unless str?(input) && rails_present?(input)

  uri = URI.parse(input)
rescue URI::Error
  false
else
  scheme === uri.scheme
end

Dry::Logic::Predicates.predicate :global_id_uri? do |input|
  uri_scheme?(/\Agid\z/, input)
end

Dry::Logic::Predicates.predicate :global_id? do |input|
  return false if rails_blank?(input) || !(global_id_uri?(input) || type?(::GlobalID, input))

  gid = GlobalID.parse input

  return false if gid.blank?

  begin
    gid.model_class.present?
  rescue NameError
    false
  end
end

Dry::Logic::Predicates.predicate :http_uri? do |input|
  uri_scheme?(/\Ahttps?\z/, input)
end

Dry::Logic::Predicates.predicate :https_uri? do |input|
  uri_scheme?(/\Ahttps\z/, input)
end

Dry::Logic::Predicates.predicate :inherits? do |parent, input|
  type?(Class, input) && input < parent
end

Dry::Logic::Predicates.predicate :model? do |input|
  type?(ActiveRecord::Base, input)
end

Dry::Logic::Predicates.predicate :model_list? do |input|
  array?(input) && input.all? { |elm| model? elm }
end

Dry::Logic::Predicates.predicate :model_class? do |input|
  inherits?(ActiveRecord::Base, input)
end

Dry::Logic::Predicates.predicate :model_class_list? do |input|
  array?(input) && input.all? { |elm| model_class?(input) }
end

Dry::Logic::Predicates.predicate :relation? do |input|
  type?(ActiveRecord::Relation, input)
end

Dry::Logic::Predicates.predicate :relation_for? do |model_klass, input|
  relation?(input) && (
    (model_class?(model_klass) && input.model <= model_klass) ||
      (model_klass.kind_of?(Dry::Types::Type) && model_klass.valid?(input.model))
  )
end

Dry::Logic::Predicates.predicate :specific_model? do |model_name, input|
  model?(input) && input.model_name == model_name
end

Dry::Logic::Predicates.predicate :dry_type? do |input|
  type?(Dry::Types::Type, input)
end
