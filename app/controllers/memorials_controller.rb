require 'temporalio/client'

class MemorialsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
  
  def index
    @memorials = Memorial.all.order_by(created_at: :desc)
  end
  
  def new
    @memorial = Memorial.new
  end
  
  def create
    @memorial = Memorial.new(memorial_params)
    @memorial.status = 'draft'
    
    if @memorial.save
      # Salvar contatos
      save_contacts if params[:contacts].present?
      
      # Iniciar workflow
      begin
        client = Temporalio::Client.connect(
          ENV.fetch('TEMPORAL_HOST', 'temporal:7233'),
          ENV.fetch('TEMPORAL_NAMESPACE', 'default')
        )
        
        client.start_workflow(
          MemorialWorkflow,
          {
            'memorial_id' => @memorial.id.to_s,
            'nome_falecido' => @memorial.deceased_name,
            'data_nascimento' => @memorial.birth_date,
            'data_falecimento' => @memorial.death_date,
            'memorias_familia' => @memorial.memories,
            'velorio' => params[:velorio] || {},
            'sepultamento_cremacao' => params[:sepultamento_cremacao] || {},
            'transmissao_online' => params[:transmissao_online] || { 'tem_transmissao' => false },
            'oferendas' => params[:oferendas] || []
          },
          id: "memorial-workflow-#{@memorial.id}",
          task_queue: 'memorial-task-queue'
        )
        
        @memorial.update(status: 'processing')
        redirect_to @memorial, notice: 'Memorial criado! Os agentes estão processando...'
      rescue => e
        Rails.logger.error("Erro ao iniciar workflow: #{e.message}")
        redirect_to @memorial, alert: "Memorial salvo, mas erro ao iniciar processamento: #{e.message}"
      end
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def show
    @memorial = Memorial.find(params[:id])
  end
  
  def public
    @memorial = Memorial.find_by(page_slug: params[:slug])
    render layout: false if @memorial&.html_content.present?
  end
  
  private
  
  def memorial_params
    params.require(:memorial).permit(:deceased_name, :birth_date, :death_date, :memories)
  end
  
  def save_contacts
    contacts_params = params[:contacts]
    if contacts_params.is_a?(Array)
      contacts_params.each do |c|
        @memorial.contacts.create(
          name: c[:name],
          channel: c[:channel],
          destination: c[:destination],
          relationship: c[:relationship]
        )
      end
    end
  end
end
