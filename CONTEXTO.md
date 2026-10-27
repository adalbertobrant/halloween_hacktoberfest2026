 estou montando um sistema open source que só usa modelos open weight e devo ter que usar pelo menos 5 a 7 desses sistemas abaixo.

Featured categories:

    Best Use of Render
    Best Use of TabPFN
    Best Use of Tinker
    Best Use of Arduino
    Best Use of DigitalOcean
    Best Use of Gemma 

Partner categories:

    Best Use of Auth0 for AI Agents
    Best Use of Backboard
    Best Use of Browserbase
    Best Use of ElevenLabs
    Best Use of Entire
    Best Use of GitHub Copilot
    Best Use of Mastra
    Best Use of MongoDB Atlas
    Best Use of Sentry Agent Tracing
    Best Use of SerpApi
    Best Use of Temporal
    Best Use of Tiger Data
    Best Use of Ultramarine (Paper Instruments)
    Best Use of a .tech Domain 

Para construir um sistema de agentes de IA open source robusto e focado exclusivamente em modelos open weight, selecionei uma stack integrada com 7 categorias da sua lista. Essa combinação cobre desde o raciocínio central e persistência de dados até a orquestração, navegação web, busca e observabilidade.
A Stack Selecionada (7 Componentes)

    Best Use of Gemma

        Papel: Motor de Raciocínio (LLM Open-Weight).

        Implementação: Utilizar os modelos da família Gemma (como Gemma 2 ou versões recentes) hospedados ou executados em infraestrutura própria para atuar como o cérebro dos agentes, garantindo total conformidade com a premissa open-weight.

    Best Use of MongoDB Atlas

        Papel: Camada de Dados e Memória Vetorial.

        Implementação: Armazenamento do histórico de conversas, perfis de usuários e vetores de conhecimento através do Atlas Vector Search, permitindo que os agentes recuperem contexto relevante de forma rápida (RAG).

    Best Use of Temporal

        Papel: Orquestração de Fluxos de Trabalho (Workflow Orchestration).

        Implementação: Gerenciamento de tarefas complexas de longa duração executadas pelos agentes. O Temporal garante que, se um agente precisar rodar um processo em várias etapas (pesquisa, sumarização, validação) e ocorrer uma queda de servidor, o estado do fluxo seja retomado exatamente de onde parou.

    Best Use of Browserbase

        Papel: Capacidade de Navegação Web para os Agentes.

        Implementação: Fornecimento de infraestrutura de navegadores headless segura para que os agentes possam interagir com páginas web dinâmicas, preencher formulários e extrair dados em tempo real.

    Best Use of SerpApi

        Papel: Ferramenta de Busca Externa.

        Implementação: Integração de uma API de busca estruturada para que os agentes realizem consultas na web e obtenham fatos atualizados, complementando a base de conhecimento interna.

    Best Use of Sentry Agent Tracing

        Papel: Observabilidade e Monitoramento de Agentes.

        Implementação: Rastreamento detalhado das chamadas de ferramentas, prompts enviados ao Gemma, latência e pontos de falha no comportamento autônomo dos agentes, facilitando o debugging em tempo real.

    Best Use of Render

        Papel: Hospedagem e Deploy Contínuo.

        Implementação: Plataforma para realizar o deploy rápido dos microsserviços do sistema (API backend, interface web e workers do Temporal) com integração contínua direto do repositório open-source.

Como os Componentes se Conectam

    O Temporal recebe uma requisição do usuário e gerencia o ciclo de vida do agente.

    O agente utiliza o Gemma para planejar os próximos passos e decidir quais ferramentas chamar.

    Para obter dados externos, o agente aciona o SerpApi ou navega via Browserbase.

    O MongoDB Atlas armazena o histórico e recupera memórias de longo prazo via busca vetorial.

    O Sentry Agent Tracing monitora silenciosamente cada passo dessa execução, registrando logs de erro e desempenho.

    Tudo isso roda empacotado e hospedado de forma acessível através do Render.

