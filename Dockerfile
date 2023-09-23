FROM python:3-slim AS build

RUN apt-get update && \
    apt-get install -y build-essential curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sL https://foundry.paradigm.xyz | BASE_DIR=/opt/foundry FOUNDRY_DIR=/opt/foundry /bin/bash
RUN BASE_DIR=/opt/foundry FOUNDRY_DIR=/opt/foundry /opt/foundry/bin/foundryup

WORKDIR /src

COPY setup.py .

RUN pip install --upgrade build && \
    python -m build && \
    pip wheel .


FROM python:3-slim AS action

WORKDIR /app

COPY --from=build ["/opt/foundry/bin/", "/usr/bin/"]
COPY --from=build ["/opt/foundry/share/", "/usr/share/"]
COPY --from=build ["/src/dist/*.whl", "/src/*.whl", "./"]
RUN pip install *.whl

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
