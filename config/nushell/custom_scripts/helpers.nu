export def --env --wrapped np [...cmds: string] {
  

  # Concatenate all arguments into a single command string
  let cmd = $cmds | str join ' '

  if (which shelly) == [] {

  
    # Check for '.np.nu' script files and load them as overlays
    let module = (ls | where name =~ "\\.np\\.nu$" | get name)
    
    if ($module.0) != '' {

 $env.PATH = ($env.Path | split row (char esep) | prepend $"(pwd)/.bin");
  $env.Path = ($env.Path | split row (char esep) | prepend $"(pwd)/.bin");

      print $"sourcing ($module.0)";
     nu -e $"source ($module.0) ; exit";
    }
    
  } 
 np run ($cmd) 
# # Execute the concatenated command after loading overlays, if not empty
# if $cmd != '' {
#   # Ensure the command is executed in a context that respects flags
#  np run ($cmd);
#   print "a1"
# } else {
#   print "No command provided, running default";
#  np run;
#   print "a2"
# }
# print "ran";
}


export const PORT_MIN = 8890;
export const PORT_MAX = 8999;
export const MASTER_PORT = 8888;
let public_ip = http get https://api.ipify.org?format=json | get ip | $"($in)";

export def --env --wrapped "np run" [cmd: string = "--instance", ...rest: string] {
  let type = if ($cmd | str contains "--master") { 'master' } else { 'instace' };
  let type_flag = $"--type=($type)"
  let port = if ($type == "master") { $MASTER_PORT } else {  get-free-port $PORT_MIN $PORT_MAX; }
  let port_flag = $"--port=($port)"
  let remote_ip = get-remote-ip;
  let remote_ip_flag = $"--remote-ip=($remote_ip)";
  let protocol = $"--protocol=http";
  let os = $"--os=($env.OS)";
  let public_ip_flag = $"--public-ip=($public_ip)";
  let device_name = $"--device-name=($env.COMPUTERNAME)";   ## unsure if same on all systems
  let device_user = $"--device-user=($env.USERNAME)";
  let iid = [$remote_ip $port $device_name $device_user $public_ip] | str join "" | hash md5; 
  let iid_flag = $"--iid=($iid)";

  let args = [($iid_flag) ($device_name) ($device_user) ($os) ($protocol) ($remote_ip_flag) ($port_flag) ($public_ip_flag) ($cmd)];

  print "server args: " ...$args;

  
  mut cb = $"notify_delete ($iid)"

  if ($type == 'master') {
    $cb = $"print 'master died'"
  }

  run_with_monitor  deno run -A ./src/shelly.ts ...($args) -- nu -e $"source ($nu.config-path) ; ($cb) ; exit"



}


export def --env notify_delete [iid: string] {
print $"query delete - ($iid)";



nu -c $"http delete --content-type application/json --data { iid: ($iid) } -H [instance-iid ($iid)]  http://($public_ip):($MASTER_PORT)/list"

}



export def net_list [--process-stat (-p)] {
   let list = netstat -q -n -o | rg TCP | rg ':{1}(\d+)\s' -r $"\t\t$1" | rg '\s{2,}+' -r "  " | parse -r '\s+(?<proto>\S+)\s+(?<local_ip>\S+)\s+(?<local_port>\S+)\s+(?<remote_ip>\S+)\s+(?<remote_port>\S+)\s+(?<state>\S+)\s+(?<pid>\S+)' | each { |row| $row | update pid { |it|  $it.pid | into int } | update local_port { |it| $it.local_port | into int } | update remote_port { |it| $it.remote_port | into int } }
  
  if ($process_stat == true) {
        let ps = ps;
        
        let list_with_ps = $list | each { |row| 
            let matching_ps = ($ps | where pid == ($row.pid | into int));

            let result = $row | insert process_name ($matching_ps | get name) | insert cpu ($matching_ps | get cpu) | insert mem ($matching_ps | get mem) | insert virtual ($matching_ps | get virtual) | insert ppid ($matching_ps | get ppid);

           $result
        };

        $list_with_ps
    }


  $list
}

export def get-free-port [range_min:int = 1024, range_max: int = 65535] {
  
  let used_ports = (net_list | where { |item| $item.local_port >= $range_min and $item.local_port <= $range_max } | get local_port);
  let all_ports = (seq $range_min $range_max);
  let free_ports = ($all_ports | where { |it| $it not-in $used_ports });

  echo $free_ports.0
}
     
export def get-remote-ip [] {
  if $env.OS == "Windows_NT" {
    ipconfig | lines | where { |item| $item =~ 'IPv4' } | split row ":" | get 1 | str trim
  } else {
    ifconfig | lines | where { |item| $item =~ 'inet ' } | split row " " | get 1 
  }
}



export def --env npr [--master (-m)] {

}

####
## cargo-watch `-x b --release --out-dir ../../.bin/`


# (pwd !~ arg | z arg) | np --master ; np 
export def --env "npr shelly" [--master (-m)] {
  

  if $master {

    np --master;
  } else {
    np
  }
  
}
