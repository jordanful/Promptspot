json.extract! prompt, :id, :title, :created_at, :updated_at
json.text prompt.current.text
json.url prompt_url(prompt, format: :json)
