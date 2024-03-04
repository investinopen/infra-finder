# frozen_string_literal: true

class AddCommonEnums < ActiveRecord::Migration[7.1]
  def change
    create_enum :implementation_status, %w[available in_progress considering not_planning not_applicable unknown]
    create_enum :visibility, %w[visible hidden]
  end
end
