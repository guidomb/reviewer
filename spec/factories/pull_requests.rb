# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pull_request do
    sequence(:number)  { |n| n }
    title { "Pull request for feature number #{number}" }
    state "open"
    repository "guidomb/reviewer"
    sender "guidomb"
    url { "https://github.com/#{repository}/pulls/#{number}" }
  end
end
