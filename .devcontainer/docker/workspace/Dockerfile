# mac
FROM ubuntu:22.04

ARG USER_NAME
ARG USER_GROUP_NAME
ARG USER_UID
ARG USER_GID

LABEL maintainer="mizuki"
LABEL version="1.0"
LABEL description="my-workspace"

# general packages
ARG PKG="vim curl unzip zip sudo tzdata git"

SHELL ["/bin/bash", "-c"]

# ---------------------------------- set up user ----------------------------------

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo TZ > /etc/timezone

RUN apt-get update \
    && apt-get install -y ${PKG} \
    && groupadd --gid ${USER_GID} ${USER_GROUP_NAME} \
    && useradd --uid ${USER_UID} --shell /bin/bash --gid ${USER_GID} -m ${USER_NAME} \
    && echo %${USER_GROUP_NAME} ALL=\(ALL\) NOPASSWD:ALL > /etc/sudoers.d/${USER_GROUP_NAME} \
    && chmod 0440 /etc/sudoers.d/${USER_GROUP_NAME}

USER ${USER_NAME}

ENV HOME=/home/${USER_NAME}

WORKDIR ${HOME}

# ---------------------------------- sdkman for java/kotlin ----------------------------------

ARG JAVA_VERSION
ARG GRADLE_VERSION
ARG MAVEN_VERSION
ARG KOTLIN_VERSION

RUN curl -s "https://get.sdkman.io" | bash \
    && source "${HOME}/.sdkman/bin/sdkman-init.sh" \
    && sdk install java ${JAVA_VERSION} \
    && sdk install gradle ${GRADLE_VERSION} \
    && sdk install maven ${MAVEN_VERSION} \
    && sdk install kotlin ${KOTLIN_VERSION} \
    && java --version


# ---------------------------------- pyenv for python ----------------------------------

ARG PYENV_DEP="make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget llvm libncurses5-dev \
    libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl"

RUN sudo apt-get update -y \
    && sudo apt-get install -y --no-install-recommends ${PYENV_DEP}

ARG PYTHON_VERSION

ENV PYENV_ROOT=${HOME}/.pyenv

RUN curl https://pyenv.run | bash \
    && echo 'export PYENV_ROOT="${HOME}/.pyenv"' >> ${HOME}/.bashrc \
    && echo 'export PATH="${PYENV_ROOT}/bin:${PATH}"' >> ${HOME}/.bashrc \
    && echo 'eval "$(pyenv init --path)"' >> ${HOME}/.bashrc \
    && export PATH="${PYENV_ROOT}/bin:${PATH}" \
    && eval "$(pyenv init --path)" \
    && pyenv install "${PYTHON_VERSION}" \
    && pyenv global "${PYTHON_VERSION}" 

# ---------------------------------- nvm for node and aws cdk ----------------------------------

ARG NODE_VERSION

ARG NODE_GLOBAL_PKG="prettier cdk"

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && source "${HOME}/.nvm/nvm.sh" \
    && nvm install ${NODE_VERSION} \
    && npm update -g \
    && npm i --global ${NODE_GLOBAL_PKG}

# ---------------------------------- gvm for go lang ----------------------------------

# TODO: fix how to install gvm cause of version change
# やっぱりGoはまだ安定してないなぁ。。。。。。。

# ARG GO_VERSION

# ENV GVM_ROOT ${HOME}/.gvm
# ENV GOPATH ${HOME}/go
# ENV GOROOT ${GVM_ROOT}/gos/go${GO_VERSION}

# RUN sudo apt-get install bison bsdmainutils -y \
#     && bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer) \
#     && echo 'export PATH="${GOROOT}/bin:${GOPATH}/bin:${PATH}"' >> ${HOME}/.bashrc \
#     && source ${GVM_ROOT}/scripts/gvm \
#     && gvm install go1.4 -B \
#     && gvm use go1.4 \
#     && gvm install go${GO_VERSION} \
#     && gvm use go${GO_VERSION} --default \
#     && go install -v golang.org/x/tools/gopls@latest \
#     && go install -v github.com/go-delve/delve/cmd/dlv@latest

# ---------------------------------- set up z ----------------------------------

RUN git clone https://github.com/rupa/z.git ~/.z-sh \
    && echo '. $HOME/.z-sh/z.sh' >> ~/.bashrc

USER root

# ---------------------------------- latest c c++ compiler ----------------------------------

ARG LATEST_C_VERSION

RUN apt-get -y install gcc-${LATEST_C_VERSION} g++-${LATEST_C_VERSION} \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-${LATEST_C_VERSION} ${LATEST_C_VERSION} \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-${LATEST_C_VERSION} ${LATEST_C_VERSION}

# ---------------------------------- set up language ----------------------------------

ARG LOCALE
ENV LOCALE=${LOCALE}
ENV LC_ALL=${LOCALE}
ENV LANG=${LOCALE}

RUN apt-get -y install locales \
    && echo "LC_ALL=${LOCALE}" >> /etc/environment \
    && echo "${LOCALE} UTF-8" >> /etc/locale.gen \
    && echo "LANG=${LOCALE}" > /etc/locale.conf \
    && locale-gen ${LOCALE}

# ---------------------------------- aws cli ----------------------------------

ARG ZIP_FILE=awscliv2.zip
ARG BE_PATH_TO_COMPLETER=/usr/local/bin

RUN apt-get install -y less \
    && curl https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip -o ${ZIP_FILE} \
    && unzip ${ZIP_FILE} \
    && ./aws/install \
    && rm -f ${ZIP_FILE} \
    && echo 'export PATH="${BE_PATH_TO_COMPLETER}:${PATH}"' >> ${HOME}/.bashrc \
    && source ${HOME}/.bashrc \
    && complete -C "${BE_PATH_TO_COMPLETER}/aws_completer" aws

# ---------------------------------- github cli ----------------------------------

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install gh -y \
    && gh --version

# ---------------------------------- aws sam cli ----------------------------------

ARG SAM_ZIP_FILE=aws-sam-cli-linux-arm64.zip

RUN curl -sSL https://github.com/aws/aws-sam-cli/releases/latest/download/${SAM_ZIP_FILE} -o ${SAM_ZIP_FILE} \
    && unzip ${SAM_ZIP_FILE} -d sam-installation \
    && ./sam-installation/install \
    && rm -f ${SAM_ZIP_FILE} \
    && sam --version

# ---------------------------------- addtional packages ----------------------------------

ARG ADDITONAL_PKG="iputils-ping lsof tree jq uuid-runtime"

RUN apt-get update -y \
    && apt-get install ${ADDITONAL_PKG} -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*