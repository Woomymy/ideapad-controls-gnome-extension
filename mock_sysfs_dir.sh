#!/usr/bin/env bash

basedir="sysfs-test"
mkdir -p $basedir

for file in camera_power conservation_mode fn_lock touchpad usb_charging
do
    echo "0" > "${basedir}/${file}"
done

