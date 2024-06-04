#!/usr/bin/env nu

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

let cargo_bin_path = "~/.cargo/bin";


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
rm -rf $"($nu.home-path)/.cache/nu"

git clone $"https://github.com/nushell/nushell.git" $"($nu.home-path)/.cache/nu" 



let installed_plugins = ls $"($nu.home-path)/.cargo/bin" | where name =~ "nu_plugin" 

print $installed_plugins;

$installed_plugins | where modified < (date now | $in - 1day) | each { |plugin| 
  print $'(char nl)Installing ($plugin | get name)';
    print '----------------------------';

    
    cargo install --path $"($nu.home-path)/.cache/nu/crates/($plugin | get name)" --locked;
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


def --env main [--cfg, --pkg, --nu-plg] { # nui - nu install
    let all = $cfg == false and $pkg == false and $nu_plg == false;

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
