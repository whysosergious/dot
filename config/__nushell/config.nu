
use std "path add"

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
## todo: nvim keybindings
## '#' qucksearch word under curson (n for next match) 
## '"_' blackhole register
## 'c-r' redo and most c -> alt
####



#¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
##.custom_commands
#____________________

## vital for config & env
# add path to env
# export def --env "path add" [path: string = "."] {
#
#   if $nu.os-info.name == "windows" { 
#     $env.path = $env.path
#   } 
#
#   if $path == "." {
#     
#     $env.path = (
#       $env.path
#         | prepend ($env.pwd)
#         | uniq
#       )
#   } else {
#     
#     $env.path = (
#       $env.path
#         | prepend ($nu.home-path | path join $path)
#         | uniq
#       )
#   }
#
#   if $nu.os-info.name == "windows" { 
#     $env.path = $env.path
#   } 
# }


# path
path add .cargo/bin;


# check and create a directory if it doesn't exist
export def ensure_path_exists [path: string, create_missing: bool = true] {
    if not ($path | path exists) {
        if $create_missing {
            mkdir $path
        }
    }
}



# for more information on defining custom themes, see
# https://www.nushell.sh/book/coloring_and_theming.html
# and here is the theme collection
# https://github.com/nushell/nu_scripts/tree/main/themes
let aci = {
    separator: "#b6b6b6"
    leading_trailing_space_bg: { attr: "n" }
    header: { fg: "#83ff08" attr: "b" }
    empty: "#0883ff"
    bool: {|| if $in { "#1eff8e" } else { "light_gray" } }
    int: "#b6b6b6"
    filesize: {|e|
        if $e == 0b {
            "#b6b6b6"
        } else if $e < 1mb {
            "#08ff83"
        } else {{ fg: "#0883ff" }}
    }
    duration: "#b6b6b6"
    date: {|| (date now) - $in |
        if $in < 1hr {
            { fg: "#ff0883" attr: "b" }
        } else if $in < 6hr {
            "#ff0883"
        } else if $in < 1day {
            "#ff8308"
        } else if $in < 3day {
            "#83ff08"
        } else if $in < 1wk {
            { fg: "#83ff08" attr: "b" }
        } else if $in < 6wk {
            "#08ff83"
        } else if $in < 52wk {
            "#0883ff"
        } else { "dark_gray" }
    }
    range: "#b6b6b6"
    float: "#b6b6b6"
    string: "#b6b6b6"
    nothing: "#b6b6b6"
    binary: "#b6b6b6"
    cellpath: "#b6b6b6"
    row_index: { fg: "#83ff08" attr: "b" }
    record: "#b6b6b6"
    list: "#b6b6b6"
    block: "#b6b6b6"
    hints: "dark_gray"
    search_result: { fg: "#ff0883" bg: "#b6b6b6" }

    shape_and: { fg: "#8308ff" attr: "b" }
    shape_binary: { fg: "#8308ff" attr: "b" }
    shape_block: { fg: "#0883ff" attr: "b" }
    shape_bool: "#1eff8e"
    shape_custom: "#83ff08"
    shape_datetime: { fg: "#08ff83" attr: "b" }
    shape_directory: "#08ff83"
    shape_external: "#08ff83"
    shape_externalarg: { fg: "#83ff08" attr: "b" }
    shape_filepath: "#08ff83"
    shape_flag: { fg: "#0883ff" attr: "b" }
    shape_float: { fg: "#8308ff" attr: "b" }
    shape_garbage: { fg: "#ffffff" bg: "#ff0000" attr: "b" }
    shape_globpattern: { fg: "#08ff83" attr: "b" }
    shape_int: { fg: "#8308ff" attr: "b" }
    shape_internalcall: { fg: "#08ff83" attr: "b" }
    shape_list: { fg: "#08ff83" attr: "b" }
    shape_literal: "#0883ff"
    shape_match_pattern: "#83ff08"
    shape_matching_brackets: { attr: "u" }
    shape_nothing: "#1eff8e"
    shape_operator: "#ff8308"
    shape_or: { fg: "#8308ff" attr: "b" }
    shape_pipe: { fg: "#8308ff" attr: "b" }
    shape_range: { fg: "#ff8308" attr: "b" }
    shape_record: { fg: "#08ff83" attr: "b" }
    shape_redirection: { fg: "#8308ff" attr: "b" }
    shape_signature: { fg: "#83ff08" attr: "b" }
    shape_string: "#83ff08"
    shape_string_interpolation: { fg: "#08ff83" attr: "b" }
    shape_table: { fg: "#0883ff" attr: "b" }
    shape_variable: "#8308ff"

    background: "#0d1926"
    foreground: "#b4e1fd"
    cursor: "#b4e1fd"
}




