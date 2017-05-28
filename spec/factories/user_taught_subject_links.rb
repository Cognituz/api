FactoryGirl.define do
  factory :user_taught_subject_link, class: 'User::TaughtSubjectLink' do
    study_subject nil
    user nil
  end
end
