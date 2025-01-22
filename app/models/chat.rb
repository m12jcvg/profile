class Chat < ApplicationRecord
  has_many :messages

  def tokens
    messages.sum(:tokens)
  end
end
