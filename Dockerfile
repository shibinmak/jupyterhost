FROM python:3.7-slim
LABEL maintainer="Shibin mak <shibin.mak@mozanta.com>"

ENV PYTHONDONTWRITEBYTECODE=1\
  PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  POETRY_VERSION=1.0.0 \
  BUILD_DEPS="supervisor" \
  APP_DEPS="curl"


RUN apt-get update \
    && apt-get install -y ${BUILD_DEPS} ${APP_DEPS} --no-install-recommends \
    && pip install "poetry==$POETRY_VERSION" \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/doc && rm -rf /usr/share/man \
    && apt-get purge -y --auto-remove  \
    && apt-get clean


WORKDIR /code
COPY poetry.lock pyproject.toml /code/

# Project initialization:
RUN poetry config virtualenvs.create false \
  && poetry install  --no-interaction --no-ansi
CMD ["jupyter", "notebook", "--generate-config"]
# Creating folders, and files for a project:
COPY . /code