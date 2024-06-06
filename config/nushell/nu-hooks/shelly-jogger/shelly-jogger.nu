# Description
#
# while `cd`-ing into a np project, look for a .np script an run run it
#
# Installation
#
# 1. Move this file under any directory in `$env.NU_LIB_DIRS`


$nu.config-path = ($env.config | update hooks.env_change.PWD {
  append {
    script: { ls | where name =~ '\.np$') }

    if $script {
      print (nu $script help)
      ## sj nu $script
    }
	}
})
