#!/usr/bin/env bash

set -e
set -u
set -o pipefail
set -x

####################
# Variables
####################
DEBIAN_FRONTEND="noninteractive"

CFN_LINT_VERSION="0.58.0" # https://github.com/aws-cloudformation/cfn-lint/releases
AWSCLI_VERSION="2.4.14" # https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst
KUBECTL_VERSION="v1.23.3" # https://storage.googleapis.com/kubernetes-release/release/stable.txt
KUBELINTER_VERSION="0.2.5" # https://github.com/stackrox/kube-linter/releases
HELM_VERSION="v3.8.0" # https://github.com/helm/helm/releases
TERRAFORM_VERSION="1.1.4" # https://github.com/hashicorp/terraform/releases
TERRAGRUNT_VERSION="v0.36.1" # https://github.com/gruntwork-io/terragrunt/releases
TFLINT_VERSION="v0.34.1" # https://github.com/terraform-linters/tflint/releases
TFSEC_VERSION="v1.0.8" # https://github.com/aquasecurity/tfsec/releases

####################
# Functions
####################
setArch() {
  if [[ "$( uname -m )" == "x86_64" ]]; then
    export ARCH="$( uname -m )"
    export ALT_ARCH="amd64"
  elif [[ "$( uname -m )" == "aarch64" ]]; then
    export ARCH="$( uname -m )"
    export ALT_ARCH="arm64"
  else
    echo "$( uname -m ) is not supported - Exiting."
    exit 1
  fi
}

initialiseApt() {
  apt update
  apt upgrade --yes
  apt install --yes \
    apt-transport-https \
    ca-certificates \
    curl \
    lsb-release
}

aptPackages() {
  apt install --yes \
    python3 \
    python3-pip
}

pipPackages() {
  python3 -m pip install --upgrade pip
  python3 -m pip install --no-cache \
    cfn-lint==${CFN_LINT_VERSION}
}

awsCli() {
  curl https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}-${AWSCLI_VERSION}.zip \
    --output awscliv2.zip
  unzip -q awscliv2.zip
  bash aws/install
  rm --force --recursive aws awscliv2.zip
}

kubectl() {
  curl --location https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ALT_ARCH}/kubectl \
    --output /usr/local/bin/kubectl
  chmod +x /usr/local/bin/kubectl
}

helm() {
  curl --location https://get.helm.sh/helm-${HELM_VERSION}-linux-${ALT_ARCH}.tar.gz \
    --output helm-${HELM_VERSION}-linux-${ALT_ARCH}.tar.gz
  tar --gzip --extract --verbose --file helm-${HELM_VERSION}-linux-${ALT_ARCH}.tar.gz
  mv linux-${ALT_ARCH}/helm /usr/local/bin/helm
  rm --force --recursive linux-${ALT_ARCH} helm-${HELM_VERSION}-linux-${ALT_ARCH}.tar.gz
}

kubeLinter() {
  curl --location https://github.com/stackrox/kube-linter/releases/download/${KUBELINTER_VERSION}/kube-linter-linux.zip \
    --output kube-linter-linux.zip
  unzip -q kube-linter-linux.zip
  mv kube-linter /usr/local/bin/kube-linter
  rm --force --recursive kube-linter-linux.zip
}

terraform() {
  curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ALT_ARCH}.zip \
    --output terraform.zip
  unzip -q terraform.zip
  mv terraform /usr/local/bin/terraform
  rm --force --recursive terraform.zip
}

terragrunt() {
  curl --location https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_${ALT_ARCH} \
    --output /usr/local/bin/terragrunt
  chmod +x /usr/local/bin/terragrunt
}

tflint() {
  curl --location https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_${ALT_ARCH}.zip \
    --output tflint_linux_${ALT_ARCH}.zip
  unzip -q tflint_linux_${ALT_ARCH}.zip
  mv tflint /usr/local/bin/tflint
  rm --force --recursive tflint_linux_${ALT_ARCH}.zip
}

tfsec() {
  curl --location https://github.com/aquasecurity/tfsec/releases/download/${TFSEC_VERSION}/tfsec-linux-${ALT_ARCH} \
    --output /usr/local/bin/tfsec
  chmod +x /usr/local/bin/tfsec
}

cleanup() {
  rm --force --recursive /var/lib/{apt,dpkg}
}

####################
# Main
####################
setArch
# initialiseApt
# aptPackages
# pipPackages
# awsCli
# kubectl
# helm
# kubeLinter
# terraform
# terragrunt
# tflint
# tfsec
# cleanup