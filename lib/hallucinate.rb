require "hallucinate/version"
require "hallucinate/configuration"
require "hallucinate/hallucinator"
require "hallucinate/ai_response_generator"

module Hallucinate
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
