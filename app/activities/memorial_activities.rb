require 'temporalio/activity'
require_relative '../../lib/ai_providers/base_provider'

class MemorialActivities < Temporalio::Activity::Definition
  def initialize
    @ai_provider = AiProviders::BaseProvider.new
  end
  
  def generate_memorial_content(input)
    Rails.logger.info("Gerando conteúdo memorial para: #{input['nome_falecido']}")
    
    system_prompt = File.read(Rails.root.join('agents/memorial_agent_prompt.md'))
    
    user_prompt = <<~PROMPT
      ENTRADA:
      #{input.to_json}
      
      Gere o tributo memorial seguindo EXATAMENTE a estrutura JSON solicitada.
      Return ONLY valid JSON. Do not include markdown, explanations, or preamble.
    PROMPT
    
    result = @ai_provider.call_agent(:memorial, user_prompt, system_prompt)
    
    memorial = Memorial.find(input['memorial_id'])
    memorial.update(
      title: result['titulo'],
      biography_summary: result['biografia_resumida'],
      life_history: result['historico_vida'],
      quote: result['citacao_destaque'],
      keywords: result['palavras_chave'],
      status: 'memorial_generated'
    )
    
    result
  rescue => e
    Rails.logger.error("Erro em generate_memorial_content: #{e.message}")
    raise e
  end
  
  def generate_event_content(input)
    Rails.logger.info("Gerando conteúdo do evento")
    
    system_prompt = File.read(Rails.root.join('agents/event_agent_prompt.md'))
    
    user_prompt = <<~PROMPT
      ENTRADA:
      #{input.to_json}
      
      Organize as informações logísticas seguindo EXATAMENTE a estrutura JSON solicitada.
      Return ONLY valid JSON. Do not include markdown, explanations, or preamble.
    PROMPT
    
    result = @ai_provider.call_agent(:event, user_prompt, system_prompt)
    
    memorial = Memorial.find(input['memorial_id'])
    memorial.update(
      wake_details: result['velorio'],
      burial_details: result['sepultamento'],
      stream_details: result['transmissao'],
      offerings_options: result['oferendas'],
      schedule_summary: result['cronograma_resumido'],
      status: 'event_generated'
    )
    
    result
  rescue => e
    Rails.logger.error("Erro em generate_event_content: #{e.message}")
    raise e
  end
  
  def build_memorial_page(input)
    Rails.logger.info("Construindo página memorial")
    
    system_prompt = File.read(Rails.root.join('agents/webbuilder_agent_prompt.md'))
    
    user_prompt = <<~PROMPT
      DADOS DO MEMORIAL:
      #{input['memorial'].to_json}
      
      DADOS DO EVENTO:
      #{input['event'].to_json}
      
      NOME DO FALECIDO: #{input['nome_falecido']}
      
      Gere a página web completa seguindo EXATAMENTE a estrutura JSON solicitada.
      Crie HTML, CSS e JS seguros, responsivos e minimalistas.
      Return ONLY valid JSON. Do not include markdown, explanations, or preamble.
    PROMPT
    
    result = @ai_provider.call_agent(:webbuilder, user_prompt, system_prompt)
    
    memorial = Memorial.find(input['memorial_id'])
    memorial.update(
      page_slug: result['page_slug'],
      html_content: result['html_content'],
      css_content: result['css_content'],
      js_content: result['js_content'],
      page_url: result['url_preview'],
      status: 'page_built'
    )
    
    result
  rescue => e
    Rails.logger.error("Erro em build_memorial_page: #{e.message}")
    raise e
  end
  
  def dispatch_notifications(input)
    Rails.logger.info("Preparando notificações")
    
    system_prompt = File.read(Rails.root.join('agents/dispatch_agent_prompt.md'))
    
    memorial = Memorial.find(input['memorial_id'])
    contacts = Contact.where(memorial_id: memorial.id)
    
    dispatch_input = {
      page_url: input['page_url'] || memorial.page_url,
      nome_falecido: memorial.deceased_name,
      data_velorio: memorial.wake_details&.dig('data_formatada'),
      hora_velorio: memorial.wake_details&.dig('horario'),
      local_velorio: memorial.wake_details&.dig('local'),
      contatos: contacts.map { |c| { contato_id: c.id.to_s, nome: c.name, canal: c.channel, destino: c.destination, parentesco: c.relationship } }
    }
    
    user_prompt = <<~PROMPT
      ENTRADA:
      #{dispatch_input.to_json}
      
      Gere mensagens personalizadas para cada contato seguindo EXATAMENTE a estrutura JSON solicitada.
      Return ONLY valid JSON. Do not include markdown, explanations, or preamble.
    PROMPT
    
    result = @ai_provider.call_agent(:dispatch, user_prompt, system_prompt)
    
    result['mensagens_preparadas']&.each do |msg|
      contact = contacts.find(msg['contato_id'])
      contact.update(notified: true, notified_at: Time.current) if contact
    end
    
    memorial.update(status: 'completed', notified_count: result['total_contatos'])
    
    result
  rescue => e
    Rails.logger.error("Erro em dispatch_notifications: #{e.message}")
    raise e
  end
end
