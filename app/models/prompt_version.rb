class PromptVersion < ApplicationRecord
  belongs_to :prompt
  belongs_to :user
  validates :text, presence: true
  validates :version_number, presence: true
  before_create :generate_prompt_title
  before_create :set_version_number
  attr_accessor :save_input

  def prompt_title
    self.prompt.title
  end

  def truncated_prompt_title
    self.prompt.title.truncate(50)
  end

  def generate(input, model, organization)
    full_prompt = "#{text}/n/n#{input.text}"
    client = OpenAI::Client.new(access_token: organization.openai_api_key)
    response = client.completions(
      parameters: {
        model: model.name,
        prompt: full_prompt,
        max_tokens: Rails.application.config.max_tokens,
        user: user.id
      }
    )
    response["choices"][0]["text"]
  rescue StandardError => e
    puts "Error: #{e}"
  end

  private

  def set_version_number
    self.version_number = self.prompt.prompt_versions.count + 1
  end

  def generate_prompt_title
    return unless version_number == 1 # Only autogenerate a title for the first version of the prompt
    return if self.prompt.title.present? # Don't autogenerate a title if the user has already set one
    ActiveRecord::Base.transaction do
      summary = "#{Rails.application.config.title_system_prompt}\"\"\"#{text}\"\"\""
      # Use the organization's OpenAI API key if it exists, otherwise use the environment variable
      client = OpenAI::Client.new(access_token: user.accounts.first.organization&.openai_api_key.presence || ENV["OPENAI_API_SECRET"])
      response = client.completions(
        parameters: {
          model: Rails.application.config.title_system_prompt_model,
          prompt: summary,
          max_tokens: 15
        }
      )
      summary = response["choices"][0]["text"]
      self.prompt.update(title: summary)
    end
  rescue StandardError => e
    puts "Error: #{e}"
  end

end
