# frozen_string_literal: true

Dir.glob(File.join(__dir__, '**', 'api.rb')).each do |file|
  require_relative file
end
