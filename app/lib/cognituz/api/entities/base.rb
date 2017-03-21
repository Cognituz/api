require 'uri'

class Cognituz::API::Entities::Base < Grape::Entity
  format_with(:attachment) do |a|
    return unless a.url.present?
    URI.join(ActionController::Base.asset_host, a.url).to_s
  end
end
