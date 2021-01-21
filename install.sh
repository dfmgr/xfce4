#!/usr/bin/env bash

APPNAME="xfce4"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# @Author          : Jason
# @Contact         : casjaysdev@casjay.net
# @File            : install.sh
# @Created         : Fr, Aug 28, 2020, 00:00 EST
# @License         : WTFPL
# @Copyright       : Copyright (c) CasjaysDev
# @Description     : installer script for xfce4
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set functions

SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/casjay-dotfiles/scripts/raw/master/functions}"
SCRIPTSFUNCTDIR="${SCRIPTSAPPFUNCTDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-app-installer.bash}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ -f "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE"
elif [ -f "$HOME/.local/share/CasjaysDev/functions/$SCRIPTSFUNCTFILE" ]; then
  . "$HOME/.local/share/CasjaysDev/functions/$SCRIPTSFUNCTFILE"
else
  curl -LSs "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
  . "/tmp/$SCRIPTSFUNCTFILE"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
user_installdirs

# OS Support: supported_os unsupported_oses

unsupported_oses MacOS Windows

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Make sure the scripts repo is installed

scripts_check

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Defaults
APPNAME="${APPNAME:-xfce4}"
APPDIR="${APPDIR:-$HOME/.config/$APPNAME}"
REPO="${DFMGRREPO:-https://github.com/dfmgr}/${APPNAME}"
REPORAW="${REPORAW:-$REPO/raw}"
APPVERSION="$(__appversion)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Setup plugins

PLUGNAMES=""
PLUGDIR="${SHARE:-$HOME/.local/share}/$APPNAME"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# dfmgr_install fontmgr_install iconmgr_install pkmgr_install systemmgr_install thememgr_install wallpapermgr_install

dfmgr_install

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Version

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Script options IE: --help

show_optvars "$@"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Do not update

#systemmgr_noupdate

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Requires root - no point in continuing

#sudoreq  # sudo required
#sudorun  # sudo optional

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# end with a space

APP="$APPNAME geany firefox thunar xfce4-terminal sxhkd "
PERL=""
PYTH=""
PIPS=""
CPAN=""
GEMS=""

# install packages - useful for package that have the same name on all oses
install_packages $APP

# install required packages using file
install_required $APP

# check for perl modules and install using system package manager
install_perl $PERL

# check for python modules and install using system package manager
install_python $PYTH

# check for pip binaries and install using python package manager
install_pip $PIPS

# check for cpan binaries and install using perl package manager
install_cpan $CPAN

# check for ruby binaries and install using ruby package manager
install_gem $GEMS

# Other dependencies
dotfilesreq git htop geany thunar gtk-2.0 gtk-3.0 firefox xfce4-terminal
dotfilesreqadmin

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Ensure directories exist

ensure_dirs
ensure_perms

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main progam

if [ -d "$APPDIR" ]; then
  execute "backupapp $APPDIR $APPNAME" "Backing up $APPDIR"
fi

if [ -d "$DOWNLOADED_TO/.git" ]; then
  execute \
    "git_update $DOWNLOADED_TO" \
    "Updating $APPNAME configurations"
else
  execute \
    "git_clone $REPO/$APPNAME $DOWNLOADED_TO" \
    "Installing $APPNAME configurations"
fi

# exit on fail
failexitcode

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Plugins

if __am_i_online; then
  if [ "$PLUGNAMES" != "" ]; then
    if [ -d "$PLUGDIR"/PLUREP/.git ]; then
      execute \
        "git_update $PLUGDIR/PLUGREP" \
        "Updating plugin PLUGNAME"
    else
      execute \
        "git_clone PLUGINREPO $PLUGDIR/PLUGREP" \
        "Installing plugin PLUGREP"
    fi
  fi

  # exit on fail
  failexitcode
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# run post install scripts

run_post_custom() {
  for d in "$APPDIR"/panel/launcher-*; do
    rm_rf "$d"
  done
  cp_rf "$DOWNLOADED_TO/local_share/." "$HOME/.local/share/xfce4/."
}

run_postinst() {
  dfmgr_run_post
  [ -n "$MPDSERVER" ] && GETMPDSERVER="$(getent ahosts "$MPDSERVER" 2>/dev/null | head -n1 | awk '{print $1}')" || GETMPDSERVER="localhost"
  mpdhostserver="${GETMPDSERVER}"
  replace "$APPDIR" "MPDSERVER_host" "$mpdhostserver"
  replace "$APPDIR" "/home/jason" "$HOME"
  if [[ "$DESKTOP_SESSION" =~ "xfce" ]] || pidof xfce4-session &>/dev/null; then
    xfce4-panel -s >/dev/null 2>&1
    xfce4-panel -r >/dev/null 2>&1
  fi
}

execute \
  "run_post_custom && run_postinst" \
  "Running post install scripts"

printf_question_timeout "Should I install the themes and icons?"
echo ""
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
  fontmgr install --all
  iconmgr install N.I.B.
  thememgr install Arc-Pink-Dark
  systemmgr install lightdm grub
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# create version file

dfmgr_install_version

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# exit
run_exit

# end
