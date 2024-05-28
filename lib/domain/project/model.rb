# frozen_string_literal: true

require_relative '../model'

class Project < Domain::Model
  attr_accessor :id, :name, :description, :org, :tracking_methods, :groups

  def initialize(attributes = {})
    remapped_attributes = attributes.transform_keys do |key|
      case key
      when 'project_id' then 'id'
      when 'project_name' then 'name'
      when 'project_description' then 'description'
      when 'project_org' then 'org'
      when 'project_groups' then 'groups'
      else key # For all other keys that do not need remapping
      end
    end
    super(remapped_attributes) # Call the superclass's initialize method
  end

  def self.url_path
    '/projects'
  end
end

class ProjectReport < Domain::Model
  attr_accessor :id, :project_id, :name, :description, :created_on,
                :created_by_first_name, :created_by_last_name, :file_name, :status

  def initialize(attributes = {})
    remapped_attributes = attributes.transform_keys do |key|
      case key
      when 'report_id' then 'id'
      when 'report_name' then 'name'
      when 'report_description' then 'description'
      when 'report_filename' then 'file_name'
      when 'report_status' then 'status'
      when 'created_date' then 'created_on'
      when 'created_user_firstname' then 'created_by_first_name'
      when 'created_user_lastname' then 'created_by_last_name'
      else key # For all other keys that do not need remapping
      end
    end
    super(remapped_attributes) # Call the superclass's initialize method
  end

  def self.primary_key
    %w[id project_id]
  end

  def self.url_path(id)
    "/projects/#{id}/reports"
  end
end

class ProjectReportDetail < Domain::Model
  attr_accessor :report_id, :row_id,
                :scan_type,
                :asset_name,
                :asset_owner,
                :ip,
                :last_seen,
                :operating_system,
                :finding_discovered,
                :age,
                :plugin_number,
                :name,
                :description,
                :severity,
                :exploit_available,
                :status,
                :request_method,
                :parameter,
                :service,
                :port,
                :path,
                :due_date,
                :iava,
                :cve_or_cwe,
                :cvss_score,
                :cvss_temporal,
                :refs,
                :impact,
                :solution,
                :mitigated,
                :user_comments,
                :owasp,
                :wasc,
                :payload,
                :payload2,
                :payload3,
                :payload4,
                :payload5

  def table_name
    'project_report_detail'
  end

  def self.primary_key
    %w[report_id row_id]
  end

  def initialize(attributes = {})
    remapped_attributes = attributes.transform_keys do |key|
      case key
      when 'Scan Type' then 'scan_type'
      when 'Asset Name' then 'asset_name'
      when 'Asset Owner' then 'asset_owner'
      when 'IP' then 'ip'
      when 'Last Seen' then 'last_seen'
      when 'Operating System' then 'operating_system'
      when 'Finding Discovered' then 'finding_discovered'
      when 'Age' then 'age'
      when 'Plugin Number' then 'plugin_number'
      when 'Name' then 'name'
      when 'Description' then 'description'
      when 'Severity' then 'severity'
      when 'Exploit Available' then 'exploit_available'
      when 'Status' then 'status'
      when 'Request Method' then 'request_method'
      when 'Parameter' then 'parameter'
      when 'Service' then 'service'
      when 'Port' then 'port'
      when 'Path' then 'path'
      when 'Due Date' then 'due_date'
      when 'IAVA' then 'iava'
      when 'CVE/CWE' then 'cve_or_cwe'
      when 'CVSS Score' then 'cvss_score'
      when 'CVSS Temporal' then 'cvss_temporal'
      when 'References' then 'refs'
      when 'Impact' then 'impact'
      when 'Solution' then 'solution'
      when 'Mitigated' then 'mitigated'
      when 'User Comments' then 'user_comments'
      when 'OWASP' then 'owasp'
      when 'WASC' then 'wasc'
      when 'Payload' then 'payload'
      when 'Payload2' then 'payload2'
      when 'Payload3' then 'payload3'
      when 'Payload4' then 'payload4'
      when 'Payload5' then 'payload5'
      else key # For all other keys that do not need remapping
      end
    end
    super(remapped_attributes) # Call the superclass's initialize method
  end
end
