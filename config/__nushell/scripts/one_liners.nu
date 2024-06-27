# clear buffer
export def cls [] {
  ansi cls
  ansi clsb
  ansi home
}

#push to git
export def git-push [m: string] {
  git add -A
  git status
  git commit -a -m $"($m)"
  git push origin main
}

#search for specific process
export def psn [name: string] {
  ps | where name =~ $name | select name, pid
}

#copy current dir
export def cpwd [] {pwd | path parse | get stem}
