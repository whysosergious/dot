
# quick-env & cfg file for non-interactive shells/instances
# $nu.init-path = ($nu.default-config-dir | path join 'init.nu')

# TODO: login.nu cfg
# TODO: init.nu - quick sourcing deps


def create_left_prompt [] {

     let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
         null => $env.PWD
         '' => '~'
         $relative_pwd => ([~ $relative_pwd] | path join)
     }
    
     let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
     let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
     let path_segment = $"($path_color)($dir)"
    
     $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
    
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)' 
}
 


def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }

 $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }


# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = "› "
$env.PROMPT_INDICATOR_VI_NORMAL = "∥ "
$env.PROMPT_MULTILINE_INDICATOR = ":: "






export-env {
    let esep_list_converter = {
        from_string: { |s| $s | split row (char esep) }
        to_string: { |v| $v | str join (char esep) }
    }

    $env.ENV_CONVERSIONS = {
        XDG_DATA_DIRS: $esep_list_converter
        TERMINFO_DIRS: $esep_list_converter
    }
}

export-env { load-env {
    # XDG_DATA_HOME: ($env.HOME | path join ".local" "share")
    XDG_DATA_HOME: ($env.HOME | path join ".local" "share")
    # XDG_CONFIG_HOME: ($env.HOME | path join ".config")
    XDG_CONFIG_HOME: ($env.HOME | path join "AppData/Roaming")
    # XDG_STATE_HOME: ($env.HOME | path join ".local" "state")
    XDG_CACHE_HOME: ($env.HOME | path join ".cache")
    # XDG_DOCUMENTS_DIR: ($env.HOME | path join "documents")
    XDG_DOWNLOAD_DIR: ($env.HOME | path join "downloads")
    # XDG_MUSIC_DIR: ($env.HOME | path join "media" "music")
    # XDG_PICTURES_DIR: ($env.HOME | path join "media" "images")
    # XDG_VIDEOS_DIR: ($env.HOME | path join "media" "videos")
}}





$env.TERMINFO_DIRS = (
    [
        ($env.XDG_DATA_HOME | path join "terminfo")
        "/usr/share/terminfo"
    ]
    | str join ":"
)



export-env { 
  load-env {
    # CABAL_CONFIG: ($env.XDG_CONFIG_HOME | path join "cabal" "config")
    # CABAL_DIR: ($env.XDG_DATA_HOME | path join "cabal")
    CARGO_HOME: ($env.XDG_DATA_HOME | path join "cargo")
    # CLANG_HOME: ($env.XDG_DATA_HOME | path join "clang-15")
    DOOMDIR: ($env.XDG_CONFIG_HOME | path join "doom")
    # EMACS_HOME: ($env.HOME | path join ".emacs.d")
    # GNUPGHOME: ($env.XDG_DATA_HOME | path join "gnupg")
    # GOPATH: ($env.XDG_DATA_HOME | path join "go")
    # GRIPHOME: ($env.XDG_CONFIG_HOME | path join "grip")
    # GTK2_RC_FILES: ($env.XDG_CONFIG_HOME | path join "gtk-2.0" "gtkrc")
    HISTFILE: ($env.XDG_STATE_HOME | path join "bash" "history")
    IPFS_PATH: ($env.HOME | path join ".ipfs")
    JUPYTER_CONFIG_DIR: ($env.XDG_CONFIG_HOME | path join "jupyter")
    # KERAS_HOME: ($env.XDG_STATE_HOME | path join "keras")
    # LESSHISTFILE: ($env.XDG_CACHE_HOME | path join "less" "history")
    # MUJOCO_BIN: ($env.HOME | path join ".mujoco" "mujoco210" "bin")
    # NODE_REPL_HISTORY: ($env.XDG_DATA_HOME | path join "node_repl_history")
    # NPM_CONFIG_USERCONFIG: ($env.XDG_CONFIG_HOME | path join "npm" "npmrc")
    # NUPM_CACHE: ($env.XDG_CACHE_HOME | path join "nupm")
    # NUPM_HOME: ($env.XDG_DATA_HOME | path join "nupm")
    PASSWORD_STORE_DIR: ($env.XDG_DATA_HOME | path join "pass")
    # PYTHONSTARTUP: ($env.XDG_CONFIG_HOME | path join "python" "pythonrc")
    # QT_QPA_PLATFORMTHEME: "qt5ct"
    QUICKEMU_HOME: ($env.XDG_DATA_HOME | path join "quickemu")
    # RUBY_HOME: ($env.XDG_DATA_HOME | path join "gem" "ruby" $env.GEM_VERSION)
    RUSTUP_HOME: ($env.XDG_CONFIG_HOME | path join "rustup")
    SQLITE_HISTORY: ($env.XDG_CACHE_HOME | path join "sqlite_history")
    SSH_AGENT_TIMEOUT: 300
    SSH_KEYS_HOME: ($env.HOME | path join ".ssh" "keys")
    TERMINFO: ($env.XDG_DATA_HOME | path join "terminfo")
    # TOMB_HOME: ($env.XDG_DATA_HOME | path join "tombs")
    # WORKON_HOME: ($env.XDG_DATA_HOME | path join "virtualenvs")
    XINITRC: ($env.XDG_CONFIG_HOME | path join "X11" "xinitrc")
    ZDOTDIR: ($env.XDG_CONFIG_HOME | path join "zsh")
    # ZELLIJ_LAYOUTS_HOME: ($env.GIT_REPOS_HOME | path join "github.com" "amtoine" "zellij-layouts" "layouts")
    # ZK_NOTEBOOK_DIR: ($env.GIT_REPOS_HOME | path join "github.com" "amtoine" "notes")
    # _JAVA_OPTIONS: $"-Djava.util.prefs.userRoot=($env.XDG_CONFIG_HOME | path join java)"
    _Z_DATA: ($env.XDG_DATA_HOME | path join "z")
}}

