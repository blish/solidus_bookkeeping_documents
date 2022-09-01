# AlchemyCMS Dragonfly configuration.
#
# Consider using some kind of caching solution for image processing.
# For small projects, we have good experience with Rack::Cache.
#
# Larger installations should consider using a CDN, start reading
# http://markevans.github.io/dragonfly/cache/
#
# A complete reference can be found at
# http://markevans.github.io/dragonfly/configuration/
#

Dragonfly.app(:solidus_bookkeeping_documents).configure do
  dragonfly_url nil
  secret Rails.application.credentials.secret_key_base
  url_format "/bookkeeping_documents/:job/:name"

  datastore :file,
    root_path: Rails.root.join('uploads/bookkeeping_documents').to_s,
    store_meta: false
end

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware, :solidus_bookkeeping_documents
