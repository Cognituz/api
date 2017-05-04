module Cognituz::SFSOW
  def self.for_date(date)
    d = date.to_time.utc

    from_metadata(
      wday:   d.wday,
      hour:   d.hour,
      min:    d.min,
      offset: d.utc_offset
    )
  end

  private

  def self.from_metadata(
    offset: Time.zone.utc_offset,
    wday:, hour:, min: 0
  )
    wday.days + hour.hours + min.minutes - offset
  end
end
