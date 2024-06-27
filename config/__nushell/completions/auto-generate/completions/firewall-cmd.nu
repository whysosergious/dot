# Prints a short help text and exits
extern "firewall-cmd" [
	--help(-h)					# Prints a short help text and exits
	--version(-V)					# Print the version string of firewalld
	--quiet(-q)					# Do not print status messages
	--state					# Check whether the firewalld daemon is active
	--reload					# Reload firewall rules and keep state information
	--complete-reload					# Reload firewall completely, even netfilter kernel modules
	--runtime-to-permanent					# Save active runtime configuration and overwrite permanent configuration
	--check-config					# Run checks on the permanent configuration
	--get-log-denied					# Print the log denied setting
	--set-log-denied					# Add logging rules right before reject and drop rules
	--permanent					# Set options permanently
	--get-default-zone					# Print default zone for connections and interfaces
	--set-default-zone					# Set default zone for connections and interfaces
	--get-active-zones					# Print currently active zones altogether with interfaces and sources
	--get-zones					# Print predefined zones
	--get-services					# Print predefined services
	--get-icmptypes					# Print predefined icmptypes
	--get-zone-of-interface					# Print the name of the zone the interface is bound to
	--info-zone					# Print information about the zone
	--list-all-zones					# List everything added for or enabled in all zones
	--delete-zone					# Delete an existing permanent zone
	--load-zone-defaults					# Load zone default settings
	--path-zone					# Print path of the zone configuration file
	--get-policies					# Print predefined policies
	--info-policy					# Print information about the policy
	--list-all-policies					# List everything added for or enabled in all policies
	--path-policy					# Print path of the policy configuration file
	--delete-policy					# Delete an existing permanent policy
	--load-policy-defaults					# Load the shipped defaults for a policy
	--zone					# Apply option to this zone
	--policy					# Apply option to this policy
	--get-target					# Get the target
	--set-target					# Set the target
	--list-all					# List everything added for or enabled
	--list-services					# List services added
	--add-service					# Add a service
	--remove-service					# Remove a service
	--query-service					# Return whether service has been added
	--list-ports					# List ports added
	--list-protocols					# List protocols added
	--list-source-ports					# List source ports added
	--list-icmp-blocks					# List ICMPs type blocks added
	--add-icmp-block					# Add an ICMP block for icmptype
	--remove-icmp-block					# Remove the ICMP block for icmptype
	--query-icmp-block					# Return whether an ICMP block for icmptype has been added
	--list-forward-ports					# List IPv4 forward ports added
	--add-masquerade					# Enable IPv4 masquerade
	--remove-masquerade					# Disable IPv4 masquerade
	--query-masquerade					# Return whether IPv4 masquerading has been enabled
	--list-rich-rules					# List rich language rules added
	--add-icmp-block-inversion					# Enable ICMP block inversion
	--remove-icmp-block-inversion					# Disable ICMP block inversion
	--query-icmp-block-inversion					# Return whether ICMP block inversion is enabled
	--add-forward					# Enable intra zone forwarding
	--remove-forward					# Disable intra zone forwarding
	--query-forward					# Return whether intra zone forwarding is enabled
	--get-priority					# Get the priority
	--list-ingress-zones					# List ingress zones added
	--add-ingress-zone					# Add an ingress zone
	--remove-ingress-zone					# Remove an ingress zone
	--query-ingress-zone					# Return whether zone has been added
	--list-egress-zones					# List egress zones added
	--add-egress-zone					# Add an egress zone
	--remove-egress-zone					# Remove an egress zone
	--query-egress-zone					# Return whether zone has been added
	--list-interfaces					# List interfaces that are bound to zone
	--add-interface					# Bind interface to zone
	--change-interface					# Change to which zone interface is bound
	--query-interface					# Query whether interface is bound to zone
	--remove-interface					# Remove binding of interface from zone
	--list-sources					# List sources that are bound to zone
	--get-ipset-types					# Print the supported ipset types
	--get-ipsets					# Print predefined ipsets
	--get-entries					# List all entries of the ipset
	--path-ipset					# Print path of the ipset configuration file
	--info-service					# Print information about the service
	--delete-service					# Delete an existing permanent service
	--load-service-defaults					# Load service default settings
	--path-service					# Print path of the service configuration file
	--service					# Apply settings to this service
	--get-protocols					# List protocols added to the permanent service
	--get-source-ports					# List source ports added to the permanent service
	--add-helper					# Add a new helper to the permanent service
	--remove-helper					# Remove a helper from the permanent service
	--query-helper					# Return wether the helper has been added to the permanent service
	--get-service-helpers					# List helpers added to the permanent service
	--add-include					# Add a new include to the permanent service
	--remove-include					# Remove a include from the permanent service
	--query-include					# Return wether the include has been added to the permanent service
	--get-includes					# List includes added to the permanent service
	--info-helper					# Print information about the helper
	--delete-helper					# Delete an existing permanent helper
	--load-helper-defaults					# Load helper default settings
	--path-helper					# Print path of the helper configuration file
	--get-helpers					# Print predefined helpers as a space separated list
	--helper					# Apply settings to this helper
	--get-module					# Print module description for helper
	--get-family					# Print family description of helper
	--info-icmptype					# Print information about the icmptype
	--delete-icmptype					# Delete an existing permanent icmptype
	--load-icmptype-defaults					# Load icmptype default settings
	--icmptype					# Apply settings to this icmptype
	--add-destination					# Enable destination for ipv in permanent icmptype
	--path-icmptype					# Print path of the icmptype configuration file
	--direct					# Give a more direct access to the firewall
	--get-all-chains					# Get all chains added to all tables
	--get-chains					# Get all chains added to table
	--add-chain					# Add a new chain to table
	--remove-chain					# Remove chain from table
	--query-chain					# Return whether the chain with given name exists in table
	--get-all-rules					# Get all rules added to all chains in all tables
	--get-rules					# Get all rules added to chain in table
	--add-rule					# Add a rule to chain in table
	--remove-rule					# Remove a rule from chain in table
	--remove-rules					# Remove all rules in the chain in table
	--query-rule					# Return whether the rule exists in chain in table
	--passthrough					# Pass a command through to the firewall
	--get-all-passthroughs					# Get all passthrough rules
	--get-passthroughs					# Get all passthrough rules for the ipv value
	--add-passthrough					# Add a passthrough rule
	--remove-passthrough					# Remove a passthrough rule
	--query-passthrough					# Return whether the passthrough rule exists
	--lockdown-on					# Enable lockdown
	--lockdown-off					# Disable lockdown
	--query-lockdown					# Query whether lockdown is enabled
	--list-lockdown-whitelist-commands					# List all command lines that are on the whitelist
	--list-lockdown-whitelist-contexts					# List all contexts that are on the whitelist
	--list-lockdown-whitelist-uids					# List all user ids that are on the whitelist
	--list-lockdown-whitelist-users					# List all user names that are on the whitelist
	--add-lockdown-whitelist-user					# Add the user to the whitelist
	--remove-lockdown-whitelist-user					# Remove the user from the whitelist
	--query-lockdown-whitelist-user					# Query whether the user is on the whitelist
	--panic-on					# Enable panic mode
	--panic-off					# Disable panic mode
	--query-panic					# Returns 0 if panic mode is enabled, 1 otherwise
	--get-description					# Print description of zone|policy|ipset|service|helper|icmptype
	--get-short					# Print short description of zone|policy|ipset|service|helper|icmptype
	--add-protocol					# Add the protocol to zone|policy|service
	--remove-protocol					# Remove the protocol from zone|policy|service
	--query-protocol					# Return whether the protocol has been added to zone|policy|service
	--get-ports					# List ports added to the permanent service|helper
	--remove-destination					# Disable destination for ipv in permanent service|icmptype
	--query-destination					# Return whether destination for ipv is enabled in permanent service|icmptype
	--get-destinations					# List destinations in permanent service|icmptype
	...args
]