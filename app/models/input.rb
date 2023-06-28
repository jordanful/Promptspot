class Input < ApplicationRecord
  belongs_to :user
  belongs_to :account
  has_many :inputs
  has_many :test_suites, through: :test_suite_inputs
  validates :text, presence: true
  before_create :generate_prompt_summary

  def tests
    TestSuite.joins(test_suite_inputs: :input)
             .where(test_suite_inputs: { input_id: id }, archived: false)
             .distinct
  end

  private

  def generate_prompt_summary
    summary = Rails.application.config.title_system_prompt + '"""' + text + '"""'
    # Use the organization's OpenAI API key if it exists, otherwise use the environment variable
    client = OpenAI::Client.new(access_token: account.organization&.openai_api_key.presence || ENV["OPENAI_API_SECRET"])
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
