#!/bin/bash

# run this on Linux or Mac are both fine.

echo insure you are running this script in the same directory as src, 
echo   eg. chromium/
echo running this command: 
echo 
echo  "sh pack_cronet.sh out/XXX  linux|mac"
echo 

function check_if_file_exist(){
	if [[ ! -f $1 ]]; then
	    echo file: $1 not exist!
	    rm -rf $target_dir
	    exit 1
	fi	
}

tar_on_linux(){
    libroot=src/out/${outdir}
    jarroot=$libroot/lib.java/components/cronet/android
	headerroot=src/components/cronet/android/

	libcronet=$libroot/libcronet.75.0.3770.100.so
    cronet_api=$jarroot/cronet_api_java.jar
    cronet_api_interface=$jarroot/cronet_api_java.interface.jar
  	cronet_impl_platform_base=$jarroot/cronet_impl_platform_base_java.jar
	cronet_impl_common_base=$jarroot/cronet_impl_common_base_java.jar
	cronet_impl_platform_base_interface=$jarroot/cronet_impl_platform_base_java.interface.jar
	
	cronet_bidirectional_stream_adapter=$headerroot/cronet_bidirectional_stream_adapter.h
	cronet_integrated_mode_state=$headerroot/cronet_integrated_mode_state.h
	cronet_library_loader=$headerroot/cronet_library_loader.h
	cronet_upload_data_stream_adapter=$headerroot/cronet_upload_data_stream_adapter.h
	cronet_url_request_adapter=$headerroot/cronet_url_request_adapter.h
	cronet_url_request_context_adapter=$headerroot/cronet_url_request_context_adapter.h
	io_buffer_with_byte_buffer=$headerroot/io_buffer_with_byte_buffer.h
	url_request_error=$headerroot/url_request_error.h
  
	# dynamic lib
	check_if_file_exist $libcronet;
	
	# jar files
	check_if_file_exist $cronet_api;
	check_if_file_exist $cronet_api_interface;
	check_if_file_exist $cronet_impl_platform_base;
	check_if_file_exist $cronet_impl_common_base;
	check_if_file_exist $cronet_impl_platform_base_interface;

	# header files
	check_if_file_exist $cronet_bidirectional_stream_adapter;
	check_if_file_exist $cronet_integrated_mode_state;
	check_if_file_exist $cronet_library_loader;
	check_if_file_exist $cronet_upload_data_stream_adapter;
	check_if_file_exist $cronet_url_request_adapter;
	check_if_file_exist $cronet_url_request_context_adapter;
	check_if_file_exist $io_buffer_with_byte_buffer;
	check_if_file_exist $url_request_error;

	cp $libcronet ${target_dir}/
       
	cp $cronet_api ${target_dir}/
	cp $cronet_api_interface ${target_dir}/
	cp $cronet_impl_platform_base ${target_dir}/
	cp $cronet_impl_common_base ${target_dir}/
	cp $cronet_impl_platform_base_interface ${target_dir}/
 
	cp $cronet_bidirectional_stream_adapter ${target_dir}/
	cp $cronet_integrated_mode_state ${target_dir}/
	cp $cronet_library_loader ${target_dir}/
	cp $cronet_upload_data_stream_adapter ${target_dir}/
	cp $cronet_url_request_adapter ${target_dir}/
	cp $cronet_url_request_context_adapter ${target_dir}/
	cp $io_buffer_with_byte_buffer ${target_dir}/
	cp $url_request_error ${target_dir}/
}

tar_on_mac(){
	libcronet=src/out/${outdir}/obj/components/cronet/ios/libcronet.a
	headerroot=src/components/cronet/ios

	Cronet=$headerroot/Cronet.h
	cronet_environment=$headerroot/cronet_environment.h
	cronet_metrics=$headerroot/cronet_metrics.h	

	# static lib
	check_if_file_exist $libcronet;
	
	# header files
	check_if_file_exist  $Cronet;
	check_if_file_exist  $cronet_environment;
	check_if_file_exist  $cronet_metrics;
	
	cp $libcronet  $target_dir/
 
	cp $Cronet $target_dir/
	cp $cronet_environment $target_dir/
	cp $cronet_metrics $target_dir/
}

# check if params is valid


outdir=$1
if [[ -d src/out/$out_dir ]]; then
	echo you set source directory as src/out/$outdir 
else
	echo error: check if directory "$1" exist 
    exit
fi

if [[ $2 == "linux" ]]; then
	echo you select linux as running platform
	target_dir=Android_Cronet_${out_dir}
	mkdir $target_dir 
	tar_on_linux
elif [[ $2 == "mac" ]]; then
	echo you select mac as running platform
	target_dir=iOS_Cronet_${out_dir}
	mkdir $target_dir 
	tar_on_mac
else
	echo error: unknown os, make sure you are running on linux or mac!
fi

echo packing...
tar -jcf ${target_dir}.bz2 $target_dir
rm -rf $target_dir
echo done.
