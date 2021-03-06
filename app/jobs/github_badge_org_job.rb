class GithubBadgeOrgJob
  include Sidekiq::Worker

  sidekiq_options queue: :medium

  def perform(username, action)
    user = User.with_username(username)
    unless user.nil? or user.github.nil?
      if action.to_sym == :add
        GithubBadge.new.add_all(user.badges, user.github)
      elsif action.to_sym == :remove
        GithubBadge.new.remove_all(user.badges, user.github)
      end
    end
  end
end
