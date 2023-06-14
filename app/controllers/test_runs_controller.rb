class TestRunsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_test_run, except: [:create]
  before_action :authorize_user!

  def show
  end

  def create
    @test_suite = TestSuite.find(params[:test_suite_id])
    test_run = TestRun.create!(test_suite: @test_suite, status: 'queued')
    if test_run.save
      redirect_to test_suite_path(@test_suite), notice: '👍 Running'
    else
      redirect_to test_suite_path(@test_suite), notice: 'Test run failed to create.'
    end
  end

  def archive
    @test_run.archive
    redirect_to test_suite_path(@test_run.test_suite), notice: 'Archived'
  end

  def unarchive
    @test_run.unarchive
    redirect_to test_suite_path(@test_run.test_suite), notice: 'Unarchived'
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
