# frozen_string_literal: true

class ChatsController < ApplicationController
  before_action :check_maintenance_mode

  def new
    # TODO: handle trying to create a new chat when one already exists
    @chat = Chat.create
    session[:chat_id] = @chat.id
  end

  def end
    session[:chat_id] = nil
  end

  def new_message
    @chat = Chat.find(new_message_params[:chat_id])
    if new_message_params[:content].empty?
      head :no_content
      return
    end

    @message = @chat.messages.create!(role: Roles::USER, content: new_message_params[:content])
    GenerateAssistantResponseJob.perform_later(@chat.id, @message.content)
  end

  private
  def new_message_params
    params.permit(:content, :chat_id)
  end

  def check_maintenance_mode
    redirect_to root_path if Config.maintenance_mode?
  end
end
