class RunTestJob < ApplicationJob
  queue_as :default

  def perform(test_run_detail)
    test_run_detail.update!(status: 'running')
    organization = test_run_detail.test_run.test_suite.account.organization
    output = test_run_detail.prompt_version.generate(test_run_detail.input, test_run_detail.model, organization)
    test_run_detail.update!(output: output, status: 'complete')
    test_run_detail.test_run.check_and_update_status
  rescue StandardError => e
    puts "Error: #{e}"
    test_run_detail.update!(status: 'error')
  end
end
