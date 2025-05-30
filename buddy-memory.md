Buddy Memory Plan 

Phase 1: Setting Up the Conversational LiveKit Agent Backend
This phase establishes a simple conversational core for your voice agent using the LiveKit Agents framework. The focus is on real-time speech processing and basic AI interaction, not complex agentic behavior.

**Goal:** Deploy a basic conversational LiveKit agent that connects to a LiveKit server and greets the user.

**Steps:**

1.  **Set up LiveKit Server on Hostinger VPS:**
    *   Since you're using your Hostinger VPS for development, we will set up a self-hosted LiveKit server there.
    *   This will likely involve installing Docker and Docker Compose on your VPS (if not already present) and then using the official LiveKit Docker Compose configuration to deploy the LiveKit server and its dependencies (like Postgres and Redis).
    *   We will need to configure the LiveKit server with appropriate network settings to be accessible.
    *   **Action:** Install Docker and Docker Compose on VPS (if needed), deploy LiveKit server using Docker Compose, configure network access.

2.  **Prepare Development Environment on Hostinger VPS:**
    *   Connect to your Hostinger VPS via SSH.
    *   Create a directory for your Buddy Agent project.
    *   Clone or transfer the necessary files for your agent code into this directory.
    *   **Action:** SSH into VPS, create project directory, transfer agent code files.

3.  **Install and Configure `livekit-agents` and OpenAI Plugin:**
    *   Within your agent project directory on the VPS, create a Python virtual environment.
    *   Install the `livekit-agents` library and the OpenAI plugin using pip.
    *   Configure environment variables for `LIVEKIT_URL`, `LIVEKIT_API_KEY`, `LIVEKIT_API_SECRET` (obtained from your LiveKit server setup), and `OPENAI_API_KEY` (your key). These will be used by your agent code.
    *   **Action:** Create virtual environment, install `livekit-agents` and OpenAI plugin, set environment variables.

4.  **Write Initial Agent Logic (Simple Voice Agent):**
    *   Create a Python file (e.g., `buddy_agent.py`) for your agent's core logic, based on the "Simple Voice Agent" example in the `livekit-agents` README.
    *   Use the `livekit-agents` framework to define an agent that connects to the LiveKit room.
    *   Implement the logic to use the OpenAI TTS plugin to generate the greeting "I'm Buddy, your new AI companion!" and play it back in the room upon connection.
    *   **Action:** Create `buddy_agent.py`, write agent code using `livekit-agents` and OpenAI TTS for the greeting, referencing the "Simple Voice Agent" example.

5.  **Create Dockerfile for the Agent:**
    *   Create a `Dockerfile` in your project directory.
    *   This Dockerfile will define how to build a Docker image for your agent application.
    *   It will include steps to set up the Python environment, copy your agent code, install dependencies, and define the entry point for running your agent.
    *   **Action:** Create `Dockerfile` to containerize the agent application.

6.  **Build and Run Docker Container on Hostinger VPS:**
    *   On your Hostinger VPS, navigate to your project directory.
    *   Build the Docker image using the Dockerfile, naming it "Buddy".
    *   Run the Docker container, ensuring it has access to the necessary environment variables (LIVEKIT\_*, OPENAI\_API\_KEY) and can communicate with the LiveKit server running on the VPS.
    *   **Action:** Build Docker image named "Buddy", run the Docker container on the VPS.

7.  **Verify Agent Functionality:**
    *   Use a LiveKit client (like the Agents Playground or a simple test client) to connect to your LiveKit server on the VPS.
    *   Verify that the "Buddy" agent container starts, connects to the room, and plays the greeting message.
    *   Check Docker logs for the "Buddy" container for any errors.
    *   **Action:** Connect with a LiveKit client, verify greeting, check container logs.

Phase 2: Connecting Your Phone App Frontend for Conversational Interaction
This phase integrates your custom mobile user interface with the conversational backend established in Phase 1, enabling real-time voice communication. The front end has been created as a clickable prototype and lives in this repo https://github.com/SKp80uw30/buddy-talk-echo-mobile. We will focus on connecting this frontend to the backend for basic voice interaction.
1. Choose a LiveKit Client SDK for Your Mobile App:
    * Help the user select the LiveKit client SDK that best aligns with the mobile development framework for iOS and Android (React Native or Flutter are good candidates for cross-platform).
    * (Reference: LiveKit Client SDKs for various platforms.)
2. Establish Real-Time Connection:
    * Use the chosen LiveKit client SDK in your phone app to connect to your LiveKit server on the Hostinger VPS.
    * Implement token generation on your backend to authorize the connection.
3. Stream Audio Input to the Agent:
    * Capture audio from the phone's microphone and stream it to the LiveKit server using the client SDK, which then routes it to your agent.
4. Receive and Play Audio Output from the Agent:
    * Receive the agent's generated audio (TTS) from the LiveKit server and play it back to the user.

Phase 3: Connecting Pinecone for Long-Term Memory (RAG)
This phase adds persistent, external knowledge to your agent.
1. Set Up Your Pinecone Account/Instance:
    * Create a Pinecone account and set up your vector index.
2. Prepare Your Data for Pinecone:
    * Collect, chunk, and embed your knowledge data.
    * Ingest the vectors into your Pinecone index.
3. Integrate Pinecone with Your livekit-agents:
    * Within your livekit-agents code, integrate a RAG framework like LlamaIndex.
    * Configure this framework to use your Pinecone index as its vector store.
    * Update your agent's logic to retrieve relevant information from Pinecone and use it to augment LLM prompts for more informed responses.

Phase 4: Integrating n8n for Extended Workflows
This phase leverages n8n to connect your agent to other services for non-real-time actions.
1. Identify Auxiliary Workflows:
    * Determine what "behind-the-scenes" actions your agent might need to trigger (e.g., creating a CRM ticket, sending an email, logging data to a spreadsheet, interacting with external APIs not directly handled by the agent).
2. Set up n8n Workflows with Webhooks:
    * In n8n, create new workflows.
    * Start each workflow with a "Webhook" trigger. This will give you a unique URL your agent can call.
3. Trigger n8n from Your LiveKit Agent:
    * Within your livekit-agents code, when a specific condition or user intent is detected (e.g., "user wants to submit a support request"), make an HTTP request to the corresponding n8n webhook URL.
    * Pass any necessary data (e.g., customer details, request summary) in the body of the HTTP request.
4. Orchestrate Actions within n8n:
    * Inside the n8n workflow, use its various nodes to perform the desired actions (e.g., connect to a CRM API, send an email via an email service, log data to a Google Sheet). n8n will handle the authentication and logic for these external integrations.