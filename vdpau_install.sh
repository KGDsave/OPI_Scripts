#/bin/sh
if [ `id -u` -ne 0 ]; then 
echo "Please re-run vdpau_install.sh as root." 
exit 1 
fi 
clear
echo cedar module either compiled in or the module loaded
echo write access permissions on /dev/disp and /dev/cedar_dev
echo on A10/A20, A13, add /dev/g2d for osd
echo on A33 or H3, add /dev/ion
echo press ENTER  to continue!
read
echo Cheaking Library....
echo uninstalling vdpau lib old version.....
echo please press y to uninstall it!
#
sudo apt-get purge libvdpau1
echo install linvdpau-dev...
#
sudo apt-get install git libvdpau-dev gawk pkg-config
echo Get Files Start!
echo use git to clone the Libvdpau_sunxi
#
git clone https://github.com/linux-sunxi/libvdpau-sunxi.git
echo gitting library...
echo libcedrus provides low-level access to the video engine of Allwinner sunxi SoCs.
#
git clone https://github.com/linux-sunxi/libcedrus.git
wget https://www.cairographics.org/releases/pixman-0.34.0.tar.gz
if [ ! -d "libvdpau-sunxi" ]; then  
    echo "the libvdpau-sunxi Not Found!"  
else  
    echo "Cheak LibVdpau_SUNXI......Done..."  
fi
if [ ! -d "libcedrus" ]; then  
    echo "File--LibCedurs not found!"  
else  
    echo "Cheak libcedurs........Done...."  
fi
if [ ! -f "pixman-0.34.0.tar.gz" ]; then  
    echo "Error: file : pixman-0.34.0 not found! "  
else  
    echo unpacking pixman.tar.gz
	tar -zxvf pixman-0.34.0.tar.gz
fi  
if [ ! -d "pixman-0.34.0" ]; then  
    echo "pixman not found!"  
else  
    echo "ok! Start Make!"
    echo "It will cost you about 30 minutes to compile or wait. If you see an error on the way, please exit the program to fix the error, otherwise the compilation will fail."
    sleep 5
	echo start make!
	cd pixman-0.34.0
	sudo ./configure
	sudo make
	sudo make install
	cd ..
	cd libcedrus
	make
	sudo make install
	cd ..
	cd libvdpau-sunxi
	make
	sudo make install
	cd ..
	export VDPAU_DRIVER=sunxi
	echo Exiting...
	echo use---export VDPAU_DRIVER=sunxi---can fix some error!
	echo you can use: mplayer -vo vdpau -vc ffmpeg12vdpau,ffh264vdpau, [filename] to play video by Mplayer
	echo and also use: mpv --vo=vdpau --hwdec=vdpau --hwdec-codecs=all [filename] to play video by MPV
	echo Install Done!
	echo press ENTER to exit!
	read
	exit
fi
echo Somethings were Borken! please fix them.
exit