# load secret environment variables
export-env {
    let env_file = $nu.home-path | path join ".env"
    if ($env_file | path exists) {
        open $env_file | from nuon | load-env
    }
}

use std "path add"




$env.PATH = ($env.PATH | split row ":")


# path add /nix/var/nix/profiles/default/bin
path add ($env.XDG_DATA_HOME | path join "npm" "bin")

export-env {
($env.HOME  | path join ".cargo")
($env.CARGO_HOME | path join "bin")
# path add ($env.CLANG_HOME | path join "bin")
# path add ($env.GOPATH | path join "bin")
# path add ($env.EMACS_HOME | path join "bin")
# path add ($env.RUBY_HOME | path join "bin")
# path add ($env.NUPM_HOME | path join "scripts")
# path add ($env.XDG_STATE_HOME | path join "nix/profile/bin")
# path add ($env.HOME | path join ".local" "bin")
}

$env.PATH = ($env.PATH | uniq)

# $env.LD_LIBRARY_PATH = (
#     $env.LD_LIBRARY_PATH?
#         | default ""
#         | split row (char esep)
#         | prepend $env.MUJOCO_BIN
#         | uniq
# )


$env.EDITOR = nvim
$env.VISUAL = nvim

$env.STARSHIP_SHELL = nu


# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}







# $env.config = ($env.config | upsert hooks.env_change.PWD {
#     [
#         {
#             condition: {|_, after|
#                 ($after == '/path/to/target/dir'
#                     and ($after | path join test-env.nu | path exists))
#             }
#             code: "overlay use test-env.nu"
#         }
#         {
#             condition: {|before, after|
#                 ('/path/to/target/dir' not-in $after
#                     and '/path/to/target/dir' in $before
#                     and 'test-env' in (overlay list))
#             }
#             code: "overlay hide test-env --keep-env [ PWD ]"
#         }
#     ]
# })
# Nushell Environment Config File
#
# version = "0.91.1"



# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }



# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts

# nushell lib
$env.NU_LIB_DIRS = [
  ($nu.default-config-dir | path join 'repo_scripts') # add <nushell-config-dir>/repo_scripts
  #repo_modules
  ($nu.default-config-dir | path join 'repo_modules') # add <nushell-config-dir>/repo_modules
  #completions
  ($nu.default-config-dir | path join 'completions') # add <nushell-config-dir>/completions
  #nu-hooks
  ($nu.default-config-dir | path join 'nu-hooks') # add <nushell-config-dir>/nu-hooks
  #modules
  ($nu.default-config-dir | path join 'modules') # add <nushell-config-dir>/modules
  #scripts
  ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]


$env.CARGO_HOME = ($env.XDG_DATA_HOME | path join ".cargo")
# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($env.CARGO_HOME | path join "bin")
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
# use std "path add" 
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
# path add ($env.CARGO_HOME | path join "bin")
# path add ($env.HOME | path join ".local" "bin")
# $env.PATH = ($env.PATH | uniq)

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')


# $env.SHELL = nu
$env.SHELL = $nu.current-exe

# $env.GPG_TTY = (tty)


# zoxide
mkdir ~/.cache/zoxide
zoxide init nushell | save -f ~/.cache/zoxide/init.nu

# starship
# mkdir ~/.cache/starship
# starship init nu | save -f ~/.cache/starship/init.nu


# carapace
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
