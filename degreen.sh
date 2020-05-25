#!/bin/bash

echo -e "Welcome to Degreener!\nLet's make Ubuntu Mate beautiful.\n"


function hidpiMode {
	# Enable HiDPI for desktop
	gsettings set org.mate.interface window-scaling-factor 2

	# Enable HiDPI for logon greeter
	echo -e "To properly set the login greeter you will need to update settings in lightdm-settings.\n"
	read -n 1 -s -r -p "Settings -> HiDPI support: enable. Press any key to continue..."
	sudo sh -c "lightdm-settings" > /dev/null 2>&1
	echo "Applied HiDPI settings..."
}

function setWall {
	dconf read /org/mate/desktop/interface/gtk-theme > ./dump_theme.bak
	dconf read /org/mate/desktop/background/picture-filename > ./dump_wall.bak
	dconf write /org/mate/desktop/background/picture-filename "'/usr/share/backgrounds/ubuntu-mate-photos/matteo-botto-16023.jpg'"
}

function setTheme {
	dconf write /org/mate/desktop/interface/gtk-theme "'Ambiant-MATE-Dark-Orange'"
	dconf write /org/mate/marco/general/theme "'Ambiant-MATE-Dark-Orange'"
	dconf write /org/mate/desktop/interface/icon-theme "'Ambiant-MATE-Orange'"
	dconf write /org/mate/desktop/interface/cursor-theme "'mate-black'"
}

function setColorRepo {
	sudo add-apt-repository ppa:lah7/ubuntu-mate-colours
	sudo apt-get update
}

function setAllColors {
	sudo apt install ubuntu-mate-colours-all
	setTheme
	mate-appearance-properties &
}

function setOrange {
	sudo apt install ubuntu-mate-colours-orange
	setTheme
}

function uninstall {
	orgTheme=`cat ./dump_theme.bak`
	orgWall=`cat ./dump_wall.bak`
	dconf write /org/mate/desktop/interface/gtk-theme $orgTheme
	dconf write /org/mate/marco/general/theme $orgTheme
	dconf write /org/mate/desktop/interface/icon-theme $orgTheme
	dconf write /org/mate/desktop/background/picture-filename $orgWall
	dconf write /org/mate/desktop/interface/cursor-theme "'mate'"

	# Remove PPA repo - assuming the above original theme was not reset to one of the PPA themes
	# If it was then set the theme back to the original ugly green theme
	sudo add-apt-repository --remove ppa:lah7/ubuntu-mate-colours
	sudo apt-get update
}


while true; do
	read -rep $'\nWould you like to enable HiDPI (2x scale) mode? (y/n)\n' yn
			case $yn in
				[Yy]* ) yn="y"; break;;
				[Nn]* ) yn="n";break;;
				* ) echo "Please answer yes or no.";;
			esac
		done

if [ "$yn" == "y" ];then
	hidpiMode
fi

if [ $# -eq 0 ]; then
	echo -e "\nDegreen Ubuntu Mate\n"
	echo "  1) Ubuntu Dark Orange Default"
	echo "  2) Customize"
	echo "  3) Uninstall"

	read n

	set "$n"
fi

if [ "$n" == "1" ];then
	setWall
	setColorRepo
	setOrange
	pkill lightdm-settings
fi

if [ "$n" == "2" ];then
	echo "For now Customize will install many colored themes and you can then select the one want."
	setWall
	setColorRepo
	setAllColors
	pkill lightdm-settings
fi

if [ "$n" == "3" ];then
        uninstall
fi

