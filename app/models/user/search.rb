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

  filter :taught_subject_ids do |query, params|
    taught_subject_ids = params[:taught_subject_ids]
    next query unless taught_subject_ids.present? && taught_subject_ids.any?

    query
      .joins(:taught_subject_links)
      .where(user_taught_subject_links: {
        study_subject_id: taught_subject_ids
      })
  end


  def self.array_intersects(query, field, values)
    array_str = values.map { |n| "'#{n}'" }.join(', ')
    query.where %Q|"users"."#{field}" && ARRAY[#{array_str}]|
  end
end
