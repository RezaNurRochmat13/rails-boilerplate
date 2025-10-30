FactoryBot.define do
  factory :article do
    title { Faker::Movie.title }
    content { Faker::Lorem.word }
  end
end
