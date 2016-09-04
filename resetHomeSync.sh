#!/bin/bash

# Variables initialisation
version="resetHomeSync v1.2 - 2016, Yvan Godard [godardyvan@gmail.com]"
SystemOS=$(sw_vers -productVersion | awk -F "." '{print $0}')
SystemOSMajor=$(sw_vers -productVersion | awk -F "." '{print $1}')
SystemOSMinor=$(sw_vers -productVersion | awk -F "." '{print $2}')
SystemOSPoint=$(sw_vers -productVersion | awk -F "." '{print $3}')
scriptDir=$(dirname "${0}")
scriptName=$(basename "${0}")
githubRemoteScript="https://raw.githubusercontent.com/yvangodard/resetHomeSync/master/resetHomeSync.sh"

if [ `whoami` != 'root' ]; then
	echo "Ce script doit être utilisé par le compte root. Utilisez SUDO."
	exit 1
fi

echo ""
echo "****************************** `date` ******************************"
echo "${scriptName} démarré..."
echo "sur Mac OSX version ${SystemOS}"
echo ""

# Check URL
function checkUrl() {
  command -p curl -Lsf "$1" >/dev/null
  echo "$?"
}

# Changement du séparateur par défaut et mise à jour auto
OLDIFS=$IFS
IFS=$'\n'
# Auto-update script
if [[ $(checkUrl ${githubRemoteScript}) -eq 0 ]] && [[ $(md5 -q "$0") != $(curl -Lsf ${githubRemoteScript} | md5 -q) ]]; then
	[[ -e "$0".old ]] && rm "$0".old
	mv "$0" "$0".old
	curl -Lsf ${githubRemoteScript} >> "$0"
	echo "Une mise à jour de ${0} est disponible."
	echo "Nous la téléchargeons depuis GitHub."
	if [ $? -eq 0 ]; then
		echo "Mise à jour réussie, nous relançons le script."
		chmod +x "$0"
		exec ${0} "$@"
		exit $0
	else
		echo "Un problème a été rencontré pour mettre à jour ${0}."
		echo "Nous poursuivons avec l'ancienne version du script."
	fi
	echo ""
fi
IFS=$OLDIFS

