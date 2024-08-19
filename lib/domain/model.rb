# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

class Domain
  class Model
    def initialize(attributes = {})
      attributes.each do |k, v|
        key = "#{k}="
        send(key, v) if respond_to?(key)
      end
    end

    # Convert instance attributes to a hash
    def to_hash
      self.class.columns.each_with_object({}) do |attr, hash|
        hash[attr] = send(attr.to_sym)
      end
    end

    def to_csv
      self.class.columns
          .map { |column| send(column.to_sym) }
    end

    def self.primary_key
      ['id']
    end

    # Ensure the columns method retrieves only valid attribute names
    def self.columns
      instance_methods.select { |m| m.to_s.end_with?('=') }
                      .map { |setter| setter.to_s.chomp('=') }
                      .select { |attr| instance_methods.include?(attr.to_sym) && !Object.instance_methods.include?(attr.to_sym) }
                      .sort
    end

    def self.headers
      columns.join ','
    end

    def self.table_name
      name.underscore
    end

    def self.view
      "#{table_name}_view"
    end

    def self.from_json(data)
      transformed_data = data.transform_keys do |key|
        key.to_s.underscore.to_sym
      end
      new(transformed_data)
    end

    def self.from_csv(row)
      from_json(row.to_h)
    end

    def to_s
      self.class.columns.map { |attr| send(attr) }.join(',')
    end
  end
end
