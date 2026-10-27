# API Configuration Guide

This document explains how to configure AI providers for MemorialAvisos and how to add external ones if needed.

## Current Status

**Only Ollama is fully implemented.** External providers (Google Gemini, OpenRouter, Groq) are defined in `.env.example` but are **not connected yet** in `lib/ai_providers/base_provider.rb`. The current implementation falls back to Ollama even if `AI_PROVIDER=external` is set.

## Option 1: Ollama (Recommended - Local & Free)

This is the default, fully working option and the one used by this project.

### Setup

1. Install [Ollama](https://ollama.com/download)
2. Pull the required models:
```bash
ollama pull gemma4:e4b
ollama pull gemma3:4b
```
3. Verify they're available:
```bash
ollama list
```
4. Make sure Ollama is running on `http://localhost:11434`
5. Copy and configure your `.env`:
```bash
cp .env.example .env
```
6. Set in `.env`:
```env
AI_PROVIDER=ollama
OLLAMA_HOST=host.docker.internal:11434
OLLAMA_BASE_URL=http://host.docker.internal:11434
```

### Where it's used
- `lib/ai_providers/base_provider.rb` - `call_ollama(agent_name, prompt, system_prompt)` handles all requests
- `app/activities/memorial_activities.rb` - Instantiates `AiProviders::BaseProvider` and calls agents with their prompts from `agents/`
- `docker-compose.yml` - Passes `OLLAMA_HOST` to both `web` and `worker` containers with `host.docker.internal`

### How it works
The provider maps each agent to its model and temperature:
- `:memorial` → `gemma4:e4b` (temp 0.3)
- `:webbuilder` → `gemma4:e4b` (temp 0.2)
- `:event` → `gemma3:4b` (temp 0.1)
- `:dispatch` → `gemma3:4b` (temp 0.1)

It sends a chat request to `POST {OLLAMA_BASE_URL}/api/chat`, extracts the content, strips markdown code blocks, and parses JSON. If parsing fails, it tries to extract the first JSON object.

## Option 2: Add External APIs (Step by Step)

To actually use Gemini, OpenRouter, or Groq, you'll need to extend `lib/ai_providers/base_provider.rb`.

### 1) Get API Keys
| Provider | Endpoint | Get Key |
|----------|----------|---------|
| **Google Gemini** | `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent` | [Google AI Studio](https://aistudio.google.com/apikey) |
| **OpenRouter** | `https://openrouter.ai/api/v1/chat/completions` | [OpenRouter Keys](https://www.openrouter.ai/keys) |
| **Groq** | `https://api.groq.com/openai/v1/chat/completions` | [Groq Console](https://console.groq.com/keys) |

### 2) Update `.env`
```env
AI_PROVIDER=external
GEMINI_API_KEY=your_key_here
OPENROUTER_API_KEY=your_key_here
GROQ_API_KEY=your_key_here
```

### 3) Implement in `lib/ai_providers/base_provider.rb`

Replace `call_external` with routing logic:

```ruby
def call_external(agent_name, prompt, system_prompt)
  if ENV['GROQ_API_KEY'].present?
    call_groq(agent_name, prompt, system_prompt)
  elsif ENV['OPENROUTER_API_KEY'].present?
    call_openrouter(agent_name, prompt, system_prompt)
  elsif ENV['GEMINI_API_KEY'].present?
    call_gemini(agent_name, prompt, system_prompt)
  else
    Rails.logger.warn "No external API key found, falling back to Ollama"
    call_ollama(agent_name, prompt, system_prompt)
  end
end
```

#### Groq (OpenAI-compatible)
```ruby
def call_groq(agent_name, prompt, system_prompt)
  messages = []
  messages << { role: 'system', content: system_prompt } if system_prompt
  messages << { role: 'user', content: prompt }
  
  response = self.class.post(
    'https://api.groq.com/openai/v1/chat/completions',
    headers: { 
      'Authorization' => "Bearer #{ENV['GROQ_API_KEY']}",
      'Content-Type' => 'application/json'
    },
    body: {
      model: 'gemma2-9b-it', # or other model
      messages: messages,
      temperature: get_temperature_for_agent(agent_name),
      response_format: { type: 'json_object' }
    }.to_json,
    timeout: 300
  )
  
  raise "Groq error: #{response.code}" unless response.success?
  content = JSON.parse(response.body).dig('choices', 0, 'message', 'content')
  extract_json(content)
end
```

#### OpenRouter (OpenAI-compatible)
```ruby
def call_openrouter(agent_name, prompt, system_prompt)
  messages = []
  messages << { role: 'system', content: system_prompt } if system_prompt
  messages << { role: 'user', content: prompt }
  
  response = self.class.post(
    'https://openrouter.ai/api/v1/chat/completions',
    headers: { 
      'Authorization' => "Bearer #{ENV['OPENROUTER_API_KEY']}",
      'HTTP-Referer' => ENV['APP_HOST'] || 'http://localhost',
      'X-Title' => 'MemorialAvisos',
      'Content-Type' => 'application/json'
    },
    body: {
      model: 'google/gemma-2-9b-it', # adjust model
      messages: messages,
      temperature: get_temperature_for_agent(agent_name)
    }.to_json,
    timeout: 300
  )
  
  raise "OpenRouter error: #{response.code}" unless response.success?
  content = JSON.parse(response.body).dig('choices', 0, 'message', 'content')
  extract_json(content)
end
```

#### Google Gemini
```ruby
def call_gemini(agent_name, prompt, system_prompt)
  full_prompt = system_prompt ? "#{system_prompt}\n\n#{prompt}" : prompt
  
  response = self.class.post(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=#{ENV['GEMINI_API_KEY']}",
    headers: { 'Content-Type' => 'application/json' },
    body: {
      contents: [{ parts: [{ text: full_prompt }] }],
      generationConfig: {
        temperature: get_temperature_for_agent(agent_name),
        responseMimeType: 'application/json'
      }
    }.to_json,
    timeout: 300
  )
  
  raise "Gemini error: #{response.code}" unless response.success?
  content = JSON.parse(response.body).dig('candidates', 0, 'content', 'parts', 0, 'text')
  extract_json(content)
end
```

### 4) Restart
```bash
docker-compose build web worker
docker-compose up -d web worker
```

### 5) Test
Check logs to confirm which provider is used:
```bash
docker-compose logs -f worker
```

## Model Mapping

| Agent | Ollama (default) | Notes |
|-------|-------------------|-------|
| MemorialAgent | `gemma4:e4b` (0.3) | Best for empathetic, nuanced writing |
| WebBuilderAgent | `gemma4:e4b` (0.2) | Best for clean, structured HTML/CSS/JS |
| EventAgent | `gemma3:4b` (0.1) | Fast, accurate for factual/logistics |
| DispatchAgent | `gemma3:4b` (0.1) | Fast, good for short templated messages |

## Tips

- **For Hacktoberfest/local dev:** Stick with Ollama - it's free, private, and works offline
- **VRAM needed:** ~10GB total for both models + containers
- **After changing models in Ollama:** `docker-compose restart worker`
- **Debugging:** `docker-compose logs -f worker`
- **JSON enforcement:** All providers should request JSON output. Ollama uses `options`, external APIs often have `response_format` or `responseMimeType`
