require 'octokit'

module DBotQuery
  module OctokitExtensions
    def dependabot_org_alerts(org)
      Models::AlertCollection.new(get("/orgs/#{org}/dependabot/alerts"))
    end

    def dependabot_repo_alerts(owner, repo)
      Models::AlertCollection.new(get("/repos/#{owner}/#{repo}/dependabot/alerts"))
    end
  end
end

Octokit::Client.include DBotQuery::OctokitExtensions
