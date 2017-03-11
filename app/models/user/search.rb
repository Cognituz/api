module User::Search
  extend Cognituz::Search

  filter :teaches_online
  filter :teaches_at_own_place
  filter :teaches_at_students_place
  filter :teaches_at_public_place
end
