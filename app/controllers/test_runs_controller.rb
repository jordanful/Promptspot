class TestRunsController < ApplicationController
  def show
    @test_run = TestRun.find(params[:id])
  end
end
