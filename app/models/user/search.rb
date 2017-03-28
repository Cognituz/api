module User::Search
  extend Cognituz::Search

  filter :teaches_online
  filter :teaches_at_own_place
  filter :teaches_at_students_place
  filter :teaches_at_public_place

  filter :taught_subjects do |query, params|
    taught_subjects = params[:taught_subjects]
    next query unless taught_subjects.present? && taught_subjects.any?

    query.joins(:taught_subjects).distinct.where.has do |u|
      taught_subjects.inject(nil) do |memo, ts|
        ts           = ts.with_indifferent_access
        target_name  = ts.fetch(:name)
        target_level = ts.fetch(:level)

        fragment =
          (
            (u.taught_subjects.name == target_name) &
            (u.taught_subjects.level == target_level)
          )

        memo ? memo | fragment : fragment
      end
    end
  end
end
