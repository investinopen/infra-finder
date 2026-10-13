# frozen_string_literal: true

module VOG
  module IdQuoting
    extend ActiveSupport::Concern

    # Quote the model's primary key if it is persisted and a single string.
    #
    # @return [String, nil]
    def quoted_id
      self.class.connection.quote id if persisted? && id.kind_of?(String)
    end

    module ClassMethods
      # @return [<String>]
      def quoted_ids
        ids.map { |id| connection.quote id }
      end
    end
  end
end
