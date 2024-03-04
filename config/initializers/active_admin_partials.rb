# frozen_string_literal: true

module ActiveAdmin
  class PartialTemplateHandler
    def call(template, *)
      <<~RUBY
      Arbre::Context.new(assigns, self) do
        context.instance_eval do
          #{template.source}
        end
      end.to_s
      RUBY
    end
  end
end

ActionView::Template.register_template_handler :aa, ActiveAdmin::PartialTemplateHandler.new
