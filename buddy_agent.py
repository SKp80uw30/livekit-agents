from livekit.agents import Agent, AgentSession, JobContext, WorkerOptions, cli
from livekit.plugins import openai, silero

async def entrypoint(ctx: JobContext):
    await ctx.connect()

    agent = Agent(
        instructions="You are Buddy, a friendly voice assistant.",
    )
    session = AgentSession(
        vad=silero.VAD.load(),
        stt=openai.STT(), # Using OpenAI's STT, which can use Whisper
        llm=openai.LLM(),
        tts=openai.TTS(),
    )

    await session.start(agent=agent, room=ctx.room)
    await session.generate_reply(instructions="greet the user and say 'I'm Buddy, your new AI companion!'")

if __name__ == "__main__":
    cli.run_app(WorkerOptions(entrypoint_fnc=entrypoint))