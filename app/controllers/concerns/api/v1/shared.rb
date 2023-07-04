module API::V1::Shared
  def authorize_request
    api_key = request.headers['Authorization']
    @account = Account.joins(:api_keys).where(api_keys: { key: api_key }).first if api_key
    unless @account
      render json: { errors: 'Invalid or missing API key' }, status: :unauthorized
    end
  end

end