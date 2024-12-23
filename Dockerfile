ARG PYTHON_VERSION=3.12
ARG ALPINE_VERSION=3.18
ARG FUNC_NAME=hello

FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION} AS builder

ARG FUNC_NAME
WORKDIR /build

RUN apk add --no-cache \
    build-base \
    libffi-dev

COPY pyproject.toml poetry.lock ./
RUN pip install poetry && \
    poetry config virtualenvs.create false

COPY . .
RUN poetry install --only main --no-interaction

RUN mkdir -p /function && \
    cp -r src/packages /function/ && \
    cp -r src/lambdas/${FUNC_NAME} /function/lambda

FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION}
ARG FUNC_NAME

WORKDIR /function

COPY --from=builder /function /function
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages

ENV PYTHONPATH=/function
ENV FUNC_NAME=${FUNC_NAME}

CMD ["python", "/function/lambda/handler.py"]

# ARG PYTHON_VERSION=3.9
# ARG ALPINE_VERSION=3.18
# ARG FUNC_NAME=hello

# # amd64
# FROM --platform=linux/amd64 python:${PYTHON_VERSION}-alpine${ALPINE_VERSION} AS builder-amd64
# ARG FUNC_NAME
# WORKDIR /build

# RUN apk add --no-cache \
#     build-base \
#     libffi-dev \
#     ccache \
#     patchelf \
#     cmake

# COPY pyproject.toml poetry.lock ./
# RUN pip install poetry nuitka ordered-set zstandard && \
#     poetry config virtualenvs.create false

# COPY . .

# RUN ls -la src/lambdas/${FUNC_NAME}/

# RUN python -m nuitka \
#     --assume-yes-for-downloads \
#     --onefile \
#     --include-module=src \
#     --include-package-data=src \
#     --include-data-dir=src=src \
#     --follow-imports \
#     src/lambdas/${FUNC_NAME}/handler.py

# RUN ls -la && ls -la handler.*

# # arm64 
# FROM --platform=linux/arm64/v8 python:${PYTHON_VERSION}-alpine${ALPINE_VERSION} AS builder-arm64
# ARG FUNC_NAME
# WORKDIR /build

# RUN apk add --no-cache \
#     build-base \
#     libffi-dev \
#     ccache \
#     patchelf \
#     cmake

# COPY pyproject.toml poetry.lock ./
# RUN pip install poetry nuitka ordered-set zstandard && \
#     poetry config virtualenvs.create false

# COPY . .

# RUN ls -la src/lambdas/${FUNC_NAME}/

# RUN python -m nuitka \
#     --assume-yes-for-downloads \
#     --onefile \
#     --include-module=src \
#     --include-package-data=src \
#     --include-data-dir=src=src \
#     --follow-imports \
#     src/lambdas/${FUNC_NAME}/handler.py

# RUN ls -la && ls -la handler.*

# FROM scratch AS amd64
# COPY --from=builder-amd64 /build/handler.exe /bootstrap
# ENTRYPOINT ["/bootstrap"]

# FROM scratch AS arm64
# COPY --from=builder-arm64 /build/handler.exe /bootstrap
# ENTRYPOINT ["/bootstrap"]