# frozen_string_literal: true

module DBotQuery
  module Models
    # A repository, or source of a dependency, that is the code that is dependent and vulnerable due to a package
    # on which it depends having a security vulnerability.
    class Repository < Base
      attribute :id, :integer
      attribute :name, :string
      attribute :full_name, :string
      attribute :owner, :string
      attribute :node_id, :string
      attribute :private, :boolean
      attribute :url, :url
      attribute :description, :string
      attribute :fork, :boolean
      attribute :created_at, :datetime
      attribute :updated_at, :datetime
      attributes :url, :teams, :notifications, :deployments, :labels, :releases, :milestones, :pulls
      attributes :url, :issues, :downloads, :compare, :merges, :contents, :issue_comment
      attributes :url, :subscription, :trees, :languages, :stargazers, :contributors, :subscribers
      attributes :url, :git_refs, :git_tags, :tags, :blobs, :events, :branches, :assignees, :hooks
      attributes :url, :issue_events, :html, :forks, :collaborators, :keys, :archive, :comments
      attributes :url, :statuses, :git_commits, :commits

      def ==(other)
        case other
        when Repository
          full_name == other.full_name
        when String
          full_name == other
        else
          false
        end
      end

      def to_s
        full_name
      end
    end
  end
end
