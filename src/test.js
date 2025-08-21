import dotenv from "dotenv";
import { GoodMem } from "goodmem";

dotenv.config();
const API_KEY = process.env.ADD_API_KEY;
const HOST_URL = "http://155.138.208.97:8080";

const client = new GoodMem({ apiKey: API_KEY, baseUrl: HOST_URL });

let spaces = await client.spaces.listSpaces();
let spaceId = spaces.length > 0 ? spaces[0].spaceId : (await client.spaces.createSpace({ name: "test" })).spaceId;

const memory = await client.memories.createMemory({
  originalContent: "The Eiffel Tower is in Paris.",
  contentType: "text/plain",
  spaceId,
});
console.log("Memory created:", memory.memoryId);

const result = await client.queries.queryMemories({
  spaceId,
  query: "Where is the Eiffel Tower?",
});
console.log("Query result:", result);
