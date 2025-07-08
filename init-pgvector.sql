-- init-pgvector.sql
-- This script automatically creates and verifies the pgvector extension

-- Create the pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Verify pgvector is installed and working
DO $$
BEGIN
    -- Check if vector extension exists
    IF NOT EXISTS (
        SELECT 1 FROM pg_extension WHERE extname = 'vector'
    ) THEN
        RAISE EXCEPTION 'pgvector extension could not be created';
    END IF;
    
    -- Log successful installation
    RAISE NOTICE 'pgvector extension successfully installed and enabled';
END $$;

-- Display vector version for verification
SELECT vector_version() as pgvector_version;

-- Create a test table to verify vector operations work
CREATE TABLE IF NOT EXISTS test_vectors (
    id SERIAL PRIMARY KEY,
    embedding vector(384),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert a test vector to verify functionality
INSERT INTO test_vectors (embedding) 
VALUES ('[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]'::vector)
ON CONFLICT DO NOTHING;

-- Test vector similarity search to ensure it's working
SELECT 
    id, 
    embedding <-> '[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]'::vector as distance 
FROM test_vectors 
ORDER BY embedding <-> '[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]'::vector
LIMIT 1;

-- Clean up test table (optional - remove this if you want to keep the test data)
-- DROP TABLE IF EXISTS test_vectors;

-- Log completion
DO $$
BEGIN
    RAISE NOTICE 'pgvector initialization completed successfully';
END $$; 