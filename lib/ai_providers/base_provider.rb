require 'httparty'
require 'json'

module AiProviders
  class BaseProvider
    include HTTParty
    
    def initialize
      @provider = ENV['AI_PROVIDER'] || 'ollama'
    end
    
    def call_agent(agent_name, prompt, system_prompt = nil)
      case @provider
      when 'ollama'
        call_ollama(agent_name, prompt, system_prompt)
      when 'external'
        call_external(agent_name, prompt, system_prompt)
      else
        call_ollama(agent_name, prompt, system_prompt)
      end
    end
    
    private
    
    def get_model_for_agent(agent_name)
      case agent_name.to_sym
      when :memorial
        ENV['MEMORIAL_AGENT_MODEL'] || 'gemma4:e4b'
      when :webbuilder
        ENV['WEBBUILDER_AGENT_MODEL'] || 'gemma4:e4b'
      when :event
        ENV['EVENT_AGENT_MODEL'] || 'gemma3:4b'
      when :dispatch
        ENV['DISPATCH_AGENT_MODEL'] || 'gemma3:4b'
      when :orchestrator
        ENV['ORCHESTRATOR_MODEL'] || 'gemma4:e4b'
      else
        'gemma4:e4b'
      end
    end
    
    def get_temperature_for_agent(agent_name)
      case agent_name.to_sym
      when :memorial
        (ENV['MEMORIAL_TEMPERATURE'] || 0.3).to_f
      when :webbuilder
        (ENV['WEBBUILDER_TEMPERATURE'] || 0.2).to_f
      when :event
        (ENV['EVENT_TEMPERATURE'] || 0.1).to_f
      when :dispatch
        (ENV['DISPATCH_TEMPERATURE'] || 0.1).to_f
      else
        0.2
      end
    end
    
    def call_ollama(agent_name, prompt, system_prompt)
      base_url = ENV['OLLAMA_BASE_URL'] || "http://#{ENV['OLLAMA_HOST'] || 'host.docker.internal:11434'}"
      model = get_model_for_agent(agent_name)
      temperature = get_temperature_for_agent(agent_name)
      
      messages = []
      messages << { role: 'system', content: system_prompt } if system_prompt
      messages << { role: 'user', content: prompt }
      
      options = {
        body: {
          model: model,
          messages: messages,
          stream: false,
          options: {
            temperature: temperature,
            top_p: 0.9,
            top_k: 40
          }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' },
        timeout: 300
      }
      
      response = self.class.post("#{base_url}/api/chat", options)
      
      if response.success?
        json_response = JSON.parse(response.body)
        content = json_response.dig('message', 'content') || ''
        # Garantir que é JSON válido
        extract_json(content)
      else
        raise "Ollama error: #{response.code} - #{response.body}"
      end
    rescue => e
      Rails.logger.error "AI Provider Error: #{e.message}"
      raise e
    end
    
    def call_external(agent_name, prompt, system_prompt)
      # Placeholder para serviços externos
      # Implementar conforme necessário
      call_ollama(agent_name, prompt, system_prompt)
    end
    
    def extract_json(content)
      # Tentar extrair JSON válido mesmo se houver markdown
      content = content.strip
      
      # Remover blocos markdown
      if content.include?('```json')
        content = content.split('```json')[1].split('```')[0].strip
      elsif content.include?('```')
        content = content.split('```')[1].split('```')[0].strip
      end
      
      # Tentar fazer parse
      JSON.parse(content)
    rescue JSON::ParserError
      # Tentar encontrar objeto JSON
      if content =~ /\{.*\}/m
        JSON.parse(content.match(/\{.*\}/m)[0])
      else
        raise "Invalid JSON response from AI"
      end
    end
  end
end
