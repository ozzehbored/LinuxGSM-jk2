#!/bin/bash
# LGSM fix_mta.sh function
# Author: Daniel Gibbs
# Contributor: ChaosMTA
# Website: https://gameservermanagers.com
# Description: Installs the libmysqlclient for database functions on the server
local commandname="FIX"
local commandaction="Fix"
local function_selfname="$(basename $(readlink -f "${BASH_SOURCE[0]}"))"

if [ ! -f /usr/lib/libmysqlclient.so.16 ]; then
	fixname="libmysqlclient16 install"
	fn_fix_msg_start
	fn_print_warn_nl "libmysqlclient16 not installed. Installing.."
	sleep 1
  fileurl="https://nightly.mtasa.com/files/modules/64/libmysqlclient.so.16"; filedir="${lgsmdir}/lib"; filename="libmysqlclient.so.16"; executecmd="executecmd" run="norun"; force="noforce"; md5="6c188e0f8fb5d7a29f4bc413b9fed6c2"
  fn_fetch_file "${fileurl}" "${filedir}" "${filename}" "${executecmd}" "${run}" "${force}" "${md5}"
	fn_fix_msg_end
fi
}

fixname="libmysqlclient16"
fn_fix_msg_start
export LD_LIBRARY_PATH=:"${libdir}"
fn_fix_msg_end
