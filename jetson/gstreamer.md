# CS-MIPI-IMX307
http://wiki.veye.cc/index.php/CS-MIPI-IMX307_STARVIS_Module
http://wiki.veye.cc/index.php/CS-MIPI-IMX307_for_Jetson_Nano

'''
gst-launch-1.0 v4l2src ! "video/x-raw,format=(string)UYVY, width=(int)1920, height=(int)1080" ! nvvidconv ! "video/x-raw(memory:NVMM),format=(string)I420" ! nvoverlaysink sync=false
'''