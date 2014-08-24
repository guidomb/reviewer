class PullRequest < ActiveRecord::Base

  validates_presence_of :number, :title, :state, :url, :sender, :repository

end
