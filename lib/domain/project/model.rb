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

  def self.primary_key
    'id'
  end
end

class ProjectReport < Domain::Model
  attr_accessor :id, :name, :description, :created_on,
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

  def self.url_path(id)
    "/projects/#{id}/reports"
  end

  def self.primary_key
    'id'
  end
end