# $1 est le nom du compte utilisateur
# test si un nom de compte user est entré en paramètre
if [[ ! -z $1 ]]; then
	userName=$1
	dirUser=/Users/${userName%/}
	[[ ! -d ${dirUser} ]] && echo "Le dossier de départ ${dirUser} n'existe pas. Nous quittons" && exit 1	
	echo "Merci de patienter. Le processus peut mettre quelques minutes à s'exécuter..."
	echo " "
	# Suppression des fichiers
	echo "Suppression des fichiers et dossiers suivants : "
	[[ -e ${dirUser}/.FileSync ]] && echo "   - ${dirUser}/.FileSync" && rm -R ${dirUser}/.FileSync
	[[ -e ${dirUser}/Library/FileSync ]] && echo "   - ${dirUser}/Library/FileSync" && rm -R ${dirUser}/Library/FileSync
	ls ${dirUser}/Library/Logs/FileSync*  > /dev/null 2>&1
	[ $? -eq 0 ] && echo "   - ${dirUser}/Library/Logs/FileSync*" && rm -R ${dirUser}/Library/Logs/FileSync*
	[[ -e ${dirUser}/Library/Application\ Support/SyncServices ]] && echo "   - ${dirUser}/Library/Application Support/SyncServices" && rm -R ${dirUser}/Library/Application\ Support/SyncServices
	[[ -e ${dirUser}/Library/Application\ Support/MobileSync ]] && echo "   - ${dirUser}/Library/Application Support/MobileSync" && rm -R ${dirUser}/Library/Application\ Support/MobileSync
	ls ${dirUser}/Library/Preferences/ByHost/com.apple.syncservices.*.plist > /dev/null 2>&1
	[ $? -eq 0 ] && echo "   - ${dirUser}/Library/Preferences/ByHost/com.apple.syncservices.*.plist" && rm -R ${dirUser}/Library/Preferences/ByHost/com.apple.syncservices.*.plist
	[[ -e ${dirUser}/Library/Preferences/com.apple.homeSync.plist ]] && echo "   - ${dirUser}/Library/Preferences/com.apple.homeSync.plist" && rm -R ${dirUser}/Library/Preferences/com.apple.homeSync.plist
	[[ -e ${dirUser}/Library/Preferences/com.apple.MCX.plist ]] && echo "   - ${dirUser}/Library/Preferences/com.apple.MCX.plist" && rm -R ${dirUser}/Library/Preferences/com.apple.MCX.plist
	[[ -e ${dirUser}/Library/Preferences/com.apple.FileSyncUI.plist ]] && echo "   - ${dirUser}/Library/Preferences/com.apple.FileSyncUI.plist" && rm -R ${dirUser}/Library/Preferences/com.apple.FileSyncUI.plist
	[[ -e ${dirUser}/Library/Preferences/com.apple.MirrorAgent.plist ]] && echo "   - ${dirUser}/Library/Preferences/com.apple.MirrorAgent.plist" && rm -R ${dirUser}/Library/Preferences/com.apple.MirrorAgent.plist
	[[ -e ${dirUser}/Library/Preferences/com.apple.PreferenceSync.plist ]] && echo "   - ${dirUser}/Library/Preferences/com.apple.PreferenceSync.plist" && rm -R ${dirUser}/Library/Preferences/com.apple.PreferenceSync.plist
	[[ -e ${dirUser}/Library/Preferences/com.apple.FileSyncAgent.plist ]] && echo "   - ${dirUser}/Library/Preferences/com.apple.FileSyncAgent.plist" && rm -R ${dirUser}/Library/Preferences/com.apple.FileSyncAgent.plist
	ls /Library/Managed\ Preferences/${userName%/}/com.apple.syncservices.*.plist > /dev/null 2>&1
	[ $? -eq 0 ] && echo "   - /Library/Managed Preferences/${userName%/}/com.apple.syncservices.*.plist" && rm -R /Library/Managed\ Preferences/${userName%/}/com.apple.syncservices.*.plist
	[[ -e /Library/Managed\ Preferences/${userName%/}/com.apple.homeSync.plist ]] && echo "   - /Library/Managed Preferences/${userName%/}/com.apple.homeSync.plist" && rm -R /Library/Managed\ Preferences/${userName%/}/com.apple.homeSync.plist
	[[ -e /Library/Managed\ Preferences/${userName%/}/com.apple.MCX.plist ]] && echo "   - /Library/Managed Preferences/${userName%/}/com.apple.MCX.plist" && rm -R /Library/Managed\ Preferences/${userName%/}/com.apple.MCX.plist
	[[ -e /Library/Managed\ Preferences/${userName%/}/com.apple.FileSyncUI.plist ]] && echo "   - /Library/Managed Preferences/${userName%/}/com.apple.FileSyncUI.plist" && rm -R /Library/Managed\ Preferences/${userName%/}/com.apple.FileSyncUI.plist
	[[ -e /Library/Managed\ Preferences/${userName%/}/com.apple.MirrorAgent.plist ]] && echo "   - /Library/Managed Preferences/${userName%/}/com.apple.MirrorAgent.plist" && rm -R /Library/Managed\ Preferences/${userName%/}/com.apple.MirrorAgent.plist
	[[ -e /Library/Managed\ Preferences/${userName%/}/com.apple.PreferenceSync.plist ]] && echo "   - /Library/Managed Preferences/${userName%/}/com.apple.PreferenceSync.plist" && rm -R /Library/Managed\ Preferences/${userName%/}/com.apple.PreferenceSync.plist
	[[ -e /Library/Managed\ Preferences/${userName%/}/com.apple.FileSyncAgent.plist ]] && echo "   - /Library/Managed Preferences/${userName%/}/com.apple.FileSyncAgent.plist" && rm -R /Library/Managed\ Preferences/${userName%/}/com.apple.FileSyncAgent.plist
	# Correction des droits
	echo ""
	echo "Correction des permissions du dossier utilisateur : "
	echo "Merci de patienter. Le processus peut mettre quelques minutes à s'exécuter..."
	if [[ ${SystemOSMajor} -eq 10 && ${SystemOSMinor} -ge 11 ]] || [[ ${SystemOSMajor} -gt 10 ]]; then
		if [[ ${userName%/} == "Shared" ]]; then
	        chmod -R 777 /Users/${userName%/}
	    else
	    	# userID=$(dscl . -read /Users/${userName%/} UniqueID | awk '{print $2}')
			userID=$(/usr/bin/id -u ${userName%/})
			# Reset the users Home Folder permissions.
			/usr/sbin/diskutil resetUserPermissions / ${userID}
		fi
	elif [[ ${SystemOSMajor} -eq 10 && ${SystemOSMinor} -le 10 ]]; then
		if [[ ${userName%/} == "Shared" ]]; then
	        chmod -R 777 /Users/${userName%/}
	    else
	    	# Suppression des ACL
	    	chmod -R -N /Users/${userName%/}
	    	chflags -R nouchg,nouappnd ~ $TMPDIR..
	    	# Correction du propriétaire
	    	chown -R ${userName%/}:staff /Users/${userName%/}
	    	# Droits par défaut
	    	chmod -R 700 /Users/${userName%/}
	    	# Droit d'accès au dossier
	        chmod 755 /Users/${userName%/}
	        [ -d /Users/${userName%/}/Public ] && chmod -R 755 /Users/${userName%/}/Public/
	        [ -d /Users/${userName%/}/Public/Drop\ Box ] && chmod -R 733 /Users/${userName%/}/Public/Drop\ Box/
	        [ -d /Users/${userName%/}/Sites ] && chmod -R 755 /Users/${userName%/}/Sites/
	        ls /Users/${userName%/}/Sites/* > /dev/null 2>&1
			[ $? -eq 0 ] && chmod -R 644 /Users/${userName%/}/Sites/*
	        [ -d /Users/${userName%/}/Sites/images ] && chmod -R 755 /Users/${userName%/}/Sites/images
	    fi
	fi
	echo "" && echo "Fin du processus." && echo "" && echo "Il est conseillé de rebooter maintenant."
	read -p "Rebooter maintenant (y/n) ? " choice
	case "$choice" in 
		oui|Oui|OUI|o|O|y|Y|Yes|yes|YES ) echo "Nous rebootons dans 1 minute, fermez vos applications et sauvegardez vos documents ouverts." && sleep 60 && shutdown -r now ;;
		non|Non|NON|n|N|No|NO|no ) echo "";;
		* ) echo "Réponse invalide, nous ne rebootons pas.";;
	esac
else
	echo "Vous devez entrer le nom du compte utilisateur en paramètre \$1."
	echo "Par exemple : ${scriptDir%/}/${scriptName} c.toto"
	exit 1
fi
exit 0