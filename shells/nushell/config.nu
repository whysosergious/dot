
#¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
####.nu_config
#_______________



#¯¯¯¯¯¯¯¯¯¯¯
##.aliases
#___________


alias pv = nvim
alias pm = pnpm
alias z = zoxide_z
alias zi = zoxide_zi
alias trs = tree-sitter



####
## TODO: nvim keybindings
## '#' qucksearch word under curson (n for next match) 
## '"_' blackhole register
## 'C-r' redo and most C -> Alt
####



#¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
##.custom_commands
#____________________


# short-hand for 'ls -d' for --du as in size.
def lsd [--asc (-r)] {
  if ($asc == true) {
    ls --du -a | sort-by size -r
  } else {
    ls --du -a | sort-by size
  }
}





# check and create a directory if it doesn't exist
export def ensure_path_exists [path: string, create_missing: bool = true] {
    if not ($path | path exists) {
        if $create_missing {
            mkdir $path
        }
    }
}


# shred path for np thing (persistance, registers, history, etc). anithing that is written by processes.
# should also be the first place that is being checked on any init. register if the process is new or load state or whatever.
$env.NP_RNT = "~/.np_rnt/"


# init np structures if $env.NP_RNT path doesn't exist
ensure_path_exists $env.NP_RNT


## test sourcing
source "~/AppData/Roaming/nushell/helpers.nu"

## use plugins
source "~/AppData/Roaming/nushell/plugins/os.nu"
source "~/AppData/Roaming/nushell/plugins/task.nu"

## source modules
source "~/AppData/Roaming/nushell/modules/np/mod.nu" 

# Source the carapace init script
source "~/.cache/carapace/init.nu"

# Set up the default configuration 
let config = {: suorce
  rm: {
    always_trash: false
  },
  table: {
    mode: "rounded",
    index_mode: "always",
    show_empty: true,
    padding: { left: 1, right: 1 },
    trim: {
      methodology: "wrapping",
      wrapping_try_keep_words: true,
      truncating_suffix: "…"
    },
    header_on_separator: true
  },
  error_style: "fancy",
  datetime_format: {},
  explore: {
    status_bar_background: { fg: "#1D1F21", bg: "#C4C9C6" }
    command_bar_text: { fg: "#C4C9C6" },
    highlight: { fg: "black", bg: "yellow" },
    status: {
      error: { fg: "white", bg: "red" },
      warn: {},
      info: {}
    },
    table: {
      split_line: { fg: "#404040" },
      selected_cell: { bg: "light_blue" },
      selected_row: {},
      selected_column: {},
    },
  }
 history: {
    max_size: 10_000,
    sync_on_enter: true,
    file_format: "plaintext",
    isolation: false
  },
  completions: {
    case_sensitive: false,
    quick: true,
    partial: true,
    algorithm: "fuzzy",
    external: {
      enable: true,
      max_results: 100,
      completer: {| spans |
        carapace $spans.- 1 nushell $spans | from json
      }
    }
  },
  filesize: {
    metric: false,
    format: "auto"
  },
  cursor_shape: {
    vi_insert: "blink_line",
    vi_normal: "block"
  },
  color_config: {},
  use_grid_icons: true,
  footer_mode: "25",
  float_precision: 2,
  buffer_editor: "nvim",
  use_ansi_coloring: true,
  bracketed_paste: false,
  edit_mode: "vi",
  shell_integration: true,
  render_right_prompt_on_last_line: true,
  use_kitty_protocol: false,
  hooks: {},
  menus: []
}



$env.config = {
  show_banner: false,
  completions: {
        case_sensitive: false # set to true to enable case-sensitive completions
        quick: true    # set this to false to prevent auto-selecting completions when only one remains
        partial: true    # set this to false to prevent partial filling of the prompt
        algorithm: "fuzzy"    # prefix or fuzzy
        external: {
            enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up may be very slow
            max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
            completer: {|spans|
     carapace $spans.0 nushell ...$spans | from json
 } # check 'carapace_completer' above as an example
        }
    }
}



const color_palette = {
    rosewater: "#f5e0dc"
    flamingo: "#f2cdcd"
    pink: "#f5c2e7"
    mauve: "#cba6f7"
    red: "#f38ba8"
    maroon: "#eba0ac"
    peach: "#fab387"
    yellow: "#f9e2af"
    green: "#a6e3a1"
    teal: "#94e2d5"
    sky: "#89dceb"
    sapphire: "#74c7ec"
    blue: "#89b4fa"
    lavender: "#b4befe"
    text: "#cdd6f4"
    subtext1: "#bac2de"
    subtext0: "#a6adc8"
    overlay2: "#9399b2"
    overlay1: "#7f849c"
    overlay0: "#6c7086"
    surface2: "#585b70"
    surface1: "#45475a"
    surface0: "#313244"
    base: "#1e1e2e"
    mantle: "#181825"
    crust: "#11111b"
}

