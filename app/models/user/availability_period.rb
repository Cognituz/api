# Remember the attribute week day is here merely for display purposes
# The source of truth are starts_at_sfsow and ends_at_sfsow.
# sfsow stands for "seconds from start of week", given the starting day is sunday
class User::AvailabilityPeriod < ApplicationRecord
  belongs_to :user, inverse_of: :availability_periods
  validates :starts_at_sfsow, :ends_at_sfsow, :user, presence: true

  scope :containing, -> (date_range) do
    start_sfsow = Cognituz::SFSOW.for_date(date_range.first)
    end_sfsow   = Cognituz::SFSOW.for_date(date_range.last)

    where.has do
      (starts_at_sfsow <= start_sfsow) &
      (ends_at_sfsow >= end_sfsow)
    end
  end

  scope :contained_within, ->(date_range) do
    start_sfsow = Cognituz::SFSOW.for_date date_range.first
    end_sfsow   = Cognituz::SFSOW.for_date date_range.last

    where.has do
      (starts_at_sfsow >= start_sfsow) &
      (ends_at_sfsow <= end_sfsow)
    end
  end
end
