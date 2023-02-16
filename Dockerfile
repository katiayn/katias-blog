ARG PYTHON_VERSION=3.10-slim-buster

FROM python:${PYTHON_VERSION}

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN mkdir -p /code

WORKDIR /code

# install psycopg2 dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*  # <-- Updated!

COPY requirements.txt /tmp/requirements.txt

RUN set -ex && \
    pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm -rf /root/.cache/

COPY . /code/

# Set SECRET_KEY for building purposes
# ENV SECRET_KEY "non-secret-key-for-building-purposes"  # <-- Updated!
RUN python manage.py collectstatic --noinput

EXPOSE 8000

# Updated!
CMD ["gunicorn", "--bind", ":8000", "--workers", "2", "website.wsgi"]
