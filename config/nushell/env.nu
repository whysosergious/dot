use std "path add"

$env.SHELL = nu

$env.EDITOR = nvim
$env.VISUAL = nvim

$env.STARSHIP_SHELL = nu


                                      
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

 $env.PATH = ($env.PATH | split row (char esep))


 ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
 $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
                              
                              



 def create_left_prompt [] {

     let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
         null => $env.PWD
          '' => '~'
         $relative_pwd => ([~ $relative_pwd] | path join)
      }
     
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
 $env.PROMPT_COMMAND = {|| create_left_prompt  }

  $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }


 # The prompt indicators are environmental variables that represent
 # the state of the prompt
 $env.PROMPT_INDICATOR = ""
 $env.PROMPT_INDICATOR_VI_INSERT = " "
 $env.PROMPT_INDICATOR_VI_NORMAL = "∥ "
 $env.PROMPT_MULTILINE_INDICATOR = ":: "



 # load secret environment variables
 export-env {
     let env_file = $nu.home-path | path join ".env"
     if ($env_file | path exists) {
         open $env_file | from nuon | load-env
     }
 }











