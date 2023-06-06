# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

model_provider = ModelProvider.find_or_create_by!(name: "OpenAI")

models_data = [
  { name: "gpt-3.5-turbo", description: "Most capable GPT-3.5 model. Optimized for chat.", enabled: true },
  { name: "text-davinci-003", description: "Can do any language task, including prompt completion.", enabled: true },
  { name: "code-davinci-002", description: "Optimized for code-completion tasks.", enabled: true },
  { name: "gpt-4", description: "More capable than any GPT-3.5 model, able to do more complex tasks, and optimized for chat.", enabled: false },
  { name: "gpt-4-32k", description: "Same capabilities as the base gpt-4 model but with 4x the context length.", enabled: false },
]

models_data.each do |model_data|
  Model.find_or_create_by!(model_data.merge(model_provider: model_provider)) unless Model.exists?(name: model_data[:name])
end

puts "✅ Created model providers and models"
