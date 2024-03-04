<%-
  # vim: set ft=ruby.eruby :
-%>
# frozen_string_literal: true

RSpec.describe <%= class_name %>Policy, type: :policy do
  subject { described_class.new(identity, <%= factory_name %>) }

  let_it_be(<%= factory_name.inspect %>) { FactoryBot.create <%= factory_name.inspect %> }
  let_it_be(:identity) { FactoryBot.create :user }
end
