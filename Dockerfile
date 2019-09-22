FROM amazonlinux:2.0.20190823.1

LABEL maintainer="Dave Masino <davem@slalom.com>"

ARG PYTHON_VERSION=3.7.3
ARG DBT_VERSION=0.14.2

ENV DBT_HOME /dbt
ENV PYENV_ROOT ${DBT_HOME}/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN set -ex \
    && yum update -y \
    && yum install git gcc tar make -y \
    && yum install zlib-devel libffi-devel bzip2-devel readline-devel openssl-devel -y \
    && useradd -ms /bin/bash -d ${DBT_HOME} dbt \
    && git clone https://github.com/pyenv/pyenv.git ${DBT_HOME}/.pyenv \
    && pyenv install $PYTHON_VERSION \
    && pyenv global $PYTHON_VERSION \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir dbt==${DBT_VERSION} \
    && yum clean all \
    && yum autoremove gcc tar make -y \
    && yum autoremove zlib-devel libffi-devel bzip2-devel readline-devel openssl-devel -y \
    && rm -rf \
        /tmp/* \
        /var/tmp/* \
        /var/cache/yum \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base \
    && chown -R dbt:dbt ${DBT_HOME}

USER dbt
WORKDIR ${DBT_HOME}
