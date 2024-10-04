# frozen_string_literal: true

module SolutionProperties
  module Admin
    class PropertyWrapper
      include Renderable
      include Support::Typing
      include Dry::Core::Equalizer.new(:attribute_name)
      include Dry::Initializer[undefined: false].define -> do
        param :property, Types.Instance(::SolutionProperty)

        option :input_name, Types::Coercible::Symbol, default: proc { property.attribute_name.to_sym }
      end

      delegate :attribute_name,
        :kind,
        :meta?,
        :name,
        :ext_name,
        :code,
        :free_input_name,
        :implementation_name,
        :has_free_input?,
        to: :property

      # The properties we receive in the admin tabs CSV do not necessarily
      # correspond to the way we actually handle properties internally.
      #
      # So we normalize the properties when parsing the CSV file to possibly
      # use the actually correct properties, or omit certain properties that
      # needn't be shown.
      #
      # @api private
      # @return [<SolutionProperties::Admin::PropertyWrapper>]
      def normalize
        case kind
        in :implementation_enum
          [wrapper_for(implementation_name)]
        in :implementation_property
          [wrapper_for(implementation_name)]
        in :standard
          # approval_status should be ignored. it's not a real property
          []
        in :other_option
          # these get rendered as part of their associated inputs.
          []
        else
          [self].tap do |a|
            if has_free_input?
              a << wrapper_for(free_input_name.to_s)
            end
          end
        end
      end

      # @!group Form-specific

      def always_skip_form?
        case kind
        when :other_option, :store_model_input
          true
        when :timestamp
          meta?
        else
          false
        end
      end

      def form_grouping_key
        case kind
        when :implementation
          implementation_name
        when :store_model_list
          name
        else
          if property.owner?
            property.owner
          else
            "props"
          end
        end
      end

      def form_grouping_options
        opts = { kind: :generic, label: "" }

        case kind
        when :implementation
          opts[:label] = property.input_label
          opts[:kind] = :implementation
        when :store_model_list
          opts[:kind] = :store_model_list
        else
          opts[:label] = "Properties"
          opts[:kind] = :generic
        end

        return opts
      end

      # @!endgroup

      private

      # @return [void]
      def render_for_form!
        case kind
        when :attachment
          render_form_attachment!
        when :implementation
          render_form_implementation!
        when :store_model_list
          render_form_store_model_list!
        else
          case name
          in "provider_name"
            render_form_provider!
          in "publication"
            render_form_publication!
          else
            render_form_default!
          end
        end
      end

      # @return [void]
      def render_form_attachment!
        form.input input_name, as: :file, input_html: { accept: ImageUploader::ACCEPT }
      ensure
        form.record_property_access! input_name
      end

      def render_form_default!
        form.solution_property input_name
      end

      # @return [void]
      def render_form_implementation!
        form.solution_implementation input_name
      end

      def render_form_provider!
        form.input :provider, as: :select, collection: Provider.to_select_options, required: true, include_blank: true
      ensure
        form.record_property_access! input_name
      end

      def render_form_publication!
        form.input :publication, as: :select
      ensure
        form.record_property_access! input_name
      end

      # @return [void]
      def render_form_store_model_list!
        form.store_model_list_property attribute_name.to_sym do |smlf|
          case property.store_model_type_name
          when "Solutions::Grant"
            smlf.input :name, as: :string, required: false
            smlf.input :starts_on, as: :datepicker, required: false
            smlf.input :ends_on, as: :datepicker, required: false
            smlf.input :display_date, as: :string, required: false
            smlf.input :funder, as: :string, required: false
            smlf.input :amount, as: :string, required: false
            smlf.input :grant_activities, as: :string, required: false
            smlf.input :award_announcement_url, as: :url, required: false
            smlf.input :notes, as: :string, required: false
          else
            smlf.input :name, as: :string, required: true
            smlf.input :url, as: :url, required: true
            smlf.input :description, as: :text, required: false, input_html: { rows: 2 }
          end
        end
      end

      # @return [void]
      def render_for_show!
        case kind
        in :implementation
          render_show_implementation!
        else
          view_context.row attribute_name do |record|
            case name
            when "provider_name"
              record.provider
            else
              render_show_value record
            end
          end
        end
      end

      def render_show_implementation!
        implementation = property.implementation

        view_context.row property.be_label do |record|
          impl = record.__send__(implementation.name)

          view_context.attributes_table_for impl do
            view_context.row implementation.enum_property.input_label do
              view_context.status_tag record.__send__(implementation.enum)
            end

            view_context.row :link do
              view_context.attributes_table_for impl.link do
                view_context.row(:label)
                view_context.row(:url) { simple_link(_1.url) }
              end
            end if implementation.has_single_link?

            view_context.row :links do
              view_context.table_for impl.display_links do
                view_context.column(:label)
                view_context.column(:url) { simple_link(_1.url) }
              end
            end if implementation.has_many_links?
          end
        end
      end

      # @param [Solution, SolutionDraft] record
      # @return [void]
      def render_show_value(record)
        value = record.public_send(attribute_name)

        case kind
        when :attachment
          view_context.image_tag(value.url) if value.present?
        when :blurb, :other_option, :store_model_input
          view_context.simple_format(value) if value.present?
        when :contact
          simple_link(value, label: "Contact Link")
        when :implementation_enum, :enum
          view_context.status_tag value
        when :money
          view_context.humanized_money_with_symbol value
        when :store_model_list
          render_store_model_list_for record
        when :url
          simple_link(value)
        else
          value
        end
      end

      # @param [Solution, SolutionDraft] record
      # @return [void]
      def render_store_model_list_for(record)
        list_data = record.__send__(attribute_name)

        case name
        when "recent_grants"
          view_context.table_for record.recent_grants do
            view_context.column :name
            view_context.column :starts_on
            view_context.column :ends_on
            view_context.column :display_date
            view_context.column :funder
            view_context.column :amount
            view_context.column :award_announcement_url do |r|
              simple_link r.award_announcement_url
            end
            view_context.column :notes
          end
        else
          view_context.table_for list_data do
            view_context.column :name

            view_context.column :url do |r|
              simple_link(r.url)
            end

            view_context.column :description
          end
        end
      end

      def skip_render?
        skip_for_only? || maybe_skip_meta? || maybe_skip_form?
      end

      def skip_for_only?
        property.only.present? && property.only != solution_kind
      end

      def maybe_skip_meta?
        return false unless meta?

        case kind
        when :implementation
          false
        when :timestamp
          form?
        else
          case name
          when "provider_name", "publication"
            draft?
          else
            false
          end
        end
      end

      def maybe_skip_form?
        return false unless form?

        always_skip_form?
      end

      def simple_link(url, label: url)
        return if url.blank?

        view_context.link_to url, url, target: "_blank", rel: "noopener"
      end

      def wrapper_for(name)
        property = SolutionProperty.find name

        self.class.new(property)
      end

      class << self
        # @api private
        # @see #normalize
        # @return [<SolutionProperties::Admin::PropertyWrapper>]
        def normalize(...)
          new(...).normalize
        end
      end
    end
  end
end
