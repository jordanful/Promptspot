class PromptVersion < ApplicationRecord
  belongs_to :prompt
  belongs_to :user
  validates :text, presence: true
  validates :version_number, presence: true
  before_create :generate_prompt_summary
  before_create :set_version_number

  private

  def set_version_number
    self.version_number = self.prompt.prompt_versions.count + 1
  end

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
    summary = response["choices"][0]["text"]
    self.prompt.update(title: summary)
  rescue StandardError => e
    puts "Error: #{e}"
  end

end
