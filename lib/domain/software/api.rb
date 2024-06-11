#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require 'roo'
require 'ruby-progressbar'
require_relative 'model'

class InsightVMApi
  def fetch_microsoft_product_lifecycle(spreadsheet, tabsheet_name: 'lifecycle_data')
    xlsx = Roo::Excelx.new(spreadsheet)
    sheet = xlsx.sheet(tabsheet_name)
    headers = xlsx.row(7)
    p headers
    models = []
    total_rows = sheet.last_row - 7
    progress_bar = ProgressBar.create(
      title: "Processing #{spreadsheet}",
      total: total_rows,
      format: '%a %B %p%% %t'
    )
    xlsx.each_row_streaming(offset: 7) do |row|
      values = row.map(&:value)
      attributes = Hash[headers.zip(values)]
      models << MicrosoftProductLifecycle.new(attributes)

      progress_bar.increment
    end
    models
  end
end
