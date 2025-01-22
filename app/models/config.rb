module Config
  def self.maintenance_mode?
    ENV.fetch("MAINTENANCE_MODE", false)
  end

  def self.openai_api_key
    ENV.fetch("OPENAI_API_KEY")
  end
end
