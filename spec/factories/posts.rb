# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    digest "I am a new post"
    title "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Expedita
           vitae quibusdam voluptas incidunt maiores autem unde tenetur maxime,
           commodi, mollitia atque error officia asperiores eligendi deserunt
           repellat ex veniam quaerat."
  end
end
