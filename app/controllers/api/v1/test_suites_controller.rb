class API::V1::TestSuitesController < ApplicationController
  include API::V1::Shared
  before_action :authorize_request

  def index
    test_suites = @account.test_suites
    respond_to do |format|
      format.json { render json: test_suites }
    end
  end

  def show
    test_suite = TestSuite.find(params[:id])
    respond_to do |format|
      format.json { render json: test_suite }
    end
  end

  def archive
    test_suite = TestSuite.find(params[:id])
    if test_suite.update(status: "archived")
      respond_to do |format|
        format.json { render json: test_suite }
      end
    else
      respond_to do |format|
        format.json { render json: test_suite.errors }
      end
    end
  end

  def unarchive
    test_suite = TestSuite.find(params[:id])
    if test_suite.update(status: "active")
      respond_to do |format|
        format.json { render json: test_suite }
      end
    else
      respond_to do |format|
        format.json { render json: test_suite.errors }
      end
    end
  end

end
