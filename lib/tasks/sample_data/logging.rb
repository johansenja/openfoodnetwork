# frozen_string_literal: true

module Logging
  private

  def log(message)
    @logger ||= ActiveSupport::TaggedLogging.new(Logger.new($stdout))
    @logger.tagged("ofn:sample_data") { @logger.info(message) }
  end
end
