# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

model_provider = ModelProvider.find_or_create_by!(name: "OpenAI")

models_data = [
  { name: "gpt-3.5-turbo", enabled: true },
  { name: "text-davinci-003", enabled: true },
  { name: "code-davinci-002", enabled: true },
  { name: "gpt-4", enabled: false },
  { name: "gpt-4-32k", enabled: false },
]

models_data.each do |model_data|
  Model.find_or_create_by!(model_data.merge(model_provider: model_provider))
end

pp "✅ Created model providers and models"
