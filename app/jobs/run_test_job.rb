class RunTestJob < ApplicationJob
  queue_as :default

  def perform(test_run_detail)
    test_run_detail.update!(status: 'running')
    output = generate(test_run_detail)
    test_run_detail.update!(output: output, status: 'complete')
    test_run_detail.test_run.check_and_update_status
  rescue StandardError => e
    puts "Error: #{e}"
    test_run_detail.update!(status: 'error')
    test_run_detail.test_run.check_and_update_status
  end

  private

  def generate(test_run_detail)
    full_prompt = "#{test_run_detail.prompt_version.text}/n/n#{test_run_detail.input.text}"
    org = test_run_detail.test_run.test_suite.account.organization
    client = OpenAI::Client.new(access_token: org.openai_api_key)
    response = client.completions(
      parameters: {
        model: test_run_detail.model.name,
        prompt: full_prompt,
        max_tokens: Rails.application.config.max_tokens
      }
    )
    response["choices"][0]["text"]
  end

end
