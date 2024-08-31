# frozen_string_literal: true

require_relative 'model'
# require_relative '../../service/mail'

class App
  desc 'Manage tags'
  command :tag do |c|
    c.desc 'Filter tags by name (contains pattern)'
    c.flag [:filter]
    c.desc 'List tags'
    c.command :list do |l|
      l.action do |_global_options, options, _args|
        name options[GLI::Command::PARENT][:filter]&.downcase
        App.api.fetch_tags do |tag|
          next if name && !tag.name.downcase.include?(name)

          puts tag.to_json
        end
      end
    end

    c.desc 'Create tags'
    c.command :new do |n|
      n.desc 'Name'
      n.flag [:name]
      n.desc 'Color'
      n.flag [:color],
             default_value: 'default',
             must_match: %w[default blue green orange red purple]
      n.desc 'Risk modifier'
      n.flag ['risk-modifier', :risk_modifier], default_value: 1.0
      n.desc 'Type'
      n.flag [:type], default_value: 'custom'

      n.action do |_global_options, options, _args|
        name = options[:name]
        if name.nil?
          puts 'Cannot create a tag without a valid name.'
          exit
        end
        color = options[:color]
        risk_modifier = options[:risk_modifier]
        type = options[:type]
        tag_id = App.api.create_tag(
          name:,
          color:,
          type:,
          risk_modifier:
        )
        puts 'Tag was not created' if tag_id.nil?
      end
    end

    c.desc 'Get tag by name'
    c.command :get do |g|
      g.desc 'By name'
      g.flag ['by-name', :by_name]
      g.action do |_global_options, options, _args|
        name = options[:by_name]
        tag = App.api.find_tag_by_name(name)
        puts tag.to_json unless tag.nil?
      end
    end
  end
end
