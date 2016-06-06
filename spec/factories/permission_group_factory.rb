FactoryGirl.define do

  factory :permission_group do
    title { Faker::Hipster.sentence }

    trait :coach do
      title "Coach"
      pinned_survey_group_titles ["test"]
    end

    trait :student do
      title "Student"
    end

    trait :with_users do
      transient do
        users_count 1
      end

      after(:create) do |pg, evaluator|
        create_list(:user, evaluator.users_count, permission_group: pg)
      end
    end

    factory :coach_permission_group, traits: [:coach]
    factory :student_permission_group, traits: [:student]
  end
end
