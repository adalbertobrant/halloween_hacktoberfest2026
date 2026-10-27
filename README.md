# MemorialAvisos - Multi-Agent System for Obituary Notices and Memorial Pages

An open-source system for creating respectful memorial pages and notifying family and friends, built using only open-weight models via Ollama.

## Features

- **Multi-Agent Architecture**: 4 specialized agents orchestrated by Temporal
- **Open-Weight AI**: Uses `gemma4:e4b` and `gemma3:4b` via Ollama (local or remotely accessible)
- **Resilient Workflows**: Temporal ensures automatic recovery on failures
- **Privacy-Focused**: Designed with LGPD/GDPR principles in mind, no invasive trackers
- **Fully Dockerized**: Lightweight setup with Nginx frontend + Rails backend
- **Flexible AI Provider**: Switch between local Ollama or external AI services

## Agents

| Agent | Model | Temperature | Purpose |
|-------|-------|-------------|---------|
| **MemorialAgent** | `gemma4:e4b` | 0.3 | Creates respectful and empathetic memorial tributes |
| **WebBuilderAgent** | `gemma4:e4b` | 0.2 | Generates secure, responsive HTML/CSS/JS memorial pages |
| **EventAgent** | `gemma3:4b` | 0.1 | Organizes funeral/wake details and offering options |
| **DispatchAgent** | `gemma3:4b` | 0.1 | Sends respectful, personalized notifications to contacts |

## Tech Stack

- **Backend**: Ruby on Rails 8.0
- **Database**: MongoDB (local or MongoDB Atlas)
- **Workflow Orchestration**: Temporal
- **AI Models**: Ollama with Gemma 4 / Gemma 3
- **Cache**: Redis
- **Reverse Proxy**: Nginx (lightweight)
- **Containerization**: Docker & Docker Compose
- **Observability**: OpenTelemetry + Sentry (optional)

## Prerequisites

- [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/)
- [Ollama](https://ollama.com/) running on your host machine with the required models:
  ```bash
  ollama pull gemma4:e4b
  ollama pull gemma3:4b
  ```
- At least 8GB RAM recommended (6.6GB for gemma4:e4b + 3.4GB for gemma3:4b + Docker services)

## Quick Start

### 1. Clone and configure

```bash
git clone https://github.com/adalbertobrant/halloween_hacktoberfest2026.git
cd halloween_hacktoberfest2026
cp .env.example .env
```

### 2. Verify Ollama is accessible

Make sure Ollama is running and reachable from Docker:

```bash
curl http://localhost:11434/api/tags
```

### 3. Start the application

```bash
docker-compose up --build
```

This will start all services: MongoDB, PostgreSQL, Temporal, Redis, Rails web, Temporal worker, and Nginx.

### 4. Access the app

| Service | URL | Purpose |
|---------|-----|---------|
| **Web App (via Nginx)** | http://localhost | Main application |
| **Rails Direct** | http://localhost:3000 | Direct Rails access |
| **Temporal UI** | http://localhost:8233 | Monitor workflows and activities |

## Configuration

### Using local Ollama (default)

Edit your `.env` file:

```env
AI_PROVIDER=ollama
OLLAMA_HOST=host.docker.internal:11434
OLLAMA_BASE_URL=http://host.docker.internal:11434

MEMORIAL_AGENT_MODEL=gemma4:e4b
WEBBUILDER_AGENT_MODEL=gemma4:e4b
EVENT_AGENT_MODEL=gemma3:4b
DISPATCH_AGENT_MODEL=gemma3:4b
ORCHESTRATOR_MODEL=gemma4:e4b
```

### Using external AI providers

```env
AI_PROVIDER=external
# Add your API keys as needed
# GEMINI_API_KEY=your_key
# OPENROUTER_API_KEY=your_key
# GROQ_API_KEY=your_key
```

## How It Works

1. **Create Memorial**: Fill in details about the deceased, memories, ceremony info, and contacts
2. **Agent Processing**: The Temporal workflow triggers all 4 agents in sequence/parallel
3. **Page Generation**: A respectful, static memorial page is generated with HTML/CSS/JS
4. **Notifications**: Personalized messages are prepared for all contacts via email/WhatsApp
5. **Publish**: The memorial page becomes accessible via a unique URL

## Project Structure

```text
├── agents/           # Agent system prompts (English)
├── app/              # Rails application (controllers, models, workflows, activities)
├── config/           # Rails configuration
├── docker/           # Dockerfiles and Nginx config
├── lib/              # AI providers, Temporal worker
├── PROMPTS/          # Prompt documentation and cost tracking
├── docker-compose.yml
└── MASTER_PROMPT.md  # Master orchestration prompt
```

## Costs

- **AI Models**: $0.00 (open-weight, running locally via Ollama)
- **Infrastructure**: $0.00 (runs locally with Docker)
- **Total**: **$0.00**

See `PROMPTS/prompts_costs.json` for detailed breakdown.

## Security & Ethics

- All content is sanitized before display
- No third-party tracking or analytics
- Sensitive data is handled with care
- Respects privacy and follows data minimization principles
- Built with empathy for families during difficult times
- Fully open-source for transparency

## Development

### Running tests
```bash
docker-compose exec web rails test
```

### Viewing logs
```bash
docker-compose logs -f web worker
```

### Accessing Rails console
```bash
docker-compose exec web rails console
```

## Contributing

This project was built for Hacktoberfest 2026. Contributions are welcome! Please keep in mind the sensitive nature of this project and maintain a respectful, empathetic approach.

## License

Open Source - Feel free to use, modify, and share.

## Acknowledgments

Built with love and respect for families navigating grief. Powered by open-weight models from Google (Gemma) and the amazing open-source community.
