import dotenv from "dotenv";
import fetch from "node-fetch"; // Use node-fetch for environments without built-in fetch
import { GoodMem } from "goodmem";
import OpenAI from "openai";

// --- Main async function to run the script ---
async function runDiagnostics() {
    // --- Load environment variables ---
    console.log("\nLoading environment variables...");
    dotenv.config(); // Looks for a .env file

    const HOST_URL = process.env.HOST_URL || "http://localhost:8080";
    const API_KEY = process.env.ADD_API_KEY;
    const OPENAI_API_KEY = process.env.OPENAI_API_KEY;

    console.log(
        `API_KEY loaded: ${API_KEY && !API_KEY.includes("ADD") ? "FOUND" : "❌ MISSING or PLACEHOLDER"}`
    );
    console.log(
        `OPENAI_API_KEY loaded: ${OPENAI_API_KEY && !OPENAI_API_KEY.includes("your-openai-key") ? "FOUND" : "❌ MISSING or PLACEHOLDER"}`
    );

    // --- Test direct HTTP access ---
    console.log("\nTesting raw HTTP API...");
    try {
        const headers = (API_KEY && !API_KEY.includes("ADD")) ? { "x-api-key": API_KEY } : {};
        const response = await fetch(`${HOST_URL}/v1/spaces`, { headers });

        console.log(`Response status: ${response.status}`);
        if (response.ok) {
            console.log("API endpoint is reachable.");
        } else {
            const errorText = await response.text();
            console.log(`API responded but with error: ${errorText}`);
        }
    } catch (e) {
        console.log(`API request failed: ${e.message}`);
    }

    // --- Setup API Client ---
    let client = null;
    if (API_KEY && !API_KEY.includes("ADD")) {
        client = new GoodMem({
            apiKey: API_KEY,
            baseUrl: HOST_URL,
        });
    } else {
        console.log("Cannot initialize SDK — API key missing.");
    }

    // --- Test JavaScript SDK: List Spaces ---
    console.log("\nTesting GoodMem JavaScript SDK...");
    if (!client) {
        console.log("Skipping SDK space listing due to missing client.");
    } else {
        try {
            console.log("Fetching spaces via SDK...");
            // The JS SDK listSpaces directly returns the array of spaces
            const spaces = await client.spaces.listSpaces();
            console.log(`SDK list_spaces succeeded with ${spaces.length} space(s).`);
            for (const space of spaces) {
                const name = space.name || "(no name)";
                const labels = space.labels || {};
                console.log(`   - ID: ${space.spaceId}, Name: ${name}, Labels: ${JSON.stringify(labels)}`);
            }
        } catch (e) {
            console.log(`SDK test failed: ${e.message}`);
        }
    }

    // --- Test OpenAI Embeddings + GoodMem Integration ---
    console.log("\nTesting OpenAI Embeddings and GoodMem integration...");
    if (!OPENAI_API_KEY || OPENAI_API_KEY.includes("your-openai-key")) {
        console.log("Skipping OpenAI test due to missing key.");
    } else if (!client) {
        console.log("Cannot run memory test — SDK client not initialized.");
    } else {
        try {
            const openai = new OpenAI({ apiKey: OPENAI_API_KEY });
            console.log("Creating embedding with OpenAI...");
            // This step is just to verify the OpenAI key works; the GoodMem SDK handles embedding internally.
            await openai.embeddings.create({
                input: "test text",
                model: "text-embedding-3-small",
            });
            console.log("OpenAI key verified successfully.");

            console.log("Creating memory in GoodMem...");
            const spaces = await client.spaces.listSpaces();
            if (spaces.length > 0) {
                const spaceId = spaces[0].spaceId;
                const memory = await client.memories.createMemory({
                    originalContent: "test memory with open ai.",
                    contentType: "text/plain",
                    spaceId: spaceId,
                });
                console.log(`Memory created. ID: ${memory.memoryId}`);
            } else {
                console.log("No spaces available for memory creation.");
            }
        } catch (e) {
            console.log(`OpenAI + GoodMem integration test failed: ${e.message}`);
        }
    }
}

// Run the main function and catch any top-level errors
runDiagnostics().catch(console.error);
