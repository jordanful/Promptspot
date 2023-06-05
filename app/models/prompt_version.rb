class PromptVersion < ApplicationRecord
  belongs_to :prompt
  belongs_to :user
  validates :text, presence: true
  before_create :generate_prompt_summary

  private

  def generate_prompt_summary
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_SECRET"])
    response = client.edits(
      parameters: {
        model: "text-davinci-edit-001",
        input: text,
        instruction: "Summarize the text in just a few words. The summary should be no more than 100 characters. It does not need to be a complete sentence. It will be used as a title for the prompt.",
      }
    )
    self.prompt.update(title: response.dig("choices", 0, "text"))
  rescue StandardError => e
    puts "Error: #{e}"
  end
end
