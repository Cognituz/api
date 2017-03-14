module User::Search
  extend Cognituz::Search

  filter :teaches_online
  filter :teaches_at_own_place
  filter :teaches_at_students_place
  filter :teaches_at_public_place

  filter :taught_subjects do |query, params|
    next query unless params.key?(:taught_subjects)

    binding.pry

    taught_subjects = params.fetch(:taught_subjects)

    taught_subjects.inject(query.joins(:taught_subjects)) do |q, ts|
      ts_subquery =
        User::TaughtSubject
          .where(%Q`"#{User::TaughtSubject.table_name}"."user_id" = "users"."id"`)
          .where(level: ts.fetch(:level), name: ts.fetch(:name))


      q.where(
        <<-SQL
          EXISTS (#{}
        SQL
      )
    end
  end
end
