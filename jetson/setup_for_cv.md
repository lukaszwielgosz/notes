# Setup for computer vision
based on
https://www.pyimagesearch.com/2020/03/25/how-to-configure-your-nvidia-jetson-nano-for-computer-vision-and-deep-learning/

```
sudo apt update
sudo apt-get purge libreoffice*
sudo apt-get clean
sudo apt-get update && sudo apt-get upgrade
```

Install system-level dependencies
```
sudo apt-get install git cmake
sudo apt-get install libatlas-base-dev gfortran
sudo apt-get install libhdf5-serial-dev hdf5-tools
sudo apt-get install python3-dev
sudo apt-get install nano locate
sudo apt-get install libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran
```

SciPy prerequisites
```
sudo apt-get install libfreetype6-dev python3-setuptools
sudo apt-get install protobuf-compiler libprotobuf-dev openssl
sudo apt-get install libssl-dev libcurl4-openssl-dev
sudo apt-get install cython3
```

XML tools for working with TensorFlow Object Detection (TFOD) API projects:
```
sudo apt-get install libxml2-dev libxslt1-dev
```

Update CMake:
```
wget http://www.cmake.org/files/v3.13/cmake-3.13.0.tar.gz
tar xpvf cmake-3.13.0.tar.gz cmake-3.13.0/
cd cmake-3.13.0/
./bootstrap --system-curl
make -j4
echo 'export PATH=/home/nvidia/cmake-3.13.0/bin/:$PATH' >> ~/.bashrc
source ~/.bashrc
```

Install OpenCV system-level dependencies and other development dependencies
```
sudo apt-get install build-essential pkg-config -y
sudo apt-get install libtbb2 libtbb-dev -y
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev -y
sudo apt-get install libxvidcore-dev libavresample-dev -y
sudo apt-get install libtiff-dev libjpeg-dev libpng-dev -y
sudo apt-get install python-tk libgtk-3-dev -y
sudo apt-get install libcanberra-gtk-module libcanberra-gtk3-module -y
sudo apt-get install libv4l-dev libdc1394-22-dev -y
```

Get pip
```
wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py
rm get-pip.py
```

Setup virutal envs
```
sudo pip install virtualenv virtualenvwrapper
nano ~/.bashrc
```
add at the bottom:
```
# virtualenv and virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
```

```
source ~/.bashrc
```

```
mkvirtualenv py3cv4 -p python3
workon py3cv4
```

```
wget https://raw.githubusercontent.com/jkjung-avt/jetson_nano/master/install_protobuf-3.6.1.sh
sudo chmod +x install_protobuf-3.6.1.sh
./install_protobuf-3.6.1.sh
workon py3cv4 # if you aren't inside the environment
cd ~
cp -r ~/src/protobuf-3.6.1/python/ .
cd python
python setup.py install --cpp_implementation
```

Install TensorFlow, Keras, NumPy and SciPy
```
workon py3cv4
pip install numpy cython # if illegal instruction error segmentation fault install older numpy
#pip install numpy==1.19.4
pip install numpy==1.16.1
```

```
pip install numpy==1.16.1 future==0.18.2 mock==3.0.5 h5py==2.10.0 keras_preprocessing==1.1.1 keras_applications==1.0.8 gast==0.2.2 futures cython
```

Install SciPy:
```
wget https://github.com/scipy/scipy/releases/download/v1.3.3/scipy-1.3.3.tar.gz

tar -xzvf scipy-1.3.3.tar.gz scipy-1.3.3

cd scipy-1.3.3/

python setup.py install
```

```
pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v42 tensorflow-gpu==1.13.1+nv19.3

pip install keras
```

Install TensorFlow Object Detection API:
```
cd ~
git clone https://github.com/tensorflow/models
cd models && git checkout -q b00783d
cd ~
git clone https://github.com/cocodataset/cocoapi.git
cd cocoapi/PythonAPI
python setup.py install

cd ~/models/research/
protoc object_detection/protos/*.proto --python_out=.
nano ~/setup.sh
```
insert
```
#!/bin/sh
export PYTHONPATH=$PYTHONPATH:/home/`whoami`/models/research:\
/home/`whoami`/models/research/slim
```


Install NVIDIA's `tf_trt_models`
```
workon py3cv4
cd ~
git clone --recursive https://github.com/NVIDIA-Jetson/tf_trt_models.git
cd tf_trt_models
./install.sh
```

Install OpenCV 4.1.2
```
cd ~
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.1.2.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.1.2.zip

unzip opencv.zip
unzip opencv_contrib.zip
mv opencv-4.1.2 opencv
mv opencv_contrib-4.1.2 opencv_contrib
```