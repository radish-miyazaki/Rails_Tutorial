class User < ApplicationRecord
  validates :name, presence: true    # 「FILL_IN」をコードに置き換えてください
  validates :email, presence: true    # 「FILL_IN」をコードに置き換えてください

  has_many :microposts
end
