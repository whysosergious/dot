#!bin/env nu

# before running this script, make sure you installed the following:
# git, github cli, rustup (rust, rustup, cargo), wezterm, neovim
# then open wezterm and run 
# `cargo install cargo-binstall ; cargo binstall nu`

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
path add .cargo/bin;
#
#
#
# let packages = [
#   "broot",
#   "zoxide",
#   "starship",
#   "fzf",
#   "ripgrep",
#   # nushell plugins
#   "nu_plugin_query",
#   "nu_plugin_inc",
#   "nu_plugin_gstat",
#   "nu_plugin_pnet",
#   "nu_plugin_formats",
#   "nu_plugin_dialog",
#   "nu_plugin_image",
#   "nu_plugin_clipboard",
#   "nu_plugin_desctop_notifications",
#   "nu_plugin_port_list",
#   "nu_plugin_audio_hook",  
# ]
#
# # install packages
# $packages | each { |pkg| 
#   print $"installing ($pkg)";
#
#   cargo-binstall $pkg -y;
# }
#
# # add nushell plugins
# ls ~/.cargo/bin | each { |bin| 
#   if $bin.contains("nu_plugin_") {
#     print $"adding ($bin) to plugins";
#     nu plugin add $bin;
#   }
# }
