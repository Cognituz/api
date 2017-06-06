module User::Scopes
  extend ActiveSupport::Concern

  included do
    scope :search_by_availability, -> (date_range) do
      subquery =
        available_at(date_range).select_with_priority(1).
        union_all(available_around(date_range).select_with_priority(2)).
        union_all(partially_available_at(date_range).select_with_priority(3)).
        select(%Q|DISTINCT ON ("#{table_name}"."id") "#{table_name}"."id", "#{table_name}"."priority"|)

      with_no_appointments_at(date_range).
      joins(
        <<-SQL
          INNER JOIN (#{subquery.to_sql})
          AS teachers_subset
          ON teachers_subset."id" = "#{table_name}"."id"
        SQL
      ).order("teachers_subset.priority")

    end

    private

    scope :with_no_appointments_at, ->(date_range) do
      subquery =
        left_joins(:appointments_as_teacher)
        .merge(
          ClassAppointment.not_overlapping(date_range).
          or(ClassAppointment.where(id: nil))
        )

      where id: subquery
    end

    scope :partially_available_at, ->(date_range) do
      joins(:availability_periods)
        .merge(User::AvailabilityPeriod.contained_within(date_range))
    end

    scope :available_at, -> (date_range) do
      joins(:availability_periods)
      .merge(User::AvailabilityPeriod.containing(date_range))
    end

    scope :available_around, ->(date_range) do
      start_time = date_range.first
      end_time   = date_range.last

      available_at(start_time.+(1.hour)..start_time)
      .or(available_at(end_time..end_time.+(1.hour)))
      .distinct
    end

    scope :select_with_priority, -> (priority) do
      select(%Q("#{table_name}".*), "#{priority.to_i} AS priority")
    end
  end
end
