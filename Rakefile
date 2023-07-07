require "solidus_dev_support/rake_tasks"
SolidusDevSupport::RakeTasks.install

task default: "extension:specs"

require "blish/support/tasks"

Blish::Support::Tasks.new(
  gem_name: "solidus_bookkeeping_documents"
)