# this completer will use carapace by default
let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell .$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*err$' | is-empty) { $in } else { null }
}


# the default config record. this is where much of your global configuration is setup.
$env.config = ($env.config? | default {} | merge {
  show_banner: false # true or false to enable or disable the welcome banner at startup

    ls: {
        use_ls_colors: true # use the ls_colors environment variable to colorize output
        clickable_links: true # enable or disable clickable links. your terminal has to support links.
    }

    rm: {
        always_trash: false # always act as if -t was given. can be overridden with -p
    }

     table: {
        mode: compact
        index_mode: always
        show_empty: true
        padding: { left: 0, right: 0 }
        header_on_separator: true
            trim: {
            methodology: wrapping # wrapping or truncating
            wrapping_try_keep_words: true # a strategy used by the 'wrapping' methodology
            truncating_suffix: "." # a suffix used by the 'truncating' methodology
        }
        # abbreviated_row_count: 10 # limit data rows from top and bottom after reaching a set point
    }

    error_style: "fancy" # "fancy" or "plain" for screen reader-friendly error messages

    # datetime_format determines what a datetime rendered in the shell would look like.
    # behavior without this configuration point will be to "humanize" the datetime display,
    # showing something like "a day ago."
    datetime_format: {
        # normal: '%a, %d %b %y %h:%m:%s %z'    # shows up in displays of variables or other datetime's outside of tables
        # table: '%m/%d/%y %i:%m:%s%p'          # generally shows up in tabular outputs such as ls. commenting this out will change it to the default human readable datetime format
    }

    explore: {
        status_bar_background: { fg: "#1d1f21", bg: "#c4c9c6" },
        command_bar_text: { fg: "#c4c9c6" },
        highlight: { fg: "black", bg: "yellow" },
        status: {
            error: { fg: "white", bg: "red" },
            warn: {}
            info: {} 
        },
        table: {:w
            split_line: { fg: "#404040" },
            selected_cell: { bg: light_blue },
            selected_row: {},
            selected_column: {},
        },
    }




 

    history: {
        max_size: 10_000 # session has to be reloaded for this to take effect
  
      sync_on_enter: true # enable to share history between multiple sessions, else you have to close the session to write history to file
        file_format: "sqlite" # "sqlite" or "plaintext"
        isolation: false # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
    }

    completions: {
        case_sensitive: false # set to true to enable case-sensitive completions
        quick: true    # set this to false to prevent auto-selecting completions when only one remains
        partial: true    # set this to false to prevent partial filling of the prompt
        algorithm: "prefix"    # prefix or fuzzy
        external: {
            enable: true # set to false to prevent nushell looking into $env.path to find more suggestions, `false` recommended for wsl users as this look up may be very slow
            max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
            completer: $carapace_completer # check 'carapace_completer' above as an example
            # completer: $external_completer # check 'carapace_completer' above as an example
        }
        use_ls_colors: true # set this to true to enable file/path/directory completions using ls_colors
    }

    filesize: {
        metric: false # true => kb, mb, gb (iso standard), false => kib, mib, gib (windows standard)
        format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, auto
    }

    cursor_shape: {
        emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (line is the default)
        vi_insert: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (block is the default)
        vi_normal: block # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (underscore is the default)
    }

    color_config: $aci # if you want a more interesting theme, you can replace the empty record with `$dark_theme`, `$light_theme` or another custom record
    use_grid_icons: true
   footer_mode: 25
    edit_mode: vi
       float_precision: 2 # the precision for displaying floats in tables
    buffer_editor: nvim # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.editor and $env.visual
    use_ansi_coloring: true
    bracketed_paste: false # enable bracketed paste, currently useless on windows
    
shell_integration: {
  # osc2 abbreviates the path if in the home_dir, sets the tab/window title, shows the running command in the tab/window title
  osc2: true
  # osc7 is a way to communicate the path to the terminal, this is helpful for spawning new tabs in the same directory
  osc7: true
  # osc8 is also implemented as the deprecated setting ls.show_clickable_links, it shows clickable links in ls output if your terminal supports it
  osc8: true
  # osc9_9 is from conemu and is starting to get wider support. it's similar to osc7 in that it communicates the path to the terminal
  osc9_9: true
  # osc133 is several escapes invented by final term which include the supported ones below.
  # 133;a - mark prompt start
  # 133;b - mark prompt end
  # 133;c - mark pre-execution
  # 133;d;exit - mark execution finished with exit code
  # this is used to enable terminals to know where the prompt is, the command is, where the command finishes, and where the output of the command is
  osc133: false
  # osc633 is closely related to osc133 but only exists in visual studio code (vscode) and supports their shell integration features
  # 633;a - mark prompt start
  # 633;b - mark prompt end
  # 633;c - mark pre-execution
  # 633;d;exit - mark execution finished with exit code
  # 633;e - not implemented - explicitly set the command line with an optional nonce
  # 633;p;cwd=<path> - mark the current working directory and communicate it to the terminal
  # and also helps with the run recent menu in vscode
  osc633: true
  # reset_application_mode is escape \x1b[?1l and was added to help ssh work better
  reset_application_mode: true
}


    render_right_prompt_on_last_line: true # true or false to enable or disable right prompt to be rendered on last line of the prompt.
    use_kitty_protocol: false # enables keyboard enhancement protocol implemented by kitty console, only if your terminal support this.
    highlight_resolved_externals: true # true enables highlighting of external commands in the repl resolved by which.
    recursion_limit: 50 # the maximum number of times nushell allows recursion before stopping it

    plugins: {
        explore: {
            margin: 3,
            relativenumber: true,
            colors: {
                line_numbers: {
                    normal: { foreground: [100, 100, 100] },
                    selected: { background: [100, 100, 100] }
                }
            }
        }
    }   
    plugin_gc: {
        # configuration for plugin garbage collection
        default: {
            enabled: true # true to enable stopping of inactive plugins
            stop_after: 10sec # how long to wait after a plugin is inactive to stop it
        }
        plugins: {
            # alternate configuration for specific plugins, by name, for example:
            #
            # gstat: {
            #     enabled: false
            # }
        }
    }

    menus: [
        # configuration for default nushell menus
        # note the lack of source parameter
        {
            name: completion_menu
            only_buffer_difference: false
            marker: "≡ "
            type: {
                layout: columnar
                columns: 3
                col_width: 20     # optional value. if missing all the screen width is used to calculate column width
                col_padding: 2
            }
            style: {
                text:  cyan 
                selected_text: { attr: r }
                description_text: yellow
                match_text: { attr: u }
                selected_match_text: { attr: ur }
            }
        }
        {
            name: ide_completion_menu
            only_buffer_difference: false
            marker: "≡ "
            type: {
                layout: ide
                min_completion_width: 0,
                max_completion_width: 50,
                max_completion_height: 10, # will be limited by the available lines in the terminal
                padding: 0,
                border: true,
                cursor_offset: 0,
                description_mode: "prefer_right"
                min_description_width: 0
                max_description_width: 50
                max_description_height: 10
                description_offset: 1
                # if true, the cursor pos will be corrected, so the suggestions match up with the typed text
                #
                # c:\> str
                #      str join
                #      str trim
                #      str split
                correct_cursor_pos: false
            }
            style: {
                text:  cyan 
                selected_text: { attr: r }
                description_text: yellow
                match_text: { attr: u }
                selected_match_text: { attr: ur }
            }
        }
        {
            name: history_menu
            only_buffer_difference: true
            marker: "? "
            type: {
                layout: list
                page_size: 10
            }
            style: {
                text:  cyan 
                selected_text: purple_bold
                description_text: yellow
            }
        }
        {
            name: help_menu
            only_buffer_difference: true
            marker: "? "
            type: {
                layout: description
                columns: 4
                col_width: 20     # optional value. if missing all the screen width is used to calculate column width
                col_padding: 2
                selection_rows: 4
                description_rows: 10
            }
            style: {
                text:  cyan 
                selected_text: purple_bold                
                description_text: yellow
            }
        }
    ]
  })

 # $env.config.hooks = {
 #    display_output: {|| table }
 #    command_not_found: { |cmd_name|
 #        if (which pkgfile | is-empty) {
 #            return null
 #        }
 #
 #    }
 #
 #
 #
 # }


    


