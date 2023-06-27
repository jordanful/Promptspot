class TestRunsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_test_run, except: [:create]
  before_action :authorize_user!

  def show
    @prompt_versions = @test_run.test_run_details.map(&:prompt_version).uniq
    @inputs = @test_run.test_run_details.map(&:input).uniq
  end

  def create
    @test_suite = TestSuite.find(params[:test_suite_id])
    if @current_organization.openai_api_key.blank?
      flash[:error] = "Please set your OpenAI API key before running the test."
      redirect_to test_suite_path(@test_suite) and return
    end
    test_run = TestRun.create!(test_suite: @test_suite, status: 'queued')
    if test_run.save
      redirect_to test_suite_path(@test_suite)
    else
      redirect_to test_suite_path(@test_suite), notice: 'Test run failed to create.'
    end
  end

  def destroy
    begin
      @test_run.destroy!
      redirect_to test_suite_path(@test_run.test_suite), notice: 'Deleted.'
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error e
      redirect_to test_suite_path(@test_run.test_suite), alert: 'Failed to delete the test run.'
    end
  end

  def download
    send_data @test_run.to_csv, filename: "promtspot_#{@test_run.test_suite.name.parameterize(separator: '_')}_run_#{params[:id]}.csv"
  end

  def archive
    begin
      @test_run.archive
      redirect_to test_suite_path(@test_run.test_suite), notice: '🗃️Archived'
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error e
      redirect_to test_suite_path(@test_run.test_suite), alert: 'Failed to archive the test run.'
    end
  end

  def unarchive
    begin
      @test_run.unarchive
      redirect_to test_suite_path(@test_run.test_suite), notice: '🗃️Unarchived'
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error e
      redirect_to test_suite_path(@test_run.test_suite), alert: 'Failed to unarchive the test run.'
    end
  end

  private

  def authorize_user!
    @test_suite = TestSuite.find(params[:test_suite_id])
    unless @current_account.id == @test_suite.account_id
      redirect_to root_path, notice: 'You are not authorized to view that page.'
    end
  end

  def set_test_run
    @test_run = TestRun.find(params[:id])
  end
end