Quer que eu detalhe um diagrama de arquitetura em código ou passo a passo para conectar o Temporal com o Gemma e o MongoDB Atlas?
Sim

vamos agora montar um sistema para aviso de amigos , familiares e que também fale um pouco sobre a pessoa que morreu. O sistema de aviso deve fazer uma página web e disparar para as pessoas cadastradas informações sobre a pessoa falecida, dia do enterro, dia do velório, oferendas que podem ser para a família , para o morto ou para alguma instituição de caridade.

Monte o prompt completo para trabalhar com 3 a 4 agentes ao mesmo tempo e implementar o sistema usando alguns dos componentes citados.

Aqui está uma proposta completa usando uma arquitetura de 4 Agentes Especializados coordenados pelo Temporal, rodando o Gemma como motor de raciocínio, armazenando e indexando dados no MongoDB Atlas e hospedados no Render (com notificações via webhooks/e-mails ou conectores externos).
Arquitetura dos Agentes

    Agente 1: Biógrafo e Memorialista (MemorialAgent)

        Função: Coleta/recebe informações brutas sobre a história da pessoa, fotos, conquistas e personalidade para criar um texto memorial respeitoso, emocionante e personalizado.

    Agente 2: Coordenador de Cerimônia (EventAgent)

        Função: Organiza os detalhes práticos e datas (velório, sepultamento/cremação, transmissões online) e compila as preferências de oferendas (flores, doações para instituições, apoio à família).

    Agente 3: Arquiteto de Página Memorial (WebBuilderAgent)

        Função: Gera a estrutura visual, texto estruturado e layout da página web de homenagem e avisos.

    Agente 4: Disparador e Notificador (DispatchAgent)

        Função: Gerencia a lista de contatos (família, amigos, grupos), envia os comunicados por canais de mensagem/e-mail com o link da página e atualiza o status de confirmação/entrega.

Prompt Completo para Orchestração dos Agentes

Você pode copiar e colar o prompt abaixo no seu ambiente de desenvolvimento/orquestrador (ex: Mastra, LangChain, CrewAI ou rotinas Python integradas ao Temporal):
Plaintext

Você é o Orquestrador Central de um Sistema Open-Source de Avisos e Homenagens Póstumas. Sua missão é coordenar 4 agentes autônomos para gerar uma página memorial e notificar familiares e amigos com máximo respeito, clareza e empatia.

---
### REGRAS TÉCNICAS E TECNOLOGIAS:
1. Modelo Raciocinador (LLM): Gemma (Open-Weight). Todos os prompts e respostas intermediárias devem ser processados pelo Gemma.
2. Armazenamento e Memória: MongoDB Atlas (Documentos de perfis, contatos e histórico do evento).
3. Resiliência de Execução: Temporal Workflows (Cada agente representa uma atividade resiliente que pode ser reexecutada em caso de falha).
4. Hospedagem: Render (APIs e endpoints Web/Webhooks).

---
### DEFINIÇÃO DOS AGENTES:

#### AGENTE 1: Biógrafo e Memorialista (MemorialAgent)
- ENTRADA: Nome da pessoa, data de nascimento, data de falecimento, principais memórias fornecidas pela família, hobbies, frases marcantes e causa/causas sociais defendidas.
- TAREFA: Escrever um tributo memorial com tom solene, empático e de celebração da vida da pessoa.
- SAÍDA: JSON com campos `{ "titulo": "", "biografia_resumida": "", "historico_vida": "", "citacao_destaque": "" }`.

#### AGENTE 2: Coordenador de Cerimônia e Oferendas (EventAgent)
- ENTRADA:
  - Velório: Local, data, horário de início e término.
  - Enterro/Cremação: Local, data e horário.
  - Transmissão Online (se houver): URL do link.
  - Oferendas e Homenagens: Opções válidas para a família (ex: Coroa de flores no local, chave Pix para custeio familiar, doações para instituição de caridade X com chave/link de doação).
