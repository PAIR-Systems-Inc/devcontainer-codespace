// test_goodmem.js
import dotenv from "dotenv";
import fetch from "node-fetch";
import { GoodMem } from "goodmem";

// --- Load environment variables ---
console.log("\nLoading environment variables...");
dotenv.config();

const HOST_URL = "http://155.138.208.97:8080/v1";
const API_KEY = process.env.ADD_API_KEY;
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;

console.log(
  `API_KEY loaded: ${API_KEY && !API_KEY.includes("ADD") ? "FOUND" : "❌ MISSING or PLACEHOLDER"}`
);
console.log(
  `OPENAI_API_KEY loaded: ${OPENAI_API_KEY && !OPENAI_API_KEY.includes("your-openai-key") ? "FOUND" : "❌ MISSING or PLACEHOLDER"}`
);

// --- Test raw HTTP access ---
console.log("\nTesting raw HTTP API...");

try {
  const headers = API_KEY && !API_KEY.includes("ADD") ? { "x-api-key": API_KEY } : {};
  const response = await fetch(HOST_URL.replace("/v1", "/v1/spaces"), { headers });
  console.log(`Response status: ${response.status}`);
  if (response.ok) {
    console.log("API endpoint is reachable.");
  } else {
    console.log("API responded but with error:", await response.text());
  }
} catch (e) {
  console.log("API request failed:", e);
}

// --- Setup SDK ---
console.log("\nTesting GoodMem JavaScript SDK...");
let client;

if (API_KEY && !API_KEY.includes("ADD")) {
  client = new GoodMem({ apiKey: API_KEY, baseUrl: HOST_URL.replace("/v1", "") });
} else {
  console.log("Cannot initialize SDK — API key missing.");
}

if (client) {
  try {
    const spaces = await client.spaces.listSpaces();
    console.log(`SDK listSpaces succeeded with ${spaces.length} space(s).`);
    spaces.forEach((space) => {
      console.log(`   - ID: ${space.spaceId}, Name: ${space.name}, Labels: ${JSON.stringify(space.labels)}`);
    });
  } catch (e) {
    console.log("SDK test failed:", e);
  }
}

// --- Test OpenAI + GoodMem integration (optional) ---
console.log("\nTesting OpenAI Embeddings and GoodMem integration...");

if (!OPENAI_API_KEY || OPENAI_API_KEY.includes("your-openai-key")) {
  console.log("Skipping OpenAI test due to missing key.");
} else if (!client) {
  console.log("Cannot run memory test — SDK client not initialized.");
} else {
  try {
    // Using OpenAI Node.js client
    const OpenAI = (await import("openai")).default;
    const openai = new OpenAI({ apiKey: OPENAI_API_KEY });

    console.log("Creating embedding with OpenAI...");
    const embeddingResponse = await openai.embeddings.create({
      input: "test text",
      model: "text-embedding-3-small",
    });
    console.log("OpenAI embedding succeeded.");

    console.log("Creating memory in GoodMem using embedding...");
    const spaces = await client.spaces.listSpaces();
    if (spaces.length > 0) {
      const spaceId = spaces[0].spaceId;
      const memory = await client.memories.createMemory({
        originalContent: "test memory w open ai.",
        contentType: "text/plain",
        spaceId,
      });
      console.log(`Memory created. ID: ${memory.memoryId}`);
    } else {
      console.log("No spaces available for memory creation.");
    }
  } catch (e) {
    console.log("OpenAI + GoodMem integration test failed:", e);
  }
}
