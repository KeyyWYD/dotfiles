# config.nu

export-env {
  if ("once" not-in $env) {
    load-env {
      PATH: (
        $env.PATH
        | split row (char esep)
        | prepend [
            ($env.HOME | path join ".cargo" "bin")
            ($env.HOME | path join ".local" "bin")
            ($env.HOME | path join ".config" "nushell" "bin")
          ]
      )
      EDITOR: "nano"
      LC_ALL: "en_US.UTF-8"
      LANG: "en_US.UTF-8"
      SUDO_PROMPT: $"Deploying (ansi red)root access(ansi reset) for (ansi blue)($env.USER)(ansi reset),\nEnter Password: "
    }
  }
}

$env.config = {
    table: {
        mode: compact
    }

    history: {
        max_size: 10_000 # Session has to be reloaded for this to take effect
        sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
        file_format: "plaintext" # "sqlite" or "plaintext"
        isolation: false # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
    }

}

$env.config.show_banner = false
$env.config.buffer_editor = $"($env.EDITOR)"

if ($env.once? | is-empty) {
    $env.once = "true"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Shell integrations

# neofetch
# fastfetch
# pfetch
# catnap
blocks.nu
fortune -s

source ~/.config/nushell/.zoxide.nu
#source ~/.config/nushell/.oh-my-posh.nu
source ~/.config/nushell/.starship.nu

overlay use  ~/.config/nushell/git/git-aliases.nu
source ~/.config/nushell/git/git-completions.nu

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

### ALIASES
alias cls = clear
alias x = exit

# User Directories
alias home = cd $env.HOME
alias dot = cd $"($env.HOME)/.dotfiles"
alias cfg = cd $"($env.HOME)/.config"
alias dx = cd $"($env.HOME)/Desktop"
alias docs = cd $"($env.HOME)/Documents"
alias dl = cd $"($env.HOME)/Downloads"
alias dev = cd $"($env.HOME)/Projects"

# File Operations and Navigation
def ll [] {ls -al | sort-by size | select name type size mode modified}
def lsd [] {ls | where type == "dir" | table}
alias cat = bat --color=always --paging=never --wrap=never
alias find = e $'(fzf -m --preview="bat --color=always {}")'
alias cd = z

# Pacman
def arch-mirrors [] {
    let mirrors = (rate-mirrors --allow-root --protocol https arch --max-delay=21600 | lines | filter {|line| not ($line | str starts-with "#") })
    $mirrors | str join "\n" | sudo tee /etc/pacman.d/mirrorlist

    yay -Scc
    yay -Syyu --noconfirm
}

alias i = yay -S
alias r = yay -Rns
alias c = yay -Scc
alias u = yay -Syu
alias s = yay -Ss
alias q = yay -Qs

# Generators
def genpwd [x: int = 16] {
    openssl rand -base64 ($x)
}

def gennum [x: int = 1] {
    shuf -i 100000-999999 -n ($x)
}

# System Monitoring
alias free = free -htm
alias jctl = journalctl -p 3 -xb

# Network and System Utilities
alias envlist = printenv
alias hosts = sudo nano /etc/hosts
alias myip = curl ipinfo.io/ip
alias qnet = ping -c 2 archlinux.org

# Chezmoi
alias cz = chezmoi
alias cza = chezmoi apply -v --exclude scripts
alias czcd = chezmoi cd
alias czd = chezmoi diff
alias cze = chezmoi edit
alias czg = chezmoi git
alias czr = chezmoi re-add
alias czs = chezmoi status
alias czi = chezmoi init
alias czu = chezmoi update
