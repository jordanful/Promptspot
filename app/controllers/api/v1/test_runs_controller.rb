class API::V1::TestRunsController < ApplicationController
  include API::V1::Shared
  before_action :authorize_request

  def index
    test_runs = TestSuite.find(params[:test_suite_id]).test_runs
    respond_to do |format|
      format.json { render json: test_runs }
    end
  end

  def show
    test_run = TestRun.find(params[:id])
    respond_to do |format|
      format.json { render json: test_run } # Merge test_run_details into this
    end
  end

  def create
    test_suite = TestSuite.find(params[:test_suite_id])
    test_run = TestRun.create!(test_suite: test_suite, status: 'queued')
    if test_run.save
      respond_to do |format|
        format.json { render json: test_run }
      end
    else
      respond_to do |format|
        format.json { render json: test_run.errors }
      end
    end
  end

  def destroy
    test_run = TestRun.find(params[:id])
    if test_run.destroy
      respond_to do |format|
        format.json { render status: :ok, json: { message: 'Test run deleted' } }
      end
    else
      respond_to do |format|
        format.json { render json: test_run.errors }
      end
    end
  end

  def archive
    test_run = TestRun.find(params[:id])
    if test_run.update(status: "archived")
      respond_to do |format|
        format.json { render status: :ok, json: { message: 'Test run archived' } }
      end
    else
      respond_to do |format|
        format.json { render json: test_run.errors }
      end
    end
  end

  def unarchive
    test_run = TestRun.find(params[:id])
    if test_run.update(status: "active")
      respond_to do |format|
        format.json { render status: :ok, json: { message: 'Test run unarchived' } }
      end
    else
      respond_to do |format|
        format.json { render json: test_run.errors }
      end
    end
  end

end
