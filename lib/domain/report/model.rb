# frozen_string_literal: true

require_relative '../model'

class Report < Domain::Model
  attr_accessor :id,
                :name,
                :baseline,
                :bureau,
                :component,
                :email, # ReportEmail
                :enclave,
                :filters, # ReportConfigFiltersResource
                :format,
                :frequency, # ReportFrequency
                :language,
                :organization,
                :owner,
                :policies,
                :policy,
                :query,
                :range,
                :remediations,
                :riskTrend,
                :scope,
                :storage,
                :template,
                :timezone,
                :users,
                :version
end
