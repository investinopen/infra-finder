# frozen_string_literal: true

RSpec::Matchers::BaseDelegator.undef_method :with

RSpec::Matchers.define :be_a_monadic_success do
  match do |actual|
    if actual.success? && instance_variable_defined?(:@expected_value)
      values_match? @expected_value, actual.value!
    else
      actual.success?
    end
  end

  chain :with do |value|
    @expected_value = value
  end

  description do
    "be a monadic success".then do |desc|
      if instance_variable_defined?(:@expected_value)
        "#{desc}, with a value matching #{@expected_value.inspect}"
      else
        desc
      end
    end
  end

  failure_message do |actual|
    if !actual.kind_of?(Dry::Monads::Result)
      "expected that #{actual.inspect} would be a monadic result"
    elsif actual.success? && instance_variable_defined?(:@expected_value)
      "expected that the successful result (#{actual.value!.inspect}) would match #{@expected_value.inspect}"
    else
      "expected that the result would be a success: #{actual.inspect}"
    end
  end
end

RSpec::Matchers.alias_matcher :succeed, :be_a_monadic_success

RSpec::Matchers.define :be_a_monadic_failure do
  match do |actual|
    if actual.failure?
      if instance_variable_defined?(:@key)
        @actual = Array(actual.failure).first

        values_match? @key, @actual
      elsif instance_variable_defined?(:@value)
        @actual = actual.failure

        values_match? @value, @actual
      elsif instance_variable_defined?(:@validation_reason)

        if actual.failure.kind_of?(Dry::Monads::List)
          @actual = actual.failure

          @validation_reason.in? @actual.to_a
        else
          false
        end
      else
        true
      end
    else
      false
    end
  end

  chain :with_key do |key|
    @key = key
  end

  chain :with do |value|
    @value = value
  end

  chain :with_validation_reason do |reason|
    @validation_reason = reason
  end

  diffable
end

RSpec::Matchers.alias_matcher :monad_fail, :be_a_monadic_failure
