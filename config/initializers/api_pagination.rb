ApiPagination.configure do |config|
  config.total_header    = 'X-Total-Records'
  config.per_page_header = 'X-Records-Per-Page'
  config.page_header     = 'X-Page'
end
