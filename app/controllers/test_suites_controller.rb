class TestSuitesController < ApplicationController
  before_action :set_test_suite, only: [:show, :edit, :update, :destroy, :archive, :unarchive]
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:show, :edit, :update, :destroy, :archive, :unarchive]

  def index
    @test_suites = @current_account.test_suites.where(archived: false)
  end

  def new
    @test_suite = @current_account.test_suites.new
    load_prompts_and_inputs_and_models
  end

  def create
    @test_suite = TestSuite.new
    @test_suite.user_id = current_user.id
    @test_suite.account_id = @current_account.id

    begin
      test_suite_params = test_suite_params()

      [:input_ids, :prompt_ids, :model_ids].each do |key|
        unless test_suite_params[key].present?
          load_prompts_and_inputs_and_models
          render :new, notice: "Please select prompts, inputs, and models."
          return
        end
        test_suite_params[key] = test_suite_params[key].first.split(',')
      end

      @test_suite.attributes = test_suite_params

      if @test_suite.save
        if params[:data_action] == 'run_now'
          @test_suite.run
          redirect_to test_suite_test_run_path(@test_suite.test_runs.last), notice: 'Test created and queued.'
        else
          redirect_to test_suites_path, notice: 'Test created.'
        end
      else
        load_prompts_and_inputs_and_models
        Rails.logger.info @test_suite.errors.inspect
        render :new, notice: @test_suite.errors.full_messages.join(', ')
      end
    rescue Exception => e
      Rails.logger.error e
      load_prompts_and_inputs_and_models
      flash.now[:alert] = "An error occurred while creating the test suite. Please try again."
      render :new
    end
  end

  def archive
    @test_suite.archived = true
    @test_suite.save
    redirect_to test_suites_path, notice: 'Test archived'
  end

  def unarchive
    @test_suite.archived = false
    @test_suite.save
    redirect_to test_suites_path, notice: 'Test unarchived'
  end

  def show
  end

  def edit
    load_prompts_and_inputs_and_models
  end

  def update
    test_suite_params[:input_ids] = test_suite_params[:input_ids].first.split(',')
    test_suite_params[:prompt_ids] = test_suite_params[:prompt_ids].first.split(',')
    test_suite_params[:model_ids] = test_suite_params[:model_ids].first.split(',')
    if @test_suite.update(test_suite_params)
      redirect_to @test_suite, notice: 'Test suite was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @test_suite.destroy
    redirect_to test_suites_url, notice: 'Test suite was successfully destroyed.'
  end

  private

  def authorize_user!
    if @current_account != TestSuite.find(params[:id]).account
      redirect_to root_path, notice: "Whoops. You do not have access to that test."
    end
  end

  def load_prompts_and_inputs_and_models
    @prompts = @current_account.prompts.active.order_by_recently_updated
    @inputs = @current_account.inputs
    @models = Model.all.where(enabled: true)
  end

  def set_test_suite
    @test_suite = TestSuite.find(params[:id])
  end

  def test_suite_params
    params.require(:test_suite).permit(:name, prompt_ids: [], input_ids: [], model_ids: [])
  end
end
