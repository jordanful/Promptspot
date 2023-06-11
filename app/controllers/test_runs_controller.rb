class TestRunsController < ApplicationController
  def show
    @test_run = TestRun.find(params[:id])
  end

  def create
    @test_suite = TestSuite.find(params[:test_suite_id])
    test_run = TestRun.create!(test_suite: @test_suite, status: 'queued')
    if test_run.save
      redirect_to test_suite_test_run_path(@test_suite, test_run)
    else
      redirect_to test_suite_path(@test_suite), notice: 'Test run failed to create.'
    end
  end
end