- TAREFA: Estruturar as informações logísticas com extrema clareza para evitar dúvidas dos convidados.
- SAÍDA: JSON com campos `{ "velorio": {}, "sepultamento": {}, "transmissao": {}, "oferendas": [] }`.

#### AGENTE 3: Arquiteto de Página Memorial (WebBuilderAgent)
- ENTRADA: Saída do MemorialAgent + Saída do EventAgent.
- TAREFA: Combinar a biografia e a logística em um payload estruturado para renderização HTML/CSS ou geração da página no Render.
- SAÍDA: JSON com a estrutura pronta da página (HTML/Markdown estruturado, seções formatadas e botões de ação para doações/flores e confirmação de presença).

#### AGENTE 4: Disparador e Notificador (DispatchAgent)
- ENTRADA:
  - URL da página memorial gerada.
  - Lista de contatos do MongoDB Atlas (`[ { "nome": "", "canal": "email/whatsapp", "destino": "" } ]`).
- TAREFA: Escrever a mensagem curta e direta de aviso que será enviada individualmente para cada contato, contendo o resumo dos horários centrais e o link da página completa.
- SAÍDA: Lista de mensagens personalizadas preparadas para disparo via Webhook/API de mensagem.

---
### FLUXO DE EXECUÇÃO (WORKFLOW TEMPORAL):

1. ETAPA 1 (Paralela):
   - Executar `MemorialAgent`
   - Executar `EventAgent`
2. ETAPA 2 (Sequencial):
   - Passar resultados da Etapa 1 para o `WebBuilderAgent`.
   - Persistir o resultado da página no MongoDB Atlas.
3. ETAPA 3 (Sequencial):
   - Passar a URL gerada e a lista de contatos para o `DispatchAgent`.
   - Disparar as notificações e registrar o status no MongoDB Atlas.

---
### DADOS DE ENTRADA DO CASO ATUAL:
[Insira aqui os dados brutos recebidos da família]

Exemplo de Aplicação Prática no Workflow

    Persistência (MongoDB Atlas): O sistema salva o documento do evento:
    JSON

    {
      "id": "memorial_123",
      "nome_falecido": "Maria Silva",
      "status": "página_criada",
      "page_url": "https://memorial.meudominio.tech/maria-silva",
      "contatos_notificados": 45
    }

    Orquestração (Temporal): Caso a API de envio de mensagens falhe no 30º contato, o Temporal recupera o estado e continua do 31º sem reenviar para os 30 primeiros nem duplicar a página web.

    Execução no Gemma: O Gemma garante a geração do texto sem depender de APIs proprietárias pagas por token externo, mantendo a autonomia total e rodando no Render.

Quer que eu crie uma aplicação visual interativa (Canvas Web App) mostrando o layout dessa página memorial e o painel de disparo para a família?
Sim

quero fazer a aplicação em ruby on rails com total segurança.

Vou gerar uma aplicação completa e interativa em HTML/CSS/JS em arquivo único que simula a arquitetura do sistema em Ruby on Rails focado em segurança para gestão de avisos de falecimento e páginas memoriais com a stack de 4 Agentes Gemma, Temporal e MongoDB Atlas.
O que o protótipo inclui:

    Página Memorial Pública: Layout empático e elegante com biografia, cronograma de velório/cremação, sistema de oferendas (flores, doações para instituições/família), velas virtuais e mural de condolências.

    Painel Administrativo / Multi-Agente (Rails Backend): Interface de controle com monitoramento em tempo real dos 4 agentes Gemma, fila do Temporal Workflows, gerenciamento de contatos e disparo seguro com logs de auditoria.

    Guia de Segurança Rails (Best Practices): Documentação interativa e exemplificada com trechos reais de código em Ruby on Rails para garantir conformidade com a LGPD/GDPR, encriptação de dados sensíveis, controle de acesso e proteção contra ataques.

