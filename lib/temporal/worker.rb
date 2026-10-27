require_relative '../../config/environment'
require 'temporalio/client'
require 'temporalio/worker'

require_relative '../../app/workflows/memorial_workflow'
require_relative '../../app/activities/memorial_activities'

begin
  client = Temporalio::Client.connect(
    ENV.fetch('TEMPORAL_HOST', 'temporal:7233'),
    ENV.fetch('TEMPORAL_NAMESPACE', 'default')
  )
  
  worker = Temporalio::Worker.new(
    client: client,
    task_queue: 'memorial-task-queue',
    workflows: [MemorialWorkflow],
    activities: [MemorialActivities]
  )
  
  Rails.logger.info("=[ Temporal Worker Iniciado ]================================")
  Rails.logger.info("Fila: memorial-task-queue")
  Rails.logger.info("IA Provider: #{ENV['AI_PROVIDER'] || 'ollama'}")
  Rails.logger.info("Ollama: #{ENV['OLLAMA_BASE_URL'] || ENV['OLLAMA_HOST']}")
  Rails.logger.info("============================================================")
  
  worker.run(shutdown_signals: ['SIGINT', 'SIGTERM'])
  
rescue StandardError => e
  Rails.logger.error("Erro fatal no Worker: #{e.message}")
  Rails.logger.error(e.backtrace.join("\n"))
  raise e
end
