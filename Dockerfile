FROM python:3.11-bookworm

RUN     pip3 install --upgrade pip \
    &&  mkdir -p /opt/project

WORKDIR /opt/project

COPY requirements.in Makefile ./
RUN make apt-install
RUN make pip-install

CMD ["python3", "-m", "project_deb.main"]
