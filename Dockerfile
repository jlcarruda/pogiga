FROM alpine:latest

COPY --from=golang:1.13-alpine /usr/local/go/ /usr/local/go/
ENV GOROOT="/usr/local/go" \
 GOPATH="/root/go" \
 PATH="${GOROOT}/bin:${PATH}" \
 ZSH_CUSTOM="/root/.oh-my-zsh/custom"

USER root
WORKDIR /app

# Install dependencies
RUN mkdir -p $GOPATH/src && \
 apk update && apk upgrade && apk add age openssh wget ansible aws-cli vim nano zip git py3-pip pipx zsh fzf ripgrep cosign gpg curl gcc ethtool

# Download TF
RUN wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip -O terraform.zip && \
 unzip terraform.zip && rm terraform.zip && \
 mv terraform /usr/local/bin/terraform

# OHMYZSH install
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting && \
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

# TOFU install
RUN wget --secure-protocol=TLSv1_2 --https-only https://get.opentofu.org/install-opentofu.sh -O install-opentofu.sh && \
 chmod +x install-opentofu.sh && \
 ./install-opentofu.sh --install-method standalone && \
 rm install-opentofu.sh

# PACU install
RUN mkdir -p ~/tools/pacu && git clone https://github.com/RhinoSecurityLabs/pacu.git ~/tools/pacu && \
 pipx install ~/tools/pacu

# SOPS
RUN curl -LO https://github.com/getsops/sops/releases/download/v3.8.1/sops-v3.8.1.linux.amd64 && \
 mv sops-v3.8.1.linux.amd64 /usr/local/bin/sops && \
 chmod +x /usr/local/bin/sops

# KUBECTL
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
 curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" && \
 echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c && \
 install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
 kubectl version --client

COPY dotfiles/ /root/

CMD [ "zsh" ]
