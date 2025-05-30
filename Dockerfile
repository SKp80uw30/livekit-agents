FROM python:3.11-slim

WORKDIR /app

COPY buddy_agent.py /app/buddy_agent.py
COPY requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

ENV LIVEKIT_URL=wss://buddy-rm0j48yw.livekit.cloud
ENV LIVEKIT_API_KEY=APIwgQ5ZsqPjiUj
ENV LIVEKIT_API_SECRET=zcZY22KtJlddq6OAKplfm3McA8k7dzv7fw4mXna27fsB
ENV OPENAI_API_KEY=
CMD ["python", "buddy_agent.py", "start"]