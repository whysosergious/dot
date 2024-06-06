# Description
#
# while `cd`-ing into a np project, look for a .np script an run run it
#
# Installation
#
# 1. Move this file under any directory in `$env.NU_LIB_DIRS`


$nu.config-path = ($env.config | update hooks.env_change.PWD {

let script =  (ls | where name =~ '\.np$' | get name);

if $script {

  append {
    $script;
               ## sj nu $script
    }
}

print (nu $script help)


})
