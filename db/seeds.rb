# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

model_provider = ModelProvider.find_or_create_by!(name: "OpenAI")

models_data = [
  { name: "gpt-3.5-turbo", description: "Most capable GPT-3.5 model.", enabled: true, model_type: "chat" },
  { name: "text-davinci-003", description: "Can do any language task. Soon to be deprecated.", enabled: true, model_type: "completion" },
  { name: "code-davinci-002", description: "Optimized for code-completion tasks.", enabled: false, model_type: "code" },
  { name: "gpt-4", description: "More capable than any GPT-3.5 model, and able to do more complex tasks at a higher cost.", enabled: true, model_type: "chat" },
  { name: "gpt-4-32k", description: "Same capabilities as the base gpt-4 model but with 4x the context length.", enabled: false, model_type: "chat" },
]

models_data.each do |model_data|
  model = Model.find_or_initialize_by(name: model_data[:name])
  model.update!(model_data.merge(model_provider: model_provider))
end

puts "✅ Created model providers and models"
