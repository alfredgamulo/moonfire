import asyncio
import logging
from collections import deque
from dataclasses import dataclass
from datetime import datetime

import requests
from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

logging.basicConfig()
log = logging.getLogger(__name__)
log.setLevel(logging.INFO)

app = FastAPI()
app.mount("/static", StaticFiles(directory="app/static"), name="static")

templates = Jinja2Templates(directory="app/templates")

status = deque([], maxlen=50)


@dataclass
class BackgroundRunner:
    url: str = "https://getluna.com/"
    sleep: int = 5

    async def run_main(self):
        while True:
            now = datetime.now()
            response = requests.get(self.url)
            status.append(
                {
                    "url": self.url,
                    "status": response.status_code,
                    "timestamp": now + response.elapsed,
                }
            )
            log.info(response.status_code)
            await asyncio.sleep(self.sleep)


runner = BackgroundRunner()


@app.on_event("startup")
async def startup_event():
    asyncio.create_task(runner.run_main())


@app.get("/")
async def index(request: Request):
    return templates.TemplateResponse(
        "base.html",
        {"request": request, "target": runner.url, "status": reversed(status)},
    )