# # enable carapace completions
# $env.carapace_bin = (which carapace | get path)
# $env.path = ($env.path | prepend $env.carapace_bin)
#
# # example: enable git completions
# $env.carapace_completers = (carapace git fish)
# print $"carapace path: ($env.carapace_bin)"
# print $"carapace completers: ($env.carapace_completers)"

# todo: use/source & sort (maybe fetch repo scripts & modules  though i the current list is curated)

# cmd 〉ls | get name | str join "\nuse "
# use gen_json_schema.nu



# 1. modules
# ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
use task.nu

# 1.2 scripts
# ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
source helpers.nu
source one_liners.nu
use ns.nu
use mkx.nu



{%- let section = "# =============================================================================\n#" -%}
{%- let not_configured = "# -- not configured --" -%}

# Code generated by zoxide. DO NOT EDIT.

{{ section }}
# Hook configuration for zoxide.


{% if hook == InitHook::None -%}
{{ not_configured }}

{%- else -%}
# Initialize hook to add new entries to the database.
if (not ($env | default false __zoxide_hooked | get __zoxide_hooked)) {
  $env.__zoxide_hooked = true
{%- if hook == InitHook::Prompt %}
  $env.config = ($env | default {} config).config
  $env.config = ($env.config | default {} hooks)
  $env.config = ($env.config | update hooks ($env.config.hooks | default [] pre_prompt))
  $env.config = ($env.config | update hooks.pre_prompt ($env.config.hooks.pre_prompt | append { ||
    zoxide add -- $env.PWD
  }))
{%- else if hook == InitHook::Pwd %}
  $env.config = ($env | default {} config).config
  $env.config = ($env.config | default {} hooks)
  $env.config = ($env.config | update hooks ($env.config.hooks | default {} env_change))
  $env.config = ($env.config | update hooks.env_change ($env.config.hooks.env_change | default [] PWD))
  $env.config = ($env.config | update hooks.env_change.PWD ($env.config.hooks.env_change.PWD | append {|_, dir|
    zoxide add -- $dir
  }))
{%- endif %}
}

{%- endif %}

{{ section }}
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

# Jump to a directory using only keywords.
def --env --wrapped __zoxide_z [...rest:string] {
  let arg0 = ($rest | append '~').0
  let arg0_is_dir = (try {$arg0 | path expand | path type}) == 'dir'
  let path = if (($rest | length) <= 1) and ($arg0 == '-' or $arg0_is_dir) {
    $arg0
  } else {
    (zoxide query --exclude $env.PWD -- ...$rest | str trim -r -c "\n")
  }
  cd $path
{%- if echo %}
  echo $env.PWD
{%- endif %}
}

# Jump to a directory using interactive search.
def --env --wrapped __zoxide_zi [...rest:string] {
  cd $'(zoxide query --interactive -- ...$rest | str trim -r -c "\n")'
{%- if echo %}
  echo $env.PWD
{%- endif %}
}

{{ section }}
# Commands for zoxide. Disable these using --no-cmd.
#

{%- match cmd %}
{%- when Some with (cmd) %}

alias z = __zoxide_z
alias zi = __zoxide_zi

{%- when None %}

{{ not_configured }}

{%- endmatch %}

{{ section }}
