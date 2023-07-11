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
    system_message = test_run_detail.prompt_version.text
    user_message = test_run_detail.context.text
    full_prompt = "#{system_message}/n/n#{user_message}"
    org = test_run_detail.test_run.test_suite.account.organization
    client = OpenAI::Client.new(access_token: org.openai_api_key)
    case test_run_detail.model.model_type
    when 'completion'
      response = client.completions(
        parameters: {
          model: test_run_detail.model.name,
          prompt: full_prompt,
          max_tokens: Rails.application.config.max_tokens
        }
      )
      response["choices"][0]["text"]
    when 'chat'
      response = client.chat(
        parameters: {
          model: test_run_detail.model.name,
          messages: [
            {
              "role": "system",
              "content": system_message
            },
            {
              "role": "user",
              "content": user_message
            }
          ]
        })
      response["choices"][0]["message"]["content"]
    end
  end

end
