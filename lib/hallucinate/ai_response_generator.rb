require "net/http"
require "uri"
require "json"

module Hallucinate
  class AIResponseGenerator
    class MissingApiKeyError < StandardError; end

    OPENAI_URL = "https://api.openai.com/v1/chat/completions"

    def generate_response(class_name, method_name, *args, **kargs)
      api_key = begin
        Hallucinate.configuration.api_key
      rescue NoMethodError
        raise MissingApiKeyError
      end

      uri = URI(OPENAI_URL)
      request = Net::HTTP::Post.new(uri)
      request["Authorization"] = "Bearer #{api_key}"
      request.content_type = "application/json"
      request.body = JSON.dump({
        model: "gpt-3.5-turbo",
        messages: [
          {
            role: :user,
            content: "Write a method named #{method_name} that would match a class #{class_name} context, knowing the value of these arguments: #{args} and #{kargs}, and returns a result you imagine is the most appropriate. Please provide only the method's return output. I really don't want you to be verbose. ONLY respond with the returned result."
          }
        ],
        max_tokens: 150
      })

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end

      JSON.parse(response.body).fetch("choices").first.dig("message", "content")
    end
  end
end
