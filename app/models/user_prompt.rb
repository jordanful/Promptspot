class UserPrompt < ApplicationRecord
  belongs_to :user
  belongs_to :account
  validates :text, presence: true
  before_create :generate_prompt_summary

  private

  def generate_prompt_summary
    summary = Rails.application.config.title_system_prompt + '"""' + text + '"""'
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_SECRET"])
    response = client.completions(
      parameters: {
        model: Rails.application.config.title_system_prompt_model,
        prompt: summary,
        max_tokens: 15
      }
    )
    self.title = response["choices"][0]["text"]
  rescue StandardError => e
    puts "Error: #{e}"
  end
end
