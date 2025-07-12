# Document Q&A Chat System with n8n

This n8n workflow creates an intelligent document Q&A system that allows users to upload documents, automatically generates embeddings, and provides AI-powered chat responses based on the document content.

## Features

- **Document Upload**: Accept PDF document formats
- **Automatic Embedding Generation**: Uses OpenAI embeddings to create vector representations
- **Vector Storage**: Stores document chunks with embeddings for semantic search
- **Chat Interface**: Webhook-based chat system for document Q&A
- **Citation Tracking**: Provides source citations for answers
- **Multi-format Support**: Handles various document types

## Prerequisites

- n8n instance running with PostgreSQL + pgvector
- OpenAI API key configured
- Community nodes enabled in n8n

## Setup Instructions

### 1. Import the Workflow

1. Open your n8n instance at `http://localhost:5678`
2. Go to **Workflows** → **Import from file**
3. Select the `import_workflow.json` file
4. The workflow will be imported with all nodes and connections

### 2. Configure OpenAI Credentials

1. In the workflow, locate the **Embeddings OpenAI** nodes
2. Click on each node and configure your OpenAI API credentials
3. Ensure you have sufficient OpenAI API credits

### 3. Activate the Workflow

1. Click the **Active** toggle in the workflow editor
2. The webhook URLs will be generated automatically

## 📖 How to Use

### Training Documents (Upload Phase)

To upload and process a document for training:

```bash
curl --location 'http://localhost:5678/webhook/webhook/v2/upload-doc' \
--header 'Content-Type: application/pdf' \
--data-binary '@/path/to/your/document.pdf'
```

**Supported Formats:**
- PDF files
- DOCX files
- Excel files (XLSX)
- Text files

**Response:**
The system will:
1. Extract text from the document
2. Generate embeddings using OpenAI
3. Store chunks in the vector database
4. Return a success confirmation

### Chat Interface (Query Phase)

To ask questions about uploaded documents:

```bash
curl --location 'http://localhost:5678/webhook/webhook/v2/chat' \
--header 'Content-Type: application/json' \
--data '{
    "chatInput": "What are the main requirements in the document?"
}'
```

**Response Format:**
```json
{
    "answer": "Based on the document, the main requirements are...",
    "citations": [0, 1, 2],
    "context": "--- Citation 0 ---\n[Document content]\n--- Citation 1 ---\n[More content]"
}
```

## 🔍 Workflow Architecture

### Upload Flow (Top Section)
1. **Webhook** - Receives document uploads
2. **Extract from File** - Extracts text from various file formats
3. **Join to text** - Combines extracted content into single text
4. **HTTP Request** - Calls OpenAI embeddings API
5. **Extract embedding** - Processes embedding response
6. **Simple Vector Store** - Stores document chunks with embeddings

### Chat Flow (Bottom Section)
1. **When chat message received** - Receives chat queries
2. **Edit Fields** - Sets search parameters (chunks = 4)
3. **GetKnowledge** - Searches vector store for relevant content
4. **Code** - Formats search results with citations
5. **Information Extractor** - Generates AI response with citations
6. **Edit Fields1** - Formats final response

## ⚙️ Configuration Options

### Environment Variables
Add these to your n8n environment:
```bash
N8N_COMMUNITY_NODES_ENABLED=true
N8N_HOST=n8n.local
N8N_PORT=5678
N8N_PROTOCOL=http
N8N_SECURE_COOKIE=false
```

### Workflow Parameters
- **Chunks**: Number of document chunks to retrieve (default: 4)
- **Embedding Model**: text-embedding-ada-002
- **Chat Model**: gpt-4.1-mini
- **Vector Dimensions**: 1024

## Customization

### Adding New Document Types
1. Modify the **Extract from File** node
2. Add new file type handlers
3. Update the **Join to text** node if needed

### Changing AI Models
1. Update **Embeddings OpenAI** nodes with different models
2. Modify **OpenAI Chat Model** for different chat models
3. Adjust **Information Extractor** prompts

### Vector Store Configuration
- **Memory Key**: vector_store_key (shared across uploads)
- **Top K**: Number of chunks to retrieve (configurable)
- **Batch Size**: 512 for embedding generation

## 🐛 Troubleshooting

### Common Issues

1. **"OpenAI API key not found"**
   - Ensure OpenAI credentials are configured in n8n
   - Check API key validity and credits

2. **"Document not found in vector store"**
   - Verify document was uploaded successfully
   - Check vector store memory key consistency

3. **"Webhook not accessible"**
   - Ensure n8n is running and accessible
   - Check webhook URLs in workflow

### Debug Mode
Enable debug logging in n8n:
```bash
N8N_LOG_LEVEL=debug
```

## Performance Tips

1. **Batch Processing**: Upload multiple documents in sequence
2. **Chunk Size**: Adjust chunk size based on document complexity
3. **Memory Management**: Monitor vector store memory usage
4. **API Limits**: Be aware of OpenAI rate limits

## 🔒 Security Considerations

1. **API Key Protection**: Store OpenAI keys securely
2. **Document Privacy**: Ensure sensitive documents are handled appropriately
3. **Access Control**: Implement authentication for webhook endpoints
4. **Data Retention**: Consider document storage policies

## Monitoring

### Key Metrics to Monitor
- Document upload success rate
- Embedding generation time
- Chat response accuracy
- API usage and costs
- Vector store performance

### Log Analysis
Check n8n logs for:
- Webhook requests
- OpenAI API calls
- Vector store operations
- Error messages

## Contributing

To improve this workflow:
1. Test with different document types
2. Optimize embedding parameters
3. Enhance chat prompts
4. Add new features like document versioning

## License

This workflow is provided as-is for educational and development purposes.

---

**Need Help?** Check the n8n documentation or create an issue in the repository.