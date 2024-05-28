# frozen_string_literal: true

require 'csv'

class Db
  def save_project_report_details(details = [])
    details.each do |detail|
      puts detail.to_json
      upsert(detail)
    end
  end
end
