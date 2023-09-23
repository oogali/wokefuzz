FROM python:3-slim AS build

RUN apt-get update && \
    apt-get install -y build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /src

COPY setup.py .

RUN pip install --upgrade build && \
    python -m build && \
    pip wheel .


FROM python:3-slim AS action

WORKDIR /app

COPY --from=build ["/src/dist/*.whl", "/src/*.whl", "./"]
RUN pip install *.whl

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
