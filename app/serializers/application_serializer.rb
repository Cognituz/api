class ApplicationSerializer < ActiveModel::Serializer
  def self.decorate_attachment(attr_name)
    define_method attr_name do
      url = object.send(attr_name).url
      return unless url.present?
      require 'uri'
      URI.join(ActionController::Base.asset_host, url).to_s
    end
  end
end
