ApiPagination.configure do |config|
  config.total_header    = 'X-Total-Pages'
  config.per_page_header = 'X-Per-Page'
  config.page_header     = 'X-Page'
end
