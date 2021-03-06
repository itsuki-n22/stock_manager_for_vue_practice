# == Schema Information
#
# Table name: todos
#
#  id         :bigint           not null, primary key
#  body       :string           default("")
#  title      :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_todos_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Todo < ApplicationRecord
  belongs_to :user
end
