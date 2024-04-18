# frozen_string_literal: true

class Domain
  class Model
    def initialize(attributes = {})
      attributes.each do |k, v|
        key = "#{k}="
        send(key, v) if respond_to?(key)
      end
    end

    # Ensure the columns method retrieves only valid attribute names
    def self.columns
      instance_methods.select { |m| m.to_s.end_with?('=') }
                      .map { |setter| setter.to_s.chomp('=') }
                      .select { |attr| instance_methods.include?(attr.to_sym) && !Object.instance_methods.include?(attr.to_sym) }
                      .sort
    end

    def self.table_name
      name.downcase
    end

    def to_s
      self.class.columns.map { |attr| send(attr) }.join(', ')
    end
  end
end