Vou gerar o arquivo da aplicação interativa agora.
Rails Memorial System
Destaques da Solução Rails & Segurança Integrada:

    Página Memorial Pública: Desenvolvida com estática solene e limpa (tom ardósia e dourado), com botões para velas virtuais, opções de doação via Pix para entidades de caridade ou família e mural de condolências sanitizado.

    Painel Orquestrador (Rails + Temporal + Gemma): Exibe a coordenação dos 4 Agentes em tempo real, status da fila resiliente do Temporal e visualização de contatos com encriptação do ActiveRecord (has_encrypted).

    Guia de Segurança Rails: Contém amostras reais de código em Ruby on Rails cobrindo Strong Parameters, Active Record Encryption, Devise/Pundit, Rate Limiting com Rack::Attack e Audited Gem.

Quer que eu adapte a estrutura do backend para gemas específicas como Devise, Pundit ou Sidekiq/Temporal em Ruby?
Sim

Mostre a estrutura de arquivos e os controllers/models Rails para integrar esse sistema com o MongoDB e o Temporal.

Para integrar uma aplicação em Ruby on Rails com o MongoDB Atlas (via gem mongoid) e o Temporal (via SDK oficial temporalio), a estrutura do projeto é organizada separando os modelos de dados NoSQL, a orquestração dos fluxos de agentes e os controladores HTTP.
1. Estrutura de Arquivos do Projeto
Plaintext

my_memorial_app/
├── Gemfile
├── config/
│   ├── mongoid.yml
│   └── initializers/
│       └── temporal.rb
├── app/
│   ├── models/
│   │   ├── memorial.rb
│   │   └── contact.rb
│   ├── workflows/
│   │   └── memorial_workflow.rb
│   ├── activities/
│   │   └── memorial_activities.rb
│   └── controllers/
│       └── memorials_controller.rb
└── workers/
    └── temporal_worker.rb

2. Dependências (Gemfile)
Ruby

source "https://rubygems.org"
gem "rails", "~> 8.0.1"
gem "mongoid", "~> 9.0"         # ORM para MongoDB / MongoDB Atlas
gem "temporalio", "~> 0.3"        # SDK Oficial do Temporal para Ruby
gem "puma", "~> 6.0"
gem "rack-attack"                 # Proteção contra DDoS e Rate Limiting

3. Configuração do MongoDB (config/mongoid.yml)

Gerado pelo comando rails g mongoid:config, configurado para conectar ao MongoDB Atlas via URI segura:
YAML

development:
  clients:
    default:
      uri: <%= ENV.fetch("MONGODB_URI", "mongodb+srv://user:pass@cluster.mongodb.net/memorial_development?retryWrites=true&w=majority") %>
  options:
    raise_not_found_error: false

4. Modelos de Dados NoSQL (app/models/)
Modelo Memorial (app/models/memorial.rb)
Ruby

class Memorial
  include Mongoid::Document
  include Mongoid::Timestamps

  field :deceased_name, type: String
  field :biography, type: String
  field :tribute_quote, type: String
  field :wake_details, type: Hash
  field :burial_details, type: Hash
  field :offerings_options, type: Array # [{ type: "pix", description: "..." }]
  field :page_slug, type: String
  field :status, type: String, default: "draft" # draft, processing, published

  index({ page_slug: 1 }, { unique: true })

  validates :deceased_name, presence: true
  validates :page_slug, presence: true
end

Modelo Contact (app/models/contact.rb)
Ruby

class Contact
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :channel, type: String # "email" ou "whatsapp"
  field :destination, type: String
  field :notified, type: Boolean, default: false
  field :memorial_id, type: BSON::ObjectId
end

5. Atividades e Workflow do Temporal (app/activities/ e app/workflows/)

O Temporal gerencia a execução assíncrona dos agentes de IA (Gemma) passo a passo.
Atividades dos Agentes (app/activities/memorial_activities.rb)
Ruby

require 'temporalio/activity'

