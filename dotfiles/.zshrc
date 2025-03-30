export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
eval $(ssh-agent) 1&>/dev/null
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

# source "$ZSH/oh-my-zsh.sh"

alias pacu="pipx runpip pacu"

# # Auto terraform init
# if [ ! -d "/app/.terraform" ] && ls -la /app | grep -q tf; then
#   tf init
# fi

# # Auto initialize 
# declare -A valid_configs
# valid_configs=( ["env_aws_profile"]="AWS_PROFILE" ["env_kms_arn"]="SOPS_KMS_ARN")
# if [ -f "/app/.pogiga" ]; then
#   while IFS== read -r key value; do
#     # IFS=_ read -ra key_splitted <<< $key
#     # variable_type=$key_splitted[0];
#     # fi
#     key=`echo $key | sed 's/ *$//g'`;
#     if [[ -z ${valid_configs[${key}]} ]]; then
#       echo "Invalid $key on .pogiga file. Ignoring..."
#       continue;
#     fi;
#     env_var=`echo $valid_configs[$key]`
#     value=`echo $value | sed 's/ *$//g'`;
#     export "$env_var"="$value";  
#   done </app/.pogiga
# fi

# # Set SOPS_KMS_ARN based on files if no options was passed
# if [[ -z ${SOPS_KMS_ARN} ]]; then
#   while IFS= read -r -d '' file; do
#     if [[ $file == *.sops.* ]]; then
#       export SOPS_KMS_ARN=$(cat $file | awk '/arn: / {print $3}');
#       echo "SOPS file detected. Setted KMS ARN as environment variable";
#       break;
#     fi
#   done <<<(find "$(pwd)" -type f -print0)
# fi
