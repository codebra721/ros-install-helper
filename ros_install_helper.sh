#it is for ROS install

echo ""
echo "welcome to use ROS install helper!!!"
echo "[NOTE] Target OS version >>> Ubuntu 20.04"
echo "[NOTE] Target ROS version >>> ROS Noetic"
echo ""
echo "PRESS [ENTER] TO CONTINUE THE INSTALLATION"
echo "IF YOU WANT TO CANCEL, PRESS [CTRL] + [C]"
read

echo "PREPARE TO INSTALL ROS -------"
echo "Please sclect ROS version(Melodic or Noetic)"
read -p "" name_ros_version
while true; do
	case $name_ros_version in
		MELODIC|melodic* ) name_ros_version:="melodic"; break;;	
		NOETIC|noetic* ) name_ros_version:="noetic"; break;;
		* ) read -p "Please sclect ROS version(Melodic or Noetic)" name_ros_version;;
	esac
done
echo "[add the ros repository]"
if [ ! -e /etc/apt/source.list.d/ros-latest.list]; then
	sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
fi

echo "[Download the ROS key]"
roskeystatue='apt-key list | grep "Open Robotics"'
sudo apt-get --assume-yes install curl
if [ -z "$roskeystatue"]; then
	curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
fi

echo "[Check the ROS keys]"
roskeystatue=`apt-key list | grep "Open Robotics"`
if [ -n "$roskeystatue" ]; then
  echo "[ROS key already exists in the list]"
else
  echo "[Failed to receive the ROS key, aborts the installation]"
  exit 0
fi

echo "[update the package list]"
sudo apt update -y

echo " "
echo "Which version of ROS libraries do you want to install?"
echo "Desktop-Full(f) (Recommended, includes simulators)"
echo "Desktop(d) (ROS-Base plus tools like rqt and rviz)"
echo "Base(b) (No GUI ROS, just have libraries)"
read -p "" yn
while true; do
    	case $yn in
         	F|f* ) ROSInstallversion:="desktop-full"; break;;
           	D|d* ) ROSInstallversion:="desktop"; break;;
        	B|b* ) ROSInstallversion:="ros-base"; break;;
		* ) read -p "Please enter full(f) or desktop(d) or Base(b)" yn;;
	esac
done

echo "[install ROS]"
sudo apt-get --assume-yes install ros-$name_ros_version-$ROSInstallversion

echo "[setting on the computer]"
sudo apt-get --assume-yes install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
source /opt/ros/noetic/setup.bash
echo "source /opt/ros/$name_ros_version/setup.bash" >> ~/.bashrc
source ~/.bashrc

echo "[install complete!!!]"
roscore
