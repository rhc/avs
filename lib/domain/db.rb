# frozen_string_literal: true

Dir.glob(File.join(__dir__, '**', 'db.rb')).each do |file|
  require_relative file
end

require_relative 'asset/db'
require_relative 'vulnerability/db'
