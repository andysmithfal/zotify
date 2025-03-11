FROM python:3.13-alpine as base

RUN apk --update add ffmpeg git

FROM base as builder

WORKDIR /install
COPY requirements.txt /requirements.txt

RUN apk add gcc libc-dev zlib zlib-dev jpeg-dev
RUN pip install --prefix="/install" -r /requirements.txt

FROM base

COPY --from=builder /install /usr/local/lib/python3.13/site-packages
RUN mv /usr/local/lib/python3.13/site-packages/lib/python3.13/site-packages/* /usr/local/lib/python3.13/site-packages/

COPY zotify /app/zotify

WORKDIR /app
CMD ["python3", "-m", "zotify"]
