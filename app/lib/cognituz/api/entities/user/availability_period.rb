class Cognituz::API::Entities::User::AvailabilityPeriod <  Cognituz::API::Entities::Base
  SUNDAY = Time.new(2017, 03, 26, 0, 0, 0 ,0) # Any sunday will do

  expose :id, :starts_at_sfsow, :ends_at_sfsow,
    :starts_at, :ends_at, :week_day

  private

  def starts_at
    SUNDAY.advance seconds: object.starts_at_sfsow
  end

  def ends_at
    SUNDAY.advance seconds: object.ends_at_sfsow
  end
end
