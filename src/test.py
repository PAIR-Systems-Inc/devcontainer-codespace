from goodmem_client.api import SpacesApi, MemoriesApi, QueriesApi
from goodmem_client.api_client import ApiClient
from goodmem_client.configuration import Configuration
import os
from dotenv import load_dotenv

load_dotenv(".env")
API_KEY = os.getenv("ADD_API_KEY")
HOST_URL = "http://155.138.208.97:8080"

config = Configuration()
config.host = HOST_URL
api_client = ApiClient(configuration=config)
api_client.default_headers["x-api-key"] = API_KEY

spaces = SpacesApi(api_client).list_spaces().spaces
space_id = spaces[0].space_id if spaces else SpacesApi(api_client).create_space({"name": "test"}).space_id

memories_api = MemoriesApi(api_client)
memory = memories_api.create_memory({
    "original_content": "The Eiffel Tower is in Paris.",
    "contentType": "text/plain",
    "spaceId": space_id,
})
print("Memory created:", memory.memory_id)

queries_api = QueriesApi(api_client)
result = queries_api.query_memories(space_id=space_id, query="Where is the Eiffel Tower?")
print("Query result:", result)
