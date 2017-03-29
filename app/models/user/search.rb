module User::Search
  extend Cognituz::Search

  filter :teaches_online
  filter :teaches_at_own_place
  filter :teaches_at_students_place
  filter :teaches_at_public_place

  filter :is_teacher do |query, params|
    next query unless params.key?(:is_teacher)
    bool = params.fetch(:is_teacher)
    sql = %Q|"users"."roles" @> ARRAY['teacher']|
    bool ? query.where(sql) : query.where.not(sql)
  end

  filter :neighborhoods do |query, params|
    neighborhoods = params[:neighborhoods]
    next query unless neighborhoods && neighborhoods.any?
    array_intersects query, :neighborhoods, neighborhoods
  end

  filter :taught_subjects do |query, params|
    taught_subjects = params[:taught_subjects]
    next query unless taught_subjects.present? && taught_subjects.any?

    query.joins(:taught_subjects).distinct.where.has do |u|
      taught_subjects.inject(nil) do |memo, ts|
        ts           = ts.with_indifferent_access
        target_name  = ts.fetch(:name)
        target_level = ts.fetch(:level).presence

        fragment =
          (
            (u.taught_subjects.name == target_name) &
            (u.taught_subjects.level == target_level)
          )

        memo ? memo | fragment : fragment
      end
    end
  end

  def self.array_intersects(query, field, values)
    array_str = values.map { |n| "'#{n}'" }.join(', ')
    query.where %Q|"users"."#{field}" && ARRAY[#{array_str}]|
  end
end
