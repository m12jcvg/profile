class GenerateAssistantResponseJob < ApplicationJob
  queue_as :default

  ASSISTANT_ID = "asst_a3xvwBi3JFH9kPyerGwUMBoH"

  def perform(chat_id, last_message_content)
    begin
      chat = Chat.find(chat_id)

      if chat.thread_id.nil?
        chat.thread_id = ai_client.threads.create["id"]
        chat.save!
      end

      ai_client.messages.create(thread_id: chat.thread_id, parameters: { role: "user", content: last_message_content })

      stream_loading_state(chat_id)

      run_id = ai_client.runs.create(thread_id: chat.thread_id, parameters: { assistant_id: ASSISTANT_ID })["id"]
      result = handle_run_completion(run_id, chat.thread_id, chat.id)

      chat.messages.create(role: Roles::ASSISTANT, content: result)
    rescue => e
      logger.error("Error: #{e.message}")
      stream_error_response(chat_id)
    end
  end

  private

  def handle_run_completion(run_id, thread_id, chat_id)
    loop do
      run = ai_client.runs.retrieve(id: run_id, thread_id: thread_id)
      status = run["status"]
      case status
      when "queued", "in_progress", "cancelling"
        logger.info("Run status: #{status}")
        sleep(rand(500...1200) / 1000)
      when "completed"
        break
      when "requires_action"
        ai_client.runs.cancel(id: run_id, thread_id: thread_id)
        return stream_requires_action_response(chat_id)
      when "cancelled", "failed", "expired"
        return stream_error_response(chat_id)
      else
        return stream_error_response(chat_id)
      end
    end

    messages = ai_client.messages.list(thread_id: thread_id)
    last_message = messages["data"].first["content"].first["text"]["value"]
    stream_response [ last_message ], chat_id
  end

  def stream_loading_state(chat_id)
    Turbo::StreamsChannel.broadcast_render_to(
      "messages_#{chat_id}",
      partial: "chats/bot_loading",
      locals: { chat_id: }
    )
  end

  def ai_client
    @ai_client ||= OpenAI::Client.new(access_token: Config.openai_api_key)
  end

  def stream_error_response(chat_id)
    stream_response [ "I'm sorry, I'm having trouble with my AI. Please try again later." ], chat_id
  end

  def stream_requires_action_response(chat_id)
    # TODO: implent calling tools
    stream_response(
      [
        "Got it. Dev hasn't built that part yet so let me page him. /page @jcvg 'Get back to work and stop procrastinating'.",
        "Didn't receive a response. Escalating to Julio's manager. /page @jcvg's_wife 'Is Julio really that busy?'",
        "jk, I don't have pager duty integration yet. But you can ask me about work or fun facts."
      ],
      chat_id
    )
  end

  def stream_response(messages, chat_id)
    messages.each_with_index do |message, index|
      Turbo::StreamsChannel.broadcast_render_to(
        "messages_#{chat_id}",
        partial: "chats/new_bot_message",
        locals: { content: message, show_profile_picture: index.zero? }
      )

      sleep(rand(600...1200) / 1000)
    end

    messages.join("\n")
  end
end
