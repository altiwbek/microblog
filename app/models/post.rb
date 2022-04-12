class Post < ApplicationRecord
  belongs_to :user
  has_many :post_user_likes

  validates :body, presence: true

  def liked_by?(user)
    if respond_to? :user_like_count
      return try(:user_like_count).to_i > 0?  true : false
    end

    post_user_likes.where(user: user).first.present?
  end

  def self.select_with_likes_of(user_id)
    select( Arel.sql(
      "posts.*, ("\
             "SELECT COUNT(*) FROM post_user_likes "\
             "WHERE post_user_likes.post_id = posts.id and post_user_likes.user_id = #{user_id}"\
             ") as user_like_count"
    ))
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
