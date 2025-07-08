# n8n-research

A Docker Compose setup for running n8n with secure authentication and OpenAI integration.

## Setup

1. Copy the environment variables template:
   ```bash
   cp env.example .env
   ```

2. Edit the `.env` file with your actual credentials:
   - Set your desired username and password for N8N authentication
   - Add your OpenAI API key
   - Configure the N8N host and webhook tunnel URL as needed

3. Start the n8n service:
   ```bash
   docker-compose up -d
   ```

4. Access n8n at `http://localhost:5678`

## Security

- The `.env` file is excluded from version control via `.gitignore`
- Never commit your actual API keys or passwords to the repository
- Use strong, unique passwords for production environments

## Environment Variables

- `N8N_BASIC_AUTH_USER`: Username for n8n authentication
- `N8N_BASIC_AUTH_PASSWORD`: Password for n8n authentication
- `OPENAI_API_KEY`: Your OpenAI API key for AI integrations
- `N8N_HOST`: The hostname for n8n (default: n8n.local)
- `WEBHOOK_TUNNEL_URL`: Webhook tunnel URL (default: https://n8n.local)