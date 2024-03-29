# frozen_string_literal: true

class Site
  attr_accessor :id, :name, :description, :risk_score, :scan_engine, :scan_template

  def initialize(id:, name:, description:, risk_score:, scan_engine:, scan_template:)
    @id = id
    @name = name
    @description = description
    @risk_score = risk_score
    @scan_engine = scan_engine
    @scan_template = scan_template
  end

  # data json comes from the API sites/get
  def self.from_json(data)
    Site.new(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      risk_score: data['risk_score'],
      scan_engine: data['scanEngine'],
      scan_template: data['scanTemplate']
    )
  end

  def to_s
    [id, name, scan_engine, scan_template].join ','
  end

  # returns true if the site ends with _UTR followed by 5 digits
  def utr?
    # Define the regular expression pattern
    utr_pattern = /:UTR\d{5}$/

    # Check if the site ends with "_UTR" followed by one or more digits
    !!(name =~ utr_pattern)
  end
end

class CmdbSite
  attr_accessor :name, :country_code, :business_unit, :sub_area, :application, :utr

  def initialize(name:, country_code:, business_unit:, sub_area:, application:, utr:)
    @name = name
    @country_code = country_code
    @business_unit = business_unit
    @sub_area = sub_area
    @application = application
    @utr = utr
  end

  def self.from_csv(row)
    CmdbSite.new(
      name: row[:site],
      country_code: row[:country_code],
      business_unit: row[:business_unit],
      sub_area: row[:sub_area],
      application: row[:application],
      utr: row[:utr]
    )
  end

  def to_s
    [name, country_code, business_unit, sub_area, application, utr].join ','
  end
end
