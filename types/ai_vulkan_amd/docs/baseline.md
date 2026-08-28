# Project Baseline Context: Local AI Inference Stack (AMD Strix Halo)

## 1. Hardware & Environment

* **Platform:** AMD Ryzen AI MAX+ 395 (Strix Halo) with Radeon 8060S GPU.
* **Memory:** 128GB Unified Memory (VRAM + System RAM).
* **Cooling:** Vapor chamber; thermal throttling currently not observed.
* **Backend:** Vulkan (via custom `llama.cpp` fork).
* **Docker Validation:** Fully operational within Docker. Device passing,
  `vulkaninfo` status checks, and build integrity verified and confirmed.

## . Model Configuration

* **Inference Model:** `jamiefutch/Qwen3.5-122B-A10B-MXFP4_MOE-MTP-GGUF`
  * **Endpoint:** `http://localhost:8000/v1` (Direct Inference)
  * **Context:** 256k tokens (Manual rotation at ~240k via summarization).
  * **Optimization:** MXFP4 quantization, MTP (Multi-Token Prediction),
    Speculative Decoding enabled.
  * **Performance:** ~30 tok/s decoding, >130 tok/s prefill.
  * **Capability:** Native Function Calling / Tool Use support verified.
* **Embedding Model:** `nomic-ai/nomic-embed-text-v2-moe-GGUF`
  * **Endpoint:** `http://localhost:8001/v1`
  * **Requirement:** Strict prefix adherence (`search_query:` for retrieval,
    `search_document:` for indexing).
  * **Quantization:** Q6_K.

## 3. Infrastructure & Networking

* **Architecture:** Orchestrator Pattern (UI → Orchestrator → Inference/Tools).
  * **UI:** Connects exclusively to Orchestrator API (Single Endpoint Abstraction).
  * **Orchestrator:** Manages tool logic, context injection, and external API calls.
  * **Inference Engine:** Stateless model execution; receives tool schemas from
    Orchestrator.
* **Vector Database:** Undecided (Qdrant preferred candidate).
* **Tool Execution:** Local execution within the container (Python/Shell scripts).
* **Search Service:** External Tool API (Placeholder for SearXNG or similar).
  * **Endpoint:** `http://localhost:8080/search` (Managed by Orchestrator).
* **UI:** Custom `llama-ui` extension required for RAG, Document Ingestion, and
  Internet Access.

## 4. Operational Constraints

* **Memory Management:** No CPU offloading; strict GPU/Unified Memory
  management required.
* **Efficiency:** Prioritize minimal friction between inference and RAG tasks.
* **Chunking:** Initial strategy uses small, dense chunks; large semantic
  chunking remains a future option.
* **Security:** Local-only execution initially; reverse proxy security measures
  deferred.
* **Tool Safety:** Orchestrator must validate tool arguments before execution.

## 5. Strategic Objectives

* **Primary Goal:** Implement a robust RAG pipeline supporting document
  ingestion and internet search via Function Calling.
* **Secondary Goal:** Extend UI capabilities to manage tool use and context
  rotation seamlessly.
* **Future Scaling:** Refactor to multi-service Docker Compose architecture
  when production-ready.

## 6. Tool Calling Architecture

The Orchestrator acts as the bridge between the UI and the Inference Engine. It
injects tool schemas into every request and handles the execution loop when the
model requests a tool.

```text
+----------------+       +-------------------+       +-------------------+
|     UI         |       |   Orchestrator    |       | Inference Engine  |
| (Presentation) |       |    (API Gateway)  |       |   (llama.cpp)     |
+----------------+       +-------------------+       +-------------------+
       |                         |                           |
       | 1. User Query           |                           |
       |------------------------>|                           |
       |                         | 2. Add Tool Schema        |
       |                         |-------------------------->|
       |                         |                           |
       |                         | 3. Model Decision         |
       |                         |<--------------------------|
       |                         | (Returns tool_calls)      |
       |                         |                           |
       |                         | 4. Execute Tool           |
       |                         |-------------------------> |
       |                         | (e.g., Search API)        |
       |                         |                           |
       |                         | 5. Return Results         |
       |                         |<--------------------------|
       |                         |                           |
       |                         | 6. Feed Results Back      |
       |                         |-------------------------->|
       |                         | (Context + Tool Output)   |
       |                         |                           |
       |                         | 7. Final Answer           |
       |                         |<--------------------------|
       |                         |                           |
       | 8. Final Text           |                           |
       |<------------------------|                           |
       |                         |                           |
```

## 7. Validation & Testing Protocols

### 7.1. Tool Decision Test (Step 4)

* **Goal:** Verify model decides to search for unknown data.
* **Request:**

    ```bash
    curl http://localhost:8000/v1/chat/completions \
      -H "Content-Type: application/json" \
      -d '{
        "model": "jamiefutch/Qwen3.5-122B-A10B-MXFP4_MOE-MTP-GGUF",
        "messages": [{"role": "user", "content": "What is the current temperature of the AMD Strix Halo vapor chamber cooling system under load?"}],
        "tools": [{"type": "function", "function": {"name": "search_web", "description": "Search the internet...", "parameters": {"type": "object", "properties": {"query": {"type": "string"}}, "required": ["query"]}}}],
        "tool_choice": "auto"
      }'
    ```

* **Expected Response:**
  * `finish_reason`: `"tool_calls"`
  * `message.tool_calls`: Array containing `search_web` function.
  * `reasoning_content`: Present (indicates model reasoning about tool use).
  * `timings.draft_n_accepted`: Should match `draft_n` (Speculative Decoding active).

### 7.2. Tool Response Consumption Test (Step 6)

* **Goal:** Verify model consumes tool results and generates final answer.
* **Request:** (Includes previous tool call + tool result message)

    ```bash
    curl http://localhost:8000/v1/chat/completions \
      -H "Content-Type: application/json" \
      -d '{
        "model": "jamiefutch/Qwen3.5-122B-A10B-MXFP4_MOE-MTP-GGUF",
        "messages": [
          {"role": "user", "content": "Query..."},
          {"role": "assistant", "tool_calls": [...]},
          {"role": "tool", "tool_call_id": "...", "name": "search_web", "content": "Search results..."}
        ],
        "tools": [...]
      }'
    ```

* **Expected Response:**
  * `finish_reason`: `"stop"`
  * `message.content`: Final answer citing search data.
  * No `tool_calls` in response.

**Instruction:** All future technical recommendations must align with this
hardware profile, model specifications, and operational constraints. Solutions
must optimize for the AMD Vulkan environment and unified memory architecture
within the validated Docker container. The Orchestrator pattern is the standard
for all tool-enabled interactions.
