class Post < ApplicationRecord
  belongs_to :user
  has_many :post_user_likes

  validates :body, presence: true

  def liked_by?(user)
    post_user_likes.where(user: user).first.present?
  end
end

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
