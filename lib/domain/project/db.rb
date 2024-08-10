# frozen_string_literal: true

require 'csv'

class Db
  def save_project_report_details(details = [])
    bulk_copy(details)
  end

  def save_project_report_findings(details = [])
    bulk_upsert(details)
  end
end
