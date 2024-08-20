# frozen_string_literal: true

module Admin
  class CSVExporter < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :builder, Types::CSVBuilder

      param :scope, Support::Types::Relation
    end

    standard_execution!

    alias b builder

    # @return [Array]
    attr_reader :columns

    # @return [StringIO]
    attr_reader :csv

    # @return [Hash]
    attr_reader :csv_options

    # @return [String]
    attr_reader :output

    # @return [Admin::FakeViewContext]
    attr_reader :view_context

    def call
      run_callbacks :execute do
        yield prepare!

        yield export_csv!
      end

      Success output
    end

    wrapped_hook! def prepare
      @view_context = Admin::FakeViewContext.new

      builder.exec_columns view_context

      @columns = builder.columns

      @csv = StringIO.new

      @csv_options = b.options.except :column_names, :encoding_options, :humanize_name, :byte_order_mark

      @output = nil

      super
    end

    wrapped_hook! def export_csv
      csv << CSV.generate_line(b.columns.map { |c| b.sanitize(b.encode(c.name, b.options)) }, **csv_options)

      scope.each do |resource|
        csv << CSV.generate_line(b.build_row(resource, columns, b.options), **csv_options)
      end

      @output = csv.string

      super
    end
  end
end
