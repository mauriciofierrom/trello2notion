# frozen_string_literal: true

module Trello2Notion
  module Trello
    # Debugging utilities
    class Debug
      def self.pp_markdown(root)
        stack = [[root, 0]]

        until stack.empty?
          node, level = stack.pop
          puts ("  " * level) + "- #{node.type}"

          node.children.reverse_each do |child|
            stack.push([child, level + 1])
          end
        end
      end

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def self.pp_notion(root)
        stack = root.map { |e| [e, 0] }

        until stack.empty?
          node, level = stack.pop
          if node.respond_to? :type
            puts ("  " * level) + "- #{node.type}"
          else
            puts ("  " * level) + "- #{node.class.name}"
          end

          next unless node.respond_to? :children

          node.children.reverse_each do |child|
            stack.push([child, level + 1])
          end
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
    end
  end
end
