#!/bin/sh

# Variables initialisation
version="resetHomeSync v1.2 - 2016, Yvan Godard [godardyvan@gmail.com]"
versionOSX=$(sw_vers -productVersion | awk -F '.' '{print $(NF-1)}')
scriptDir=$(dirname "${0}")
scriptName=$(basename "${0}")

if [ `whoami` != 'root' ]; then
	echo "Ce script doit être utilisé par le compte root. Utilisez SUDO."
	exit 1
fi

echo ""
echo "****************************** `date` ******************************"
echo "$0 démarré..."
echo ""

# $1 est le nom du compte utilisateur
# test si un nom de compte user est entré en paramètre
if [[ ! -z $1 ]]; then
	userName=$1
	dirUser=/Users/${userName%/}
	[[ ! -d ${dirUser} ]] && echo "Le dossier de départ ${dirUser} n'existe pas. Nous quittons" && exit 1
	echo "Suppression des fichiers et dossiers suivants : "
	echo "   - ${dirUser}/.FileSync"
	echo "   - ${dirUser}/Library/FileSync"
	echo "   - ${dirUser}/Library/Logs/FileSync*"
	echo "   - ${dirUser}/Library/Application Support/SyncServices"
	echo "   - ${dirUser}/Library/Application Support/MobileSync"
	echo "   - ${dirUser}/Library/Keychains/login.keychain"
	echo "   - ${dirUser}/Library/Preferences/ByHost/com.apple.syncservices.*.plist"
	echo "   - ${dirUser}/Library/Preferences/com.apple.homeSync.plist"
	echo "   - ${dirUser}/Library/Preferences/com.apple.MCX.plist"
	echo "   - ${dirUser}/Library/Preferences/com.apple.FileSyncUI.plist"
	echo "   - ${dirUser}/Library/Preferences/com.apple.MirrorAgent.plist"
	echo "   - ${dirUser}/Library/Preferences/com.apple.PreferenceSync.plist"
	echo "   - ${dirUser}/Library/Preferences/com.apple.FileSyncAgent.plist"
	echo "Merci de patienter. Le processus peut mettre quelques minutes à s'exécuter."
	echo " "
	# Suppression des fichiers
	[[ -e ${dirUser}/.FileSync ]] && rm -R ${dirUser}/.FileSync
	[[ -e ${dirUser}/Library/FileSync ]] && rm -R ${dirUser}/Library/FileSync
	ls ${dirUser}/Library/Logs/FileSync*  > /dev/null 2>&1
	[ $? -eq 0 ] && rm -R ${dirUser}/Library/Logs/FileSync*
	[[ -e ${dirUser}/Library/Application\ Support/SyncServices ]] && rm -R ${dirUser}/Library/Application\ Support/SyncServices
	[[ -e ${dirUser}/Library/Application\ Support/MobileSync ]] && rm -R ${dirUser}/Library/Application\ Support/MobileSync
	# [[ -e ${dirUser}/Library/Keychains/login.keychain ]] && rm -R ${dirUser}/Library/Keychains/login.keychain
	ls ${dirUser}/Library/Preferences/ByHost/com.apple.syncservices.*.plist > /dev/null 2>&1
	[ $? -eq 0 ] && rm -R ${dirUser}/Library/Preferences/ByHost/com.apple.syncservices.*.plist
	[[ -e ${dirUser}/Library/Preferences/com.apple.homeSync.plist ]] && rm -R ${dirUser}/Library/Preferences/com.apple.homeSync.plist
	[[ -e ${dirUser}/Library/Preferences/com.apple.FileSyncUI.plist ]] && rm -R ${dirUser}/Library/Preferences/com.apple.FileSyncUI.plist
	[[ -e ${dirUser}/Library/Preferences/com.apple.FileSyncUI.plist ]] && rm -R ${dirUser}/Library/Preferences/com.apple.FileSyncUI.plist
	[[ -e ${dirUser}/Library/Preferences/com.apple.MirrorAgent.plist ]] && rm -R ${dirUser}/Library/Preferences/com.apple.MirrorAgent.plist
	[[ -e ${dirUser}/Library/Preferences/com.apple.PreferenceSync.plist ]] && rm -R ${dirUser}/Library/Preferences/com.apple.PreferenceSync.plist
	[[ -e ${dirUser}/Library/Preferences/com.apple.FileSyncAgent.plist ]] && rm -R ${dirUser}/Library/Preferences/com.apple.FileSyncAgent.plist
	# Correction des droits
	#chown -R ${userName} ${dirUser}
	#chmod -R -N ${dirUser}
	#chmod -R 700 ${dirUser}
	exit 0
else
	echo "Vous devez entrer le nom du compte utilisateur en paramètre \$1."
	echo "Par exemple : ${scriptDir%/}/${scriptName} c.toto"
exit 1
fi