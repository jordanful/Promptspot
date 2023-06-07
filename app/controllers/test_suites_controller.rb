class TestSuitesController < ApplicationController
  before_action :set_test_suite, only: [:show, :edit, :update, :destroy]

  def index
    @test_suites = current_user.test_suites
  end

  def new
    @test_suite = current_user.test_suites.new
    load_prompts_and_user_prompts
  end

  def create
    @test_suite = current_user.test_suites.new(test_suite_params)

    if @test_suite.save
      redirect_to @test_suite, notice: 'Test suite was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
    load_prompts_and_user_prompts
  end

  def update
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

  def load_prompts_and_user_prompts
    @prompts = current_account.prompts
    @user_prompts = current_account.user_prompts
  end

  def set_test_suite
    @test_suite = current_user.test_suites.find(params[:id])
  end

  def test_suite_params
    params.require(:test_suite).permit(:name, prompt_ids: [], user_prompt_ids: [])
  end
end
