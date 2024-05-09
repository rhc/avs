# frozen_string_literal: true

class Domain
  class Model
    def initialize(attributes = {})
      attributes.each do |k, v|
        key = "#{k}="
        send(key, v) if respond_to?(key)
      end
    end

    def to_csv
      self.class.columns
          .map { |column| send(column.to_sym) }
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
      name.downcase
    end

    def self.from_json(data)
      new(data.transform_keys(&:to_sym)) # Transform keys from string to symbols if necessary
    end

    def to_s
      self.class.columns.map { |attr| send(attr) }.join(',')
    end
  end
end
