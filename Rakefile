require "bundler"
Bundler::GemHelper.install_tasks

require "solidus_dev_support/rake_tasks"
SolidusDevSupport::RakeTasks.install

task default: "extension:specs"
