class Message < ApplicationRecord
  belongs_to :chat

  before_create :set_tokens

  private

  def set_tokens
    return if tokens.present?

    enc = Tiktoken.encoding_for_model("gpt-4o-mini")
    self.tokens = enc.encode(content).length
  end
end