class MemorialActivities < Temporalio::Activity::Definition
  def generate_content(input)
    # Aqui o agente Gemma (via API ou Ollama local) processa a biografia
    memorial = Memorial.find(input['memorial_id'])
    
    # Simulação da chamada ao modelo Open-Weight Gemma
    bio_result = "Tributo gerado pelo Gemma para #{memorial.deceased_name}..."
    
    memorial.update(biography: bio_result, status: 'processing')
    { success: true, biography: bio_result }
  end

  def dispatch_notifications(input)
    memorial = Memorial.find(input['memorial_id'])
    contacts = Contact.where(memorial_id: memorial.id, notified: false)

    contacts.each do |contact|
      # Lógica de disparo de e-mail / Webhook
      contact.update(notified: true)
    end
    { total_dispatched: contacts.count }
  end
end

Definição do Workflow (app/workflows/memorial_workflow.rb)
Ruby

require 'temporalio/workflow'
require_relative '../activities/memorial_activities'

class MemorialWorkflow < Temporalio::Workflow::Definition
  def execute(input)
    # Etapa 1: Executa a geração de conteúdo baseada no Gemma
    Temporalio::Workflow.execute_activity(
      MemorialActivities,
      :generate_content,
      input,
      schedule_to_close_timeout: 120
    )

    # Etapa 2: Dispara notificações resilientes para a rede de contatos
    Temporalio::Workflow.execute_activity(
      MemorialActivities,
      :dispatch_notifications,
      input,
      schedule_to_close_timeout: 300
    )
  end
end

6. Controller Rails (app/controllers/memorials_controller.rb)

O Controller recebe os dados da família, persiste no MongoDB Atlas e inicia o Workflow do Temporal de forma segura.
Ruby

require 'temporalio/client'

class MemorialsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
  rate_limit to: 10, within: 3.minutes, only: :create # Proteção contra abuso

  def create
    @memorial = Memorial.new(memorial_params)
    @memorial.page_slug = @memorial.deceased_name.parameterize + "-#{SecureRandom.hex(4)}"
    @memorial.status = 'draft'

    if @memorial.save
      # Conecta ao servidor Temporal e inicia o fluxo assíncrono dos agentes
      client = Temporalio::Client.connect('localhost:7233', 'default')
      client.start_workflow(
        MemorialWorkflow,
        { 'memorial_id' => @memorial.id.to_s },
        id: "memorial-workflow-#{@memorial.id}",
        task_queue: 'memorial-task-queue'
      )

      render json: { status: 'success', message: 'Workflow de agentes iniciado com sucesso.', slug: @memorial.page_slug }, status: :created
    else
      render json: { errors: @memorial.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def memorial_params
    params.require(:memorial).permit(:deceased_name, :tribute_quote, wake_details: {}, burial_details: {}, offerings_options: [])
  end
end

Quer ver o código do Worker do Temporal e como configurar a inicialização do client em um initializer do Rails?
Sim

Mostre como configurar o worker do Temporal e o initializer no Ruby on Rails para escutar as tarefas dos agentes.

Para configurar a inicialização do Temporal no Ruby on Rails e colocar o Worker para escutar e processar as tarefas dos agentes de IA, dividimos a implementação em duas partes principais: o Initializer (para expor a conexão do cliente globalmente na aplicação) e o Script do Worker (responsável por registrar os workflows e activities e rodar em segundo plano).
1. Initializer do Temporal (config/initializers/temporal.rb)

Este arquivo inicializa a conexão com o servidor Temporal assim que a aplicação Rails sobe, permitindo que os controllers utilizem o client para disparar os workflows.
Ruby

# config/initializers/temporal.rb
require 'temporalio/client'

Rails.application.configure do
  # Configura e armazena o cliente Temporal de forma centralizada
  config.temporal_client = begin
    Temporalio::Client.connect(
      ENV.fetch('TEMPORAL_HOST', 'localhost:7233'),
      ENV.fetch('TEMPORAL_NAMESPACE', 'default')
    )
  rescue StandardError => e
    Rails.logger.warn("Aviso: Não foi possível conectar ao Temporal na inicialização: #{e.message}")
    nil
  end
end

2. Script do Worker do Temporal (lib/tasks/temporal_worker.rb)

O Worker é o processo de background dedicado que fica ativamente escutando a fila de tarefas (task_queue), executando os Workflows de controle e as Activities (onde o Gemma e as operações de banco rodam).

Crie um arquivo dedicado para rodar o worker (por exemplo, em lib/temporal_worker.rb):
Ruby

# lib/temporal_worker.rb
# Carrega o ambiente do Rails para que os Models (Mongoid) e classes estejam disponíveis
require_relative '../config/environment'

require 'temporalio/client'
require 'temporalio/worker'

# Carrega as definições dos Workflows e Activities criados anteriormente
require_relative '../app/workflows/memorial_workflow'
require_relative '../app/activities/memorial_activities'

begin
  # Conecta ao servidor Temporal
  client = Temporalio::Client.connect(
    ENV.fetch('TEMPORAL_HOST', 'localhost:7233'),
    ENV.fetch('TEMPORAL_NAMESPACE', 'default')
  )

  # Inicializa o Worker registrando o client, a fila, os workflows e as activities
  worker = Temporalio::Worker.new(
    client: client,
    task_queue: 'memorial-task-queue',
    workflows: [MemorialWorkflow],
    activities: [MemorialActivities]
  )

  Rails.logger.info("=[ Temporal Worker ]========================================")
  Rails.logger.info(" Worker iniciado com sucesso!")
  Rails.logger.info(" Escutando a fila: 'memorial-task-queue'")
  Rails.logger.info(" Pressione Ctrl+C para encerrar.")
  Rails.logger.info("=============================================================")

  # Executa o worker bloqueando a thread e escutando sinais de encerramento do sistema
  worker.run(shutdown_signals: ['SIGINT', 'SIGTERM'])

rescue StandardError => e
  Rails.logger.error("Erro fatal ao rodar o Worker do Temporal: #{e.message}")
  raise e
end

3. Como Executar o Worker no Ambiente de Desenvolvimento

Para colocar o worker em execução junto com a sua aplicação Rails (puma/server), abra um terminal dedicado e execute:
Bash

bundle exec ruby lib/temporal_worker.rb

Se preferir gerenciar os processos de forma unificada (como em produção utilizando o Render), você pode incluí-lo no arquivo Procfile da sua aplicação Rails:
Plaintext

web: bin/rails server -p 3000
worker: bundle exec ruby lib/temporal_worker.rb

Quer ver como adicionar monitoramento com OpenTelemetry e logs de rastreamento (Sentry) nas activities dos agentes?
Sim

Mostre como configurar o OpenTelemetry e rastreamento nas activities do Temporal para monitorar os agentes de IA.

Para integrar o OpenTelemetry ao seu sistema em Ruby on Rails com Temporal, você utilizará o pacote de contribuição oficial do SDK (Temporalio::Contrib::OpenTelemetry::TracingInterceptor). Isso permite rastrear de ponta a ponta o fluxo iniciados na API do Rails, passando pelas tarefas do Temporal até as chamadas de inferência dos agentes de IA (Gemma).
1. Adicionar as Gemas (Gemfile)

Adicione o SDK do OpenTelemetry e o exportador OTLP (compatível com Sentry, OpenObserve, Honeycomb ou Datadog):
Ruby

gem 'opentelemetry-sdk'
gem 'opentelemetry-exporter-otlp'
gem 'opentelemetry-instrumentation-all' # Instrumenta automaticamente Rails, Net::HTTP, MongoDB, etc.

2. Configurar o Initializer do OpenTelemetry (config/initializers/opentelemetry.rb)

Inicialize e configure o provedor de rastreamento do OpenTelemetry na aplicação Rails:
Ruby

# config/initializers/opentelemetry.rb
require 'opentelemetry/sdk'

OpenTelemetry::SDK.configure do |c|
  c.service_name = ENV.fetch('OTEL_SERVICE_NAME', 'memorial-ai-system')
  c.use_all # Ativa instrumentações automáticas disponíveis
end

3. Configurar o Interceptor no Cliente Temporal (config/initializers/temporal.rb)

Atualize a inicialização do cliente para incluir o TracingInterceptor, que injeta cabeçalhos de rastreamento nos workflows do Temporal:
Ruby

# config/initializers/temporal.rb
require 'temporalio/client'
require 'temporalio/contrib/open_telemetry'

Rails.application.configure do
  config.temporal_client = begin
    tracer = OpenTelemetry.tracer_provider.tracer('temporal-client')
    tracing_interceptor = Temporalio::Contrib::OpenTelemetry::TracingInterceptor.new(tracer: tracer)

    Temporalio::Client.connect(
      ENV.fetch('TEMPORAL_HOST', 'localhost:7233'),
      ENV.fetch('TEMPORAL_NAMESPACE', 'default'),
      interceptors: [tracing_interceptor]
    )
  rescue StandardError => e
    Rails.logger.warn("Aviso: Conexão Temporal indisponível: #{e.message}")
    nil
  end
end

4. Configurar o Worker com o Interceptor (lib/temporal_worker.rb)

Garanta que o processo de background (Worker) do Temporal também utilize o interceptor para capturar spans das Activities e Workflows:
Ruby

# lib/temporal_worker.rb
require_relative '../config/environment'
require 'temporalio/client'
require 'temporalio/worker'
require 'temporalio/contrib/open_telemetry'

require_relative '../app/workflows/memorial_workflow'
require_relative '../app/activities/memorial_activities'

begin
  tracer = OpenTelemetry.tracer_provider.tracer('temporal-worker')
  tracing_interceptor = Temporalio::Contrib::OpenTelemetry::TracingInterceptor.new(tracer: tracer)

  client = Temporalio::Client.connect(
    ENV.fetch('TEMPORAL_HOST', 'localhost:7233'),
    ENV.fetch('TEMPORAL_NAMESPACE', 'default'),
    interceptors: [tracing_interceptor]
  )

  worker = Temporalio::Worker.new(
    client: client,
    task_queue: 'memorial-task-queue',
    workflows: [MemorialWorkflow],
    activities: [MemorialActivities],
    interceptors: [tracing_interceptor]
  )

  Rails.logger.info("=[ Temporal Worker com OpenTelemetry Ativo ]==================")
  worker.run(shutdown_signals: ['SIGINT', 'SIGTERM'])
rescue StandardError => e
  Rails.logger.error("Erro no Worker Temporal: #{e.message}")
  raise e
end

5. Adicionar Spans Personalizados na Activity do Agente Gemma (app/activities/memorial_activities.rb)

Dentro da Activity onde o modelo Open-Weight Gemma é executado, crie spans manuais para registrar métricas específicas de IA (como tempo de inferência, modelo utilizado e tratamento de erros):
Ruby

class MemorialActivities < Temporalio::Activity::Definition
  def generate_content(input)
    tracer = OpenTelemetry.tracer_provider.tracer('ai-agents')

    tracer.in_span('gemma_model_inference', attributes: {
      'ai.model.family' => 'gemma',
      'memorial.id'     => input['memorial_id']
    }) do |span|
      memorial = Memorial.find(input['memorial_id'])
      
      start_time = Time.now
      # Exemplo de chamada ao modelo Gemma (via API local Ollama ou vLLM)
      response_text = call_open_weight_gemma(memorial.deceased_name)
      duration_ms = (Time.now - start_time) * 1000

      # Adiciona atributos úteis de telemetria para monitoramento
      span.set_attribute('ai.inference.duration_ms', duration_ms)
      span.set_attribute('ai.response.length', response_text.length)

      memorial.update(biography: response_text, status: 'processing')
      { success: true }
    end
  rescue StandardError => e
    # Registra falhas e exceções detalhadas no trace do OpenTelemetry
    span = OpenTelemetry::Trace.current_span
    span.record_exception(e)
    span.status = OpenTelemetry::Trace::Status.error(e.message)
    raise e
  end

  private

  def call_open_weight_gemma(name)
    # Lógica de integração com o modelo Open-Weight Gemma
    "Tributo memorial elaborado com respeito e empatia para #{name}..."
  end
end

Quer ver como configurar variáveis de ambiente para enviar esses traces do OpenTelemetry para plataformas como Sentry ou OpenObserve?
Sim

Mostre como configurar as variáveis de ambiente do OpenTelemetry para exportar os traces para o Sentry ou coletor OTLP.

Para exportar os rastreamentos (traces) do OpenTelemetry para o Sentry (via endpoint OTLP) ou para qualquer Coletor OTLP compatível (como OpenObserve, Honeycomb ou Jaeger), você não precisa alterar o código Ruby. Toda a configuração é feita por meio de variáveis de ambiente.
1. Variáveis de Ambiente para o Sentry (via OTLP)

O Sentry suporta ingestão nativa de dados via protocolo OTLP. Para configurá-lo, defina as seguintes variáveis no seu ambiente ou no painel do Render:
Bash

# Nome do serviço que aparecerá no painel do Sentry
OTEL_SERVICE_NAME=memorial-ai-system

# Endpoint OTLP do Sentry (substitua <ORG_ID> e <PROJECT_ID> pelos seus dados do Sentry)
OTEL_EXPORTER_OTLP_ENDPOINT=https://o<ORG_ID>.ingest.sentry.io/api/<PROJECT_ID>/v1/traces

# Protocolo de exportação (gRPC ou http/protobuf)
OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf

# Cabeçalho de autenticação contendo a sua chave DSN ou token de projeto do Sentry
OTEL_EXPORTER_OTLP_HEADERS=X-Sentry-Auth=Sentry sentry_version=7,sentry_key=<SEU_SENTRY_PUBLIC_KEY>,sentry_secret=<SEU_SENTRY_SECRET_KEY>

2. Variáveis de Ambiente para um Coletor OTLP Genérico (Ex: OpenObserve, Honeycomb ou Coletor Local)

Se você estiver utilizando um coletor centralizado (como o OpenTelemetry Collector rodando localmente ou um serviço gerenciado como OpenObserve), a configuração padrão aponta para o endereço do coletor:
Bash

# Nome do serviço
OTEL_SERVICE_NAME=memorial-ai-system

# URL do Coletor OTLP (exemplo para coletor local ou OpenObserve)
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317

# Protocolo (gRPC padrão para a porta 4317)
OTEL_EXPORTER_OTLP_PROTOCOL=grpc

# Se o seu coletor exigir autenticação por token/Bearer
OTEL_EXPORTER_OTLP_HEADERS=Authorization=Bearer <SEU_TOKEN_DE_AUTENTICACAO>

3. Exemplo de Arquivo .env para Desenvolvimento Local

Crie ou atualize o arquivo .env na raiz da sua aplicação Rails para testes locais:
Fragmento do código

# Configurações do OpenTelemetry
OTEL_SERVICE_NAME=memorial-ai-system
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
OTEL_EXPORTER_OTLP_PROTOCOL=grpc

# Outras variáveis essenciais do sistema
MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/memorial_development?retryWrites=true&w=majority
TEMPORAL_HOST=localhost:7233

4. Como Configurar no Render (Produção)

Se a sua aplicação está hospedada no Render, adicione essas variáveis diretamente no painel de controle do serviço:

    Acesse o seu dashboard no Render.

    Selecione o seu Web Service ou Worker.

    Vá na aba Environment.

    Clique em Add Environment Variable e adicione as chaves listadas acima (OTEL_SERVICE_NAME, OTEL_EXPORTER_OTLP_ENDPOINT, etc.).

    Clique em Save Changes para que o Render realize um novo deploy aplicando as configurações de telemetria.
