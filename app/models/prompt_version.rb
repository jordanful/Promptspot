class PromptVersion < ApplicationRecord
  belongs_to :prompt
  belongs_to :user
  validates :text, presence: true
  before_create :generate_prompt_summary

  private

  def generate_prompt_summary
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_SECRET"])
    response = client.completions(
      parameters: {
        model: Rails.configuration.title_system_prompt_model,
        prompt: text + Rails.configuration.title_system_prompt,
        max_tokens: 15

      }
    )
    summary = response["choices"][0]["text"]
    self.prompt.update(title: summary)
  rescue StandardError => e
    puts "Error: #{e}"
  end
end
