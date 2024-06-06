#!/usr/bin/env nu

mkdir .tmp;
let cargo_bin_path = ($nu.home-path | path join .cargo/bin);
# before running this script, make sure you installed the following:
# git, github cli, rustup (rust, rustup, cargo), wezterm, neovim
# then open wezterm and run 
# `cargo install cargo-binstall ; cargo binstall nu`


# TODO: backup config files to .cache/np/bak/
# TODO: lock-file
# TODO: clean local data (nvim-data, .local/share/nushell, .local/share/nvim, .cache/nvim ..)
# TODO: cleanup tmp (.cargo/bin, .cache/nu, .cache/np ..)

def --env mv_cfg [] {

print "fetching latest toolkit";

curl https://raw.githubusercontent.com/nushell/nushell/main/toolkit.nu | save -f ./config/nushell/toolkit.nu;


print "moving config files";

let nu_config_dir = if $nu.os-info.name == "windows" {
    ($nu.home-path | path join "AppData/Roaming")
} else {
    ($nu.home-path | path join ".config/nushell")
}

let nvim_config_dir = if $nu.os-info.name == "windows" {
    ($nu.home-path | path join "AppData/Local/nvim")
} else {
    ($nu.home-path | path join ".config/nvim")
}

cp ./config/nushell $nu_config_dir -r;
cp ./config/.wezterm.lua $"($nu.home-path)/.wezterm.lua";

source $"($nu.home-path)/AppData/Roaming/nushell/config.nu";




print "finished moving config files";

}

def --env install_packages [] {

print "installing packages";

let packages = [
  "nu",
  "broot",
  "zoxide",
  "jq",
  "starship",
  "fzf",
  "ripgrep",
  "carapache",
  "btm",
  "watchexec",
  "lazygit",
  "bun",
  "deno",
]

# install packages
  $packages | each { |pkg| 
    print $"installing ($pkg)";

    cargo-binstall $pkg -y -v --force --json-output
  }
}

def --env build_nu_plugins [] {

let plugins = [
  nu_plugin_inc,
  nu_plugin_gstat,
  nu_plugin_query,
  nu_plugin_example,
  nu_plugin_custom_values,
  nu_plugin_formats,
]

## clone nushell repo
rm -rf .tmp;

  git clone $"https://github.com/nushell/nushell.git" .tmp/nushell;


cargo install --path .tmp/nushell --all-features;


  if (pwd | path join ./tmp/nvim | path exists) == false {


# nvim cfg
  git clone $"https://github.com/whysosergious/pocketnvim.np" .tmp/nvim;
  }



let installed_plugins = (ls $cargo_bin_path | where name =~ "nu_plugin") 

print $installed_plugins;

$installed_plugins | where modified < (date now | $in - 1day) | each { |plugin| 
  print $'(char nl)Installing ($plugin | get name)';
    print '----------------------------';

    
    cargo install --path $".tmp/nushell/crates/($plugin | get name)" --locked;
}

# add nushell plugins
$installed_plugins | each { |p| 
  try {
            print $"> plugin add ($p | get name)";
            plugin add ($p | get name);
  } catch { |err|
            print -e $"(ansi rb)Failed to add ($p):\n($err.msg)(ansi reset)";
        }
    

}


print $"\n(ansi gb)installation done, restart your terminal(ansi reset)"

}



# git_bin_or_build "*.np"
def git_bin_or_build [name: string] {

  let local_repo = (pwd | path join $".tmp/($name)");

  if (pwd | pth join $local_repo | !path exists) {
    git clone $name $local_repo;
  }

  let realease_path = ($local_repo | path join "release/($nu.os-info.name)");
  let bin_release =  ($realease_path | where name =~ $name | get name);

  print $bin_release;

  if ($bin_release | path exists) {
    cp $bin_release $cargo_bin_path;
  }

   print "done --------------"
}



def custom_bins [] {
  git clone https://github.com/whysosergious/pocketnvim.np .tmp/nvim

  let np_modules = [
    "whysosergious/run_with_monitor.np",
    "whysosergious/shelly_jogger.np",
  ] | each { |module| 
    git_bin_or_build $module;
  }

  print "finished installing custom bins";
}




# main 
def --env main [--cfg, --pkg, --nu-plg, --np-bin] { # nui - nu install
    let all = $cfg == false and $pkg == false and $nu_plg == false;

    ## if (ls | where ) {
    ## $env.CARGO_BIN_PATH = ($nu.home-path | path join ~/.cargo/bin);
## }
    # install custom binaries
    if $all or $np_bin {
      custom_bins
    }
    if $all or $cfg {
        mv_cfg
    } 
    if $all or $pkg {
        install_packages
    }
    if $all or $nu_plg {
        build_nu_plugins
    }
}



