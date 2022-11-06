import asyncio
import json
import logging
import os
from collections import deque
from dataclasses import dataclass
from datetime import datetime

import requests
from fastapi import FastAPI, Request
from fastapi.middleware.gzip import GZipMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

logging.basicConfig()
log = logging.getLogger(__name__)
log.setLevel(logging.INFO)

app = FastAPI()
app.add_middleware(GZipMiddleware)
app.mount("/static", StaticFiles(directory="app/static"), name="static")

templates = Jinja2Templates(directory="app/templates")

status = deque([], maxlen=50)


@dataclass
class BackgroundRunner:
    url: str = os.environ.get("MOONFIRE_URL")
    method: str = os.environ.get("MOONFIRE_METHOD")
    headers: str = os.environ.get("MOONFIRE_HEADERS")
    params: str = os.environ.get("MOONFIRE_PARAMS")
    data: str = os.environ.get("MOONFIRE_DATA")
    sleep: int = int(os.environ.get("MOONFIRE_SLEEP", 10))

    async def run_main(self):
        while True:
            now = datetime.now()
            try:
                if self.method == "POST":
                    response = requests.post(
                        self.url,
                        headers=self.headers and json.loads(self.headers) or None,
                        params=self.params and json.loads(self.params) or None,
                        data=self.data and json.loads(self.data) or None,
                    )
                else:
                    response = requests.get(
                        self.url,
                        headers=self.headers and json.loads(self.headers) or None,
                    )

                if response.ok:
                    log.info("Response OK")
                else:
                    log.warn("Response FAIL")

                status.append(
                    {
                        "url": self.url,
                        "status": response.status_code,
                        "elapsed": response.elapsed,
                        "timestamp": now + response.elapsed,
                    }
                )

            except Exception:
                status.append(
                    {
                        "url": self.url,
                        "status": "ERROR",
                        "elapsed": "N/A",
                        "timestamp": now,
                    }
                )
                log.error("Request ERROR")

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
