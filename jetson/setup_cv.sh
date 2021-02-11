sudo apt update
sudo apt-get purge libreoffice* -y
sudo apt-get clean -y
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install git cmake -y
sudo apt-get install libatlas-base-dev gfortran -y
sudo apt-get install libhdf5-serial-dev hdf5-tools -y
sudo apt-get install python3-dev -y
sudo apt-get install nano locate -y
sudo apt-get install libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran -y
sudo apt-get install libfreetype6-dev python3-setuptools -y
sudo apt-get install protobuf-compiler libprotobuf-dev openssl -y
sudo apt-get install libssl-dev libcurl4-openssl-dev -y
sudo apt-get install cython3 -y
sudo apt-get install libxml2-dev libxslt1-dev -y

cd ~
wget http://www.cmake.org/files/v3.13/cmake-3.13.0.tar.gz
tar xpvf cmake-3.13.0.tar.gz cmake-3.13.0/
cd cmake-3.13.0/
./bootstrap --system-curl
make -j4
echo 'export PATH=/home/nvidia/cmake-3.13.0/bin/:$PATH' >> ~/.bashrc
source ~/.bashrc
cd ~

sudo apt-get install build-essential pkg-config -y
sudo apt-get install libtbb2 libtbb-dev -y
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev -y
sudo apt-get install libxvidcore-dev libavresample-dev -y
sudo apt-get install libtiff-dev libjpeg-dev libpng-dev -y
sudo apt-get install python-tk libgtk-3-dev -y
sudo apt-get install libcanberra-gtk-module libcanberra-gtk3-module -y
sudo apt-get install libv4l-dev libdc1394-22-dev -y

wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py

sudo pip install virtualenv virtualenvwrapper
echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.bashrc
echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3' >> ~/.bashrc
echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.bashrc
source ~/.bashrc

cd ~
mkvirtualenv py3cv4 -p python3
workon py3cv4
wget https://raw.githubusercontent.com/jkjung-avt/jetson_nano/master/install_protobuf-3.6.1.sh
sudo chmod +x install_protobuf-3.6.1.sh
./install_protobuf-3.6.1.sh
workon py3cv4 # if you aren't inside the environment
cd ~
cp -r ~/src/protobuf-3.6.1/python/ .
cd python
python setup.py install --cpp_implementation
pip install cython
pip install numpy==1.16.1 future==0.18.2 mock==3.0.5 h5py==2.10.0 keras_preprocessing==1.1.1 keras_applications==1.0.8 gast==0.2.2 futures

wget https://github.com/scipy/scipy/releases/download/v1.3.3/scipy-1.3.3.tar.gz
tar -xzvf scipy-1.3.3.tar.gz scipy-1.3.3
cd scipy-1.3.3/
python setup.py install

cd ~
pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v42 tensorflow-gpu==1.13.1+nv19.3
pip install keras


cd ~
git clone https://github.com/tensorflow/models
cd models && git checkout -q b00783d
cd ~
git clone https://github.com/cocodataset/cocoapi.git
cd cocoapi/PythonAPI
python setup.py install

cd ~/models/research/
protoc object_detection/protos/*.proto --python_out=.

touch ~/setup.sh
echo '#!/bin/sh' >> ~/.setup.sh
echo 'export PYTHONPATH=$PYTHONPATH:/home/`whoami`/models/research:\' >> ~/.setup.sh
echo '/home/`whoami`/models/research/slim' >> ~/.setup.sh

cd ~
git clone --recursive https://github.com/NVIDIA-Jetson/tf_trt_models.git
cd tf_trt_models
./install.sh

cd ~
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.1.2.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.1.2.zip

unzip opencv.zip
unzip opencv_contrib.zip
mv opencv-4.1.2 opencv
mv opencv_contrib-4.1.2 opencv_contrib