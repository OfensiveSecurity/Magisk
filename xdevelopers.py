import asyncio, base64, json, os
import websockets
async def main():
    headers = {"Authorization": f"Bearer {os.environ['XAI_API_KEY']}"}
    async with websockets.connect("wss://api.x.ai/v1/realtime?agent_id=agent_Q0>
        await ws.send(json.dumps({
            "type": "conversation.item.create",
            "item": {"type": "message", "role": "user",
                     "content": [{"type": "input_text", "text": "Hello!"}]},
        }))
        await ws.send(json.dumps({"type": "response.create"}))
        async for raw in ws:
            event = json.loads(raw)
            if event["type"] == "response.output_audio_transcript.delta":
                print(event["delta"], end="", flush=True)
            elif event["type"] == "response.output_audio.delta":
                pcm = base64.b64decode(event["delta"])  # decode and play

asyncio.run(main())