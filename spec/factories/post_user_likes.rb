FactoryBot.define do
  factory :post_user_like do
    user { nil }
    post { nil }
  end
end

# == Schema Information
#
# Table name: post_user_likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_post_user_likes_on_post_id  (post_id)
#  index_post_user_likes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
