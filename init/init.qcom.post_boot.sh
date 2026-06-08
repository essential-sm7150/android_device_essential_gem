#! /vendor/bin/sh

# Copyright (c) 2012-2013, 2016-2018, The Linux Foundation. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause

#Apply settings for sm6150
# Set the default IRQ affinity to the silver cluster. When a
# CPU is isolated/hotplugged, the IRQ affinity is adjusted
# to one of the CPU from the default IRQ affinity mask.
echo 3f > /proc/irq/default_smp_affinity

# Core control parameters on silver
echo 0 0 0 0 1 1 > /sys/devices/system/cpu/cpu0/core_ctl/not_preferred
echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/min_cpus
echo 60 > /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres
echo 40 > /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres
echo 100 > /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms
echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/is_big_cluster
echo 8 > /sys/devices/system/cpu/cpu0/core_ctl/task_thres
echo 0 > /sys/devices/system/cpu/cpu6/core_ctl/enable
# Setting b.L scheduler parameters
# default sched up and down migrate values are 71 and 65
echo 65 > /proc/sys/kernel/sched_downmigrate
echo 71 > /proc/sys/kernel/sched_upmigrate
# default sched up and down migrate values are 100 and 95
echo 85 > /proc/sys/kernel/sched_group_downmigrate
echo 100 > /proc/sys/kernel/sched_group_upmigrate
echo 1 > /proc/sys/kernel/sched_walt_rotate_big_tasks
# configure governor settings for little cluster
echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/rate_limit_us
echo 1248000 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_freq
echo 576000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
# configure governor settings for big cluster
echo "schedutil" > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo 0 > /sys/devices/system/cpu/cpu6/cpufreq/schedutil/rate_limit_us
echo 1324600 > /sys/devices/system/cpu/cpu6/cpufreq/schedutil/hispeed_freq
echo 652800 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
# sched_load_boost as -6 is equivalent to target load as 85. It is per cpu tunable.
echo -6 >  /sys/devices/system/cpu/cpu6/sched_load_boost
echo -6 >  /sys/devices/system/cpu/cpu7/sched_load_boost
echo 85 > /sys/devices/system/cpu/cpu6/cpufreq/schedutil/hispeed_load
echo "0:1248000" > /sys/module/cpu_boost/parameters/input_boost_freq
echo 40 > /sys/module/cpu_boost/parameters/input_boost_ms

# Enable bus-dcvs
for device in /sys/class/devfreq
do
    for cpubw in $device/*cpu-cpu-llcc-bw
    do
        echo "bw_hwmon" > $cpubw/governor
        echo 50 > $cpubw/polling_interval
        echo "2288 4577 7110 9155 12298 14236" > $cpubw/bw_hwmon/mbps_zones
        echo 4 > $cpubw/bw_hwmon/sample_ms
        echo 68 > $cpubw/bw_hwmon/io_percent
        echo 20 > $cpubw/bw_hwmon/hist_memory
        echo 0 > $cpubw/bw_hwmon/hyst_length
        echo 80 > $cpubw/bw_hwmon/down_thres
        echo 0 > $cpubw/bw_hwmon/guard_band_mbps
        echo 250 > $cpubw/bw_hwmon/up_scale
        echo 1600 > $cpubw/bw_hwmon/idle_mbps
    done
    for llccbw in $device/*cpu-llcc-ddr-bw
    do
        echo "bw_hwmon" > $llccbw/governor
        echo 40 > $llccbw/polling_interval
        echo "1144 1720 2086 2929 3879 5931 6881" > $llccbw/bw_hwmon/mbps_zones
        echo 4 > $llccbw/bw_hwmon/sample_ms
        echo 68 > $llccbw/bw_hwmon/io_percent
        echo 20 > $llccbw/bw_hwmon/hist_memory
        echo 0 > $llccbw/bw_hwmon/hyst_length
        echo 80 > $llccbw/bw_hwmon/down_thres
        echo 0 > $llccbw/bw_hwmon/guard_band_mbps
        echo 250 > $llccbw/bw_hwmon/up_scale
        echo 1600 > $llccbw/bw_hwmon/idle_mbps
    done
    for npubw in $device/*npu-npu-ddr-bw
    do
        echo 1 > /sys/devices/virtual/npu/msm_npu/pwr
        echo "bw_hwmon" > $npubw/governor
        echo 40 > $npubw/polling_interval
        echo "1144 1720 2086 2929 3879 5931 6881" > $npubw/bw_hwmon/mbps_zones
        echo 4 > $npubw/bw_hwmon/sample_ms
        echo 80 > $npubw/bw_hwmon/io_percent
        echo 20 > $npubw/bw_hwmon/hist_memory
        echo 10 > $npubw/bw_hwmon/hyst_length
        echo 30 > $npubw/bw_hwmon/down_thres
        echo 0 > $npubw/bw_hwmon/guard_band_mbps
        echo 250 > $npubw/bw_hwmon/up_scale
        echo 0 > $npubw/bw_hwmon/idle_mbps
        echo 0 > /sys/devices/virtual/npu/msm_npu/pwr
    done
    #Enable mem_latency governor for L3, LLCC, and DDR scaling
    for memlat in $device/*cpu*-lat
    do
        echo "mem_latency" > $memlat/governor
        echo 10 > $memlat/polling_interval
        echo 400 > $memlat/mem_latency/ratio_ceil
    done
    #Gold L3 ratio ceil
    echo 4000 > /sys/class/devfreq/soc:qcom,cpu6-cpu-l3-lat/mem_latency/ratio_ceil
    #Enable cdspl3 governor for L3 cdsp nodes
    for l3cdsp in $device/*cdsp-cdsp-l3-lat
    do
        echo "cdspl3" > $l3cdsp/governor
    done
    #Enable compute governor for gold latfloor
    for latfloor in $device/*cpu*-ddr-latfloor*
    do
        echo "compute" > $latfloor/governor
        echo 10 > $latfloor/polling_interval
    done
done
# Turn off scheduler boost at the end
echo 0 > /proc/sys/kernel/sched_boost
# Turn on sleep modes.
echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled

# Enable idle state listener
echo 1 > /sys/class/drm/card0/device/idle_encoder_mask
echo 100 > /sys/class/drm/card0/device/idle_timeout_ms

# Copy stock photos if present in vendor partitions (demo purposes only)
SDCARD=/data/media/0/
if [ -d "/vendor/media/stockphotos" ]; then
    if [ ! -e "/data/vendor/stockphotos_copied" ]; then
        mkdir -p $SDCARD/Pictures/
        cp -rf /vendor/media/stockphotos $SDCARD/Pictures/StockPhotos
        echo done > /data/vendor/stockphotos_copied
    fi
fi

setprop vendor.post_boot.parsed 1
