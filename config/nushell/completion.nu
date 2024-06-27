


# External completer 
 let fish_completer = {|spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | $"value(char tab)description(char newline)" + $in
    | from tsv --flexible --no-infer
}

 let zoxide_completer = {|spans: list<string>|
    zoxide completions $spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

# This completer will use carapace by default
 let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell .$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}


 let external_completer = {|spans|

     match $spans.0 {
         # carapace completions are incorrect for nu
         nu => $fish_completer
         # fish completes commits and branch names in a nicer way
        git => $fish_completer
         # carapace doesnt have completions for asdf
         asdf => $fish_completer
         # use zoxide completions for zoxide commands
         __zoxide_z | __zoxide_zi => $zoxide_completer
         _ => $carapace_completer
     } | do $in $spans
 
 # The default config record. This is where much of your global configuration is setup.
}