export def main [] { return {
    separator: $color_palette.overlay0
    leading_trailing_space_bg: { attr: "n" }
    header: { fg: $color_palette.blue attr: "b" }
    empty: $color_palette.lavender
    bool: $color_palette.lavender
    int: $color_palette.peach
    duration: $color_palette.text
    filesize: {|e|
          if $e < 1mb {
            $color_palette.green
        } else if $e < 100mb {
            $color_palette.yellow
        } else if $e < 500mb {
            $color_palette.peach
        } else if $e < 800mb {
            $color_palette.maroon
        } else if $e > 800mb {
            $color_palette.red
        }
    }
    date: {|| (date now) - $in |
        if $in < 1hr {
            $color_palette.green
        } else if $in < 1day {
            $color_palette.yellow
        } else if $in < 3day {
            $color_palette.peach
        } else if $in < 1wk {
            $color_palette.maroon
        } else if $in > 1wk {
            $color_palette.red
        }
    }
    range: $color_palette.text
    float: $color_palette.text
    string: $color_palette.text
    nothing: $color_palette.text
    binary: $color_palette.text
    cellpath: $color_palette.text
    row_index: { fg: $color_palette.mauve attr: "b" }
    record: $color_palette.text
    list: $color_palette.text
    block: $color_palette.text
    hints: $color_palette.overlay1
    search_result: { fg: $color_palette.red bg: $color_palette.text }

    shape_and: { fg: $color_palette.pink attr: "b" }
    shape_binary: { fg: $color_palette.pink attr: "b" }
    shape_block: { fg: $color_palette.blue attr: "b" }
    shape_bool: $color_palette.teal
    shape_custom: $color_palette.green
    shape_datetime: { fg: $color_palette.teal attr: "b" }
    shape_directory: $color_palette.teal
    shape_external: $color_palette.teal
    shape_externalarg: { fg: $color_palette.green attr: "b" }
    shape_filepath: $color_palette.teal
    shape_flag: { fg: $color_palette.blue attr: "b" }
    shape_float: { fg: $color_palette.pink attr: "b" }
    shape_garbage: { fg: $color_palette.text bg: $color_palette.red attr: "b" }
    shape_globpattern: { fg: $color_palette.teal attr: "b" }
    shape_int: { fg: $color_palette.pink attr: "b" }
    shape_internalcall: { fg: $color_palette.teal attr: "b" }
    shape_list: { fg: $color_palette.teal attr: "b" }
    shape_literal: $color_palette.blue
    shape_match_pattern: $color_palette.green
    shape_matching_brackets: { attr: "u" }
    shape_nothing: $color_palette.teal
    shape_operator: $color_palette.peach
    shape_or: { fg: $color_palette.pink attr: "b" }
    shape_pipe: { fg: $color_palette.pink attr: "b" }
    shape_range: { fg: $color_palette.peach attr: "b" }
    shape_record: { fg: $color_palette.teal attr: "b" }
    shape_redirection: { fg: $color_palette.pink attr: "b" }
    shape_signature: { fg: $color_palette.green attr: "b" }
    shape_string: $color_palette.green
    shape_string_interpolation: { fg: $color_palette.teal attr: "b" }
    shape_table: { fg: $color_palette.blue attr: "b" }
    shape_variable: $color_palette.pink

    background: $color_palette.base
    foreground: $color_palette.text
    cursor: $color_palette.blue
}}






# source nu-hooks/filesystem/autojump.nu
source ~/nupm/.zoxide.nu

## - script modules
use ~/AppData\Roaming\nushell/gen_json_schema.nu




# $env.config.hooks.env_change.PWD = (
# $env.config.hooks.env_change.PWD | append (source nu-hooks/direnv/config.nu)
# )




if ($env | to text | str contains NU_SOURCED_CONFIG) == false {
  
  # print "sourced config"
$env.NU_SOURCED_CONFIG = true

if ($env | to text | str contains NU_SOURCED_ENV) == false {
  source $nu.env-path
}


}
use C:\Users\sergi\AppData\Roaming\dystroy\broot\config\launcher\nushell\br 
$env.NU_SOURCED_CONFIG = true


## extraterm
source extraterm.nu
