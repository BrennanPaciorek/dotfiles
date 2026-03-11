if [ ! -S ~/.ssh/ssh_auth_sock ]
  set -l SSH_AUTH_DIR "/tmp/ssh-XXXXXXX/agent.$fish_pid"
  mkdir -p $SSH_AUTH_DIR
  set SSH_AUTH_SOCK "$SSH_AUTH_DIR/agent.$fish_pid"
  ssh-agent -a "$SSH_AUTH_SOCK" 1> /dev/null
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
end

set SSH_AUTH_SOCK $HOME/.ssh/ssh_auth_sock
