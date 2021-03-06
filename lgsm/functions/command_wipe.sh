#!/bin/bash
# LGSM command_backup.sh function
# Author: Daniel Gibbs
# Contributor: UltimateByte
# Website: https://gameservermanagers.com
# Description: Wipes server data, useful after updates for some games like Rust

local commandname="WIPE"
local commandaction="data wipe"
local function_selfname="$(basename $(readlink -f "${BASH_SOURCE[0]}"))"

check.sh
fn_print_header
fn_script_log "Entering ${gamename} ${commandaction}"

# Process to server wipe
fn_wipe_server_process(){
	check_status.sh
	if [ "${status}" != "0" ]; then
		exitbypass=1
		command_stop.sh
		fn_wipe_server_remove_files
		exitbypass=1
		command_start.sh
	else
		fn_wipe_server_remove_files
	fi
	echo "server data wiped"
	fn_script_log "server data wiped."
}

# Provides an exit code upon error
fn_wipe_exit_code(){
	((exitcode=$?))
	if [ ${exitcode} -ne 0 ]; then
		fn_script_log_fatal "${currentaction}"
		core_exit.sh
	else
		fn_print_ok_eol_nl
	fi
}

# Removes files to wipe server
fn_wipe_server_remove_files(){
	# Rust Wipe
	if [ "${gamename}" == "Rust" ]; then
		if [ -n "$(find "${serveridentitydir}" -type f -name "proceduralmap.*.sav")" ]; then
			currentaction="Removing map file(s): ${serveridentitydir}/proceduralmap.*.sav"
			echo -en "Removing map proceduralmap.*.sav file(s)..."
			sleep 1
			fn_script_log "${currentaction}"
			find "${serveridentitydir}" -type f -name "proceduralmap.*.sav" -delete
			fn_wipe_exit_code
			sleep 0.5
		else
			fn_print_information_nl "No map file to remove"
			fn_script_log_info "No map file to remove."
			sleep 0.5
		fi
		if [ -d "${serveridentitydir}/user" ]; then
			currentaction="Removing user directory: ${serveridentitydir}/user"
			echo -en "Removing user directory..."
			sleep 1
			fn_script_log "${currentaction}"
			rm -rf "${serveridentitydir}/user"
			fn_wipe_exit_code
			sleep 0.5
		else
			fn_print_information_nl "No user directory to remove"
			fn_script_log_info "No user directory to remove."
			sleep 0.5
		fi
		if [ -d "${serveridentitydir}/storage" ]; then
			currentaction="Removing storage directory: ${serveridentitydir}/storage"
			echo -en "Removing storage directory..."
			sleep 1
			fn_script_log "${currentaction}"
			rm -rf "${serveridentitydir}/storage"
			fn_wipe_exit_code
			sleep 0.5
		else
			fn_print_information_nl "No storage directory to remove"
			fn_script_log_info "No storage directory to remove."
			sleep 0.5
		fi
		if [ -n "$(find "${serveridentitydir}" -type f -name "Log.*.txt")" ]; then
			currentaction="Removing log files: ${serveridentitydir}/Log.*.txt"
			echo -en "Removing Log files..."
			sleep 1
			fn_script_log "${currentaction}"
			find "${serveridentitydir}" -type f -name "Log.*.txt" -delete
			fn_wipe_exit_code
			sleep 0.5
		else
			fn_print_information_nl "No log files to remove"
			fn_script_log_info "No log files to remove."
			sleep 0.5
		fi
	# You can add an "elif" here to add another game or engine
	fi
}

# Check if there is something to wipe, prompt the user, and call appropriate functions
# Rust Wipe
if [ "${gamename}" == "Rust" ]; then
	if [ -d "${serveridentitydir}/storage" ]||[ -d "${serveridentitydir}/user" ]||[ -n "$(find "${serveridentitydir}" -type f -name "proceduralmap*.sav")" ]||[ -n "$(find "${serveridentitydir}" -type f -name "Log.*.txt")" ]; then
		fn_print_warning_nl "Any user, storage, log and map data from ${serveridentitydir} will be erased."
		while true; do
			read -e -i "y" -p "Continue? [Y/n]" yn
			case $yn in
			[Yy]* ) break;;
			[Nn]* ) echo Exiting; core_exit.sh;;
			* ) echo "Please answer yes or no.";;
			esac
		done
		fn_script_log_info "User selects to erase any user, storage, log and map data from ${serveridentitydir}"
		sleep 1
		fn_wipe_server_process
	else 
		fn_print_information_nl "No data to wipe was found"
		fn_script_log_info "No data to wipe was found."
		sleep 1
		core_exit.sh
	fi
# You can add an "elif" here to add another game or engine
else
	# Game not listed
	fn_print_information_nl "Wipe is not available for this game"
	fn_script_log_info "Wipe is not available for this game."
	sleep 1
	core_exit.sh
fi

core_exit.sh
