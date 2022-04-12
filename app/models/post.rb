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

  def users_likes_total_count
    return try(:post_user_likes_count) if respond_to?(:post_user_likes_count)

    post_user_likes.count
  end

  def self.select_with_likes_count(user_id = nil)
    raw_sql = "posts.*, "
    raw_sql << "(SELECT COUNT(*) FROM post_user_likes "\
             "WHERE post_user_likes.post_id = posts.id AND post_user_likes.user_id = #{user_id}"\
             ") AS user_like_count, " if user_id.present?
    raw_sql << "count(post_user_likes.id) as post_user_likes_count"

    left_joins(:post_user_likes).select(Arel.sql(raw_sql)).group(:id)
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
