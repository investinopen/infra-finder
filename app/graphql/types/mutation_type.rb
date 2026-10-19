# frozen_string_literal: true

module Types
  # The base type for defining mutations.
  class MutationType < Types::BaseObject
    description <<~TEXT
    The entry point for making changes to the data within the API.
    TEXT

    field :controlled_vocabulary_record_create, mutation: Mutations::ControlledVocabularyRecordCreate

    field :controlled_vocabulary_record_destroy, mutation: Mutations::ControlledVocabularyRecordDestroy

    field :controlled_vocabulary_record_replace, mutation: Mutations::ControlledVocabularyRecordReplace

    field :controlled_vocabulary_record_update, mutation: Mutations::ControlledVocabularyRecordUpdate

    field :controlled_vocabulary_records_set_visibility, mutation: Mutations::ControlledVocabularyRecordsSetVisibility

    field :error_test, mutation: Mutations::ErrorTest

    field :solution_create, mutation: Mutations::SolutionCreate

    field :solution_create_draft, mutation: Mutations::SolutionCreateDraft

    field :solution_draft_destroy, mutation: Mutations::SolutionDraftDestroy

    field :solution_draft_update, mutation: Mutations::SolutionDraftUpdate

    field :solution_intake_update, mutation: Mutations::SolutionIntakeUpdate

    field :solution_update, mutation: Mutations::SolutionUpdate

    field :user_confirm, mutation: Mutations::UserConfirm

    field :user_request_password_reset, mutation: Mutations::UserRequestPasswordReset

    field :user_resend_confirmation, mutation: Mutations::UserResendConfirmation

    field :user_reset_password, mutation: Mutations::UserResetPassword

    field :user_sign_in, mutation: Mutations::UserSignIn

    field :user_unlock, mutation: Mutations::UserUnlock

    field :viewer_accept_terms, mutation: Mutations::ViewerAcceptTerms, terms_exempt: true

    field :viewer_refresh_token, mutation: Mutations::ViewerRefreshToken, terms_exempt: true

    field :viewer_sign_out, mutation: Mutations::ViewerSignOut, terms_exempt: true
  end
end
