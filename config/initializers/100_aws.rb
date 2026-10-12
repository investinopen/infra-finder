# frozen_string_literal: true

# aws-sdk-s3 >= 1.178 sends CRC32 checksums by default, and we're unsure whether
# DO Spaces will accept them. These settings keep the < 1.178 aws-sdk-s3 behavior.
Aws.config.update(
  request_checksum_calculation: "when_required",
  response_checksum_validation: "when_required"
)
