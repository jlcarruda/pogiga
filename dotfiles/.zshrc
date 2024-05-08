export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
export AWS_PROFILE=$(head -1 ~/.aws/credentials | tr -d '[]')

plugins=(
  ansible
  aws
  bgnotify
  colorize
  fzf
  git
  kubectl
  pipenv
  ripgrep
  terraform
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

alias pacu="pipx runpip pacu"

# Auto terraform init
if [ ! -d "/app/.terraform" ] && ls -la /app | grep -q tf; then
  tf init
fi

if [[ -z ${SOPS_KMS_ARN} ]]; then
  while IFS= read -r -d '' file; do
    if [[ $file == *.sops.* ]]; then
      export SOPS_KMS_ARN=$(cat $file | awk '/arn: / {print $3}');
      echo "SOPS file detected. Setted KMS ARN as environment variable";
      break;
    fi
  done <<(find "$(pwd)" -type f -print0)
fi
