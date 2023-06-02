json.extract! prompt, :id, :status, :latest_prompt_text_id, :account_id, :created_at, :updated_at
json.url prompt_url(prompt, format: :json)
