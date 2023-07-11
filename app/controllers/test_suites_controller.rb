class TestSuitesController < ApplicationController
  before_action :set_test_suite, only: [:show, :edit, :update, :destroy, :archive, :unarchive, :authorize_user!]
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:show, :edit, :update, :destroy, :archive, :unarchive]

  def index
    @test_suites = @current_account.test_suites.where(archived: false)
  end

  def new
    @test_suite = @current_account.test_suites.new
    load_prompts_and_contexts_and_models
  end

  def create
    @test_suite = TestSuite.new
    @test_suite.user_id = current_user.id
    @test_suite.account_id = @current_account.id

    begin
      test_suite_params = test_suite_params()
      [:context_ids, :prompt_ids, :model_ids].each do |key|
        unless test_suite_params[key].present?
          load_prompts_and_contexts_and_models
          render :new, alert: "Please select prompts, contexts, and models."
          return
        end
      end

      @test_suite.transaction do
        @test_suite.name = test_suite_params[:name]
        @test_suite.context_ids = test_suite_params[:context_ids]
        @test_suite.prompt_ids = test_suite_params[:prompt_ids]
        @test_suite.model_ids = test_suite_params[:model_ids]
        @test_suite.mode = test_suite_params[:mode]
        @test_suite.save! # This will raise an exception if validations fail
      end

      if test_suite_params[:run_now] == 'true'
        @test_suite.run
        redirect_to test_suite_path(@test_suite), notice: 'Test created and queued.'
      else
        redirect_to test_suites_path, notice: 'Test created.'
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error e
      load_prompts_and_contexts_and_models
      flash.now[:alert] = @test_suite.errors.full_messages.to_sentence
      render :new
    end
  end

  def clone
    @test_suite = TestSuite.find(params[:id])
    @test_suite = @test_suite.clone
    load_prompts_and_contexts_and_models
    render :new
  end

  def archive
    @test_suite.archive
    respond_to do |format|
      format.html { redirect_to test_suites_path, notice: 'Archived' }
    end
  rescue StandardError => e
    Rails.logger.error e
    redirect_to test_suites_path, notice: 'An error occurred while archiving this test. Our team has been notified.'
  end

  def unarchive
    @test_suite.unarchive
    redirect_to test_suites_path, notice: 'Unarchived'
  rescue StandardError => e
    Rails.logger.error e
    redirect_to test_suites_path, notice: 'An error occurred while unarchiving this test. Our team has been notified.'
  end

  def show
  end

  def edit
    load_prompts_and_contexts_and_models
  end

  def update
    begin
      [:context_ids, :prompt_ids, :model_ids].each do |key|
        unless test_suite_params[key].present?
          load_prompts_and_contexts_and_models
          redirect_to edit_test_suite_path(@test_suite), notice: "Please select prompts, contexts, and models."
          return
        end
      end

      @test_suite.transaction do
        @test_suite.update!(name: test_suite_params[:name])
        @test_suite.context_ids = test_suite_params.require(:context_ids)
        @test_suite.prompt_ids = test_suite_params.require(:prompt_ids)
        @test_suite.model_ids = test_suite_params.require(:model_ids)
      end

      if test_suite_params[:run_now] == 'true'
        @test_suite.run
        redirect_to test_suite_path(@test_suite), notice: 'Test updated and queued.'
      else
        redirect_to test_suites_path, notice: 'Test updated.'
      end
    rescue StandardError => e
      Rails.logger.error e
      load_prompts_and_contexts_and_models
      redirect_to edit_test_suite_path(@test_suite), notice: "An error occurred while updating this test. Our team has been notified."
    end
  end

  def destroy
    @test_suite.destroy
    redirect_to test_suites_url, notice: 'Test suite was successfully destroyed.'
  end

  private

  def authorize_user!
    if @current_account.id != @test_suite.account_id
      redirect_to root_path, notice: "Whoops. You do not have access to that test."
    end
  end

  def load_prompts_and_contexts_and_models
    @prompts = @current_account.prompts.active.order_by_recently_updated
    @contexts = @current_account.contexts
    @models = Model.all.where(enabled: true)
  end

  def set_test_suite
    @test_suite = TestSuite.find(params[:id])
  end

  def test_suite_params
    params.require(:test_suite).permit(:name, :mode, :run_now, prompt_ids: [], context_ids: [], model_ids: [])
  end
end
