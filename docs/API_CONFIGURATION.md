# API Configuration Guide

This document explains how to configure AI providers for MemorialAvisos.

## Current Status

**Only Ollama is fully implemented.** External providers (Gemini, OpenRouter, Groq) are defined in `.env.example` but not yet connected in `lib/ai_providers/base_provider.rb`. The app is designed to run 100% locally with open-weight models.

## Option 1: Ollama (Recommended - Local & Free)

This is the default and fully working option.

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
4. Start Ollama (it runs on `http://localhost:11434` by default)
5. In your `.env`:
```env
AI_PROVIDER=ollama
OLLAMA_BASE_URL=http://host.docker.internal:11434
```

### Where it's used
- `lib/ai_providers/base_provider.rb` - `call_ollama()` method
- `app/activities/memorial_activities.rb` - All 4 agents use this provider
- Routes through Docker's `host.docker.internal` to reach your host machine

## Option 2: External APIs (Not Yet Implemented)

If you want to use external providers, you'll need to implement them.

### What needs to be done

Edit `lib/ai_providers/base_provider.rb` and implement `call_external()`:

#### Google Gemini
- Endpoint: `https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={API_KEY}`
- Get key: [Google AI Studio](https://aistudio.google.com/apikey)

#### OpenRouter
- Endpoint: `https://openrouter.ai/api/v1/chat/completions`
- Get key: [OpenRouter](https://www.openrouter.ai/keys)
- Supports many open-weight models

#### Groq
- Endpoint: `https://api.groq.com/openai/v1/chat/completions`
- Get key: [Groq Console](https://console.groq.com/keys)
- Very fast inference

### Example implementation structure
```ruby
def call_external(agent_name, prompt, system_prompt)
  if ENV['GROQ_API_KEY'].present?
    call_groq(agent_name, prompt, system_prompt)
  elsif ENV['OPENROUTER_API_KEY'].present?
    call_openrouter(agent_name, prompt, system_prompt)
  elsif ENV['GEMINI_API_KEY'].present?
    call_gemini(agent_name, prompt, system_prompt)
  else
    call_ollama(agent_name, prompt, system_prompt) # fallback
  end
end
```

## Model Mapping

| Agent | Recommended Model | Why |
|-------|-------------------|-----|
| MemorialAgent | gemma4:e4b | Better at empathetic, nuanced writing |
| WebBuilderAgent | gemma4:e4b | Better at generating clean, structured code |
| EventAgent | gemma3:4b | Fast, accurate for factual/logistics tasks |
| DispatchAgent | gemma3:4b | Fast, good for short templated messages |

## Tips

- **For Hacktoberfest/local dev:** Stick with Ollama - it's free, private, and works offline
- **VRAM needed:** ~10GB total for both models + containers
- **Testing:** After changing models in Ollama, restart the worker: `docker-compose restart worker`
- **Debugging:** Check worker logs: `docker-compose logs -f worker`
