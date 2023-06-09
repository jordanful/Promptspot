class RunTestJob < ApplicationJob
  queue_as :default

  def perform(test_run_detail)
    test_run_detail.update!(status: 'running')
    output = prompt.current.generate(input)
    test_run_detail.update!(output: output, status: 'complete')
    test_run_detail.test_run.check_and_update_status
  rescue StandardError => e
    puts "Error: #{e}"
    test_run_detail.update!(status: 'error')
  end
end
