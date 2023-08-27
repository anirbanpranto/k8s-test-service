FROM python:3.10
RUN apt-get update -y && apt-get upgrade -y

WORKDIR /app
COPY requirements.txt .
COPY config.yaml .

# install ssh to access github
RUN  apt-get -yq update && \
     apt-get -yqq install ssh git
# install alertbot
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN --mount=type=ssh pip install git+ssh://git@github.com/tapway/alertbot.git
RUN pip install boto3

RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .

# sets the runtime CURRENT_ENV value using the value passed in during build-time, i.e.
# `docker build --build-arg BUILD_TIME_CURRENT_ENV=prod -t bla:latest .`
ARG BUILD_TIME_CURRENT_ENV=dev
ENV CURRENT_ENV=$BUILD_TIME_CURRENT_ENV

CMD ["python", "app.py"]