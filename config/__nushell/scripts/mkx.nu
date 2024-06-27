

export def --env main [str: string, name: string, bin_path = '~/.cargo/bin'] {
  let res = $"#!/usr/bin/env nu\n($str)"

  if ($bin_path | path exists) {
    let tgt_path = ($bin_path | path join $name)
    $res | save -f $tgt_path;

    if ($nu.os-info.name == 'windows') {
      $'nu ($tgt_path)' | str replace "'" "" | save -f $"($tgt_path).bat";
      print "added .bat with script"
    } else {
      nu -c $'chmod 755 (echo $tgt_path)';
      print "added shebang with rwx (755) perm"
    }
  } else {
    print "bin path invalid"
  }
}
