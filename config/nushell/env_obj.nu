
$env.config = {
    show_banner: false # true or false to enable or disable the welcome banner at startup

    ls: {
        use_ls_colors: true # use the LS_COLORS environment variable to colorize output
        clickable_links: true # enable or disable clickable links. Your terminal has to support links.
    }

    rm: {
        always_trash: false # always act as if -t was given. Can be overridden with -p
    }




 history :{
        max_size: 100_000 # Session has to be reloaded for this to take effect
  
      sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
        file_format: "sqlite" # "sqlite" or "plaintext"
        isolation: false # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
}    

    completions: {
        case_sensitive: false # set to true to enable case-sensitive completions
        quick: true    # set this to false to prevent auto-selecting completions when only one remains
        partial: true    # set this to false to prevent partial filling of the prompt
        algorithm: "prefix"    # prefix or fuzzy
        external: {
            enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up may be very slow
            max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
            completer: $carapace_completer 
            # check 'carapace_completer' above as an example
            # completer: $external_completer # check 'carapace_completer' above as an example
        }
        use_ls_colors: true # set this to true to enable file/path/directory completions using LS_COLORS
    }


  
    filesize: {
        metric: false # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
        format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, auto
    }




    color_config: $aci # if you want a more interesting theme, you can replace the empty record with `$dark_theme`, `$light_theme` or another custom record
    use_grid_icons: true
   footer_mode: 25
    edit_mode: vi
       float_precision: 2 # the precision for displaying floats in tables
    buffer_editor: nvim # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
    use_ansi_coloring: true
    bracketed_paste: true # enable bracketed paste, currently useless on windows
shell_integration: {
  # osc2 abbreviates the path if in the home_dir, sets the tab/window title, shows the running command in the tab/window title
  osc2: true
 # osc7 is a way to communicate the path to the terminal, this is helpful for spawning new tabs in the same directory
  osc7: true
  # osc8 is also implemented as the deprecated setting ls.show_clickable_links, it shows clickable links in ls output if your terminal supports it
  osc8: true
  # osc9_9 is from ConEmu and is starting to get wider support. Its similar to osc7 in that it communicates the path to the terminal
  osc9_9: true
  # osc133 is several escapes invented by Final Term which include the supported ones below.
  # 133;A - Mark prompt start
  # 133;B - Mark prompt end
  # 133;C - Mark pre-execution
  # 133;D;exit - Mark execution finished with exit code
  # This is used to enable terminals to know where the prompt is, the command is, where the command finishes, and where the output of the command is
  osc133: false
  # osc633 is closely related to osc133 but only exists in visual studio code (vscode) and supports their shell integration features
  # 633;A - Mark prompt start
  # 633;B - Mark prompt end
  # 633;C - Mark pre-execution
  # 633;D;exit - Mark execution finished with exit code
  # 633;E - NOT IMPLEMENTED - Explicitly set the command line with an optional nonce
  # 633;P;Cwd=<path> - Mark the current working directory and communicate it to the terminal
  # and also helps with the run recent menu in vscode
  osc633: true
  # reset_application_mode is escape \x1b[?1l and was added to help ssh work better
  reset_application_mode: true
}





   

    render_right_prompt_on_last_line: true # true or false to enable or disable right prompt to be rendered on last line of the prompt.
    use_kitty_protocol: false # enables keyboard enhancement protocol implemented by kitty console, only if your terminal support this.
    highlight_resolved_externals: true # true enables highlighting of external commands in the repl resolved by which.
    recursion_limit: 50 # the maximum number of times nushell allows recursion before stopping it

    plugins: {} # Per-plugin configuration. See https://www.nushell.sh/contributor-book/plugins.html#configuration.

    plugin_gc: {
        # Configuration for plugin garbage collection
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

    hooks: {
        pre_prompt: [{ null }] # run before the prompt is shown
        pre_execution: [{ null }] # run before the repl input is run
        env_change: {
            PWD: [{|before, after| null }] # run if the PWD environment is different since the last repl input
        }
        display_output: "if (term size).columns >= 100 { table -e } else { table }" # run to display the output of a pipeline
        command_not_found: { null } # return an error message when a command is not found
    }

    menus: [
        # Configuration for default nushell menus
        # Note the lack of source parameter
        {
            name: completion_menu
            only_buffer_difference: false
            marker: "| "
            type: {
                layout: columnar
                columns: 4
                col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
                col_padding: 2
            }
            style: {
                text: "#49ff00" 
                selected_text: { attr: r }
                description_text: "#a3f084" 
                match_text: { attr: u }
                selected_match_text: { attr: ur }
            }
        }
        {
            name: ide_completion_menu
            only_buffer_difference: false
            marker: "| "
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
                # If true, the cursor pos will be corrected, so the suggestions match up with the typed text
                #
                # C:\> str
                #      str join
                #      str trim
                #      str split
                correct_cursor_pos: false
            }
            style: {
                text: "#49ff00"
                selected_text: { attr: r }
                description_text: "#a3f084"
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
                text:  "#49ff00"  
                selected_text: yellow_reverse
                description_text: "#a3f084"
            }
        }
        {
            name: help_menu
            only_buffer_difference: true
            marker: "? "
            type: {
                layout: description
                columns: 4
                col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
                col_padding: 2
                selection_rows: 4
                description_rows: 10
            }
            style: {
                text: "#49ff00"  
                selected_text: yellow_reverse
                description_text: "#a3f084"
            }
        }
    ]

   
}

