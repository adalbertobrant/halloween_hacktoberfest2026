require 'temporalio/workflow'

class MemorialWorkflow < Temporalio::Workflow::Definition
  def execute(input)
    # ETAPA 1: Paralela - Memorial e Evento
    memorial_result = Temporalio::Workflow.execute_activity(
      MemorialActivities,
      :generate_memorial_content,
      input,
      schedule_to_close_timeout: 180
    )
    
    event_result = Temporalio::Workflow.execute_activity(
      MemorialActivities,
      :generate_event_content,
      input,
      schedule_to_close_timeout: 180
    )
    
    # ETAPA 2: Sequencial - Construir página
    web_result = Temporalio::Workflow.execute_activity(
      MemorialActivities,
      :build_memorial_page,
      {
        memorial: memorial_result,
        event: event_result,
        memorial_id: input['memorial_id'],
        nome_falecido: input['nome_falecido']
      },
      schedule_to_close_timeout: 300
    )
    
    # ETAPA 3: Sequencial - Notificações
    dispatch_result = Temporalio::Workflow.execute_activity(
      MemorialActivities,
      :dispatch_notifications,
      {
        page_url: web_result['page_url'],
        memorial_id: input['memorial_id']
      },
      schedule_to_close_timeout: 600
    )
    
    {
      status: 'completed',
      page_url: web_result['page_url'],
      notified_count: dispatch_result['total_contatos']
    }
  end
end
