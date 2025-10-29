#!/usr/bin/env bash
# Simple sysinfo as key=val



os=$(uname -o || echo "UNIX based")
cc=$(cc --version | awk '{print $2,$3}' || echo "null")
ld=$(ld --version | awk '{print $1,$2, $5}' || echo "null")
as=$(as --version | awk '{print $1,$2,$5}' || echo "null")
hostname=$(uname -n || echo "null")

kern_name=$(uname -s || echo "UNIX based")
kern_rel=$(uname -r || echo "null")
kern_ver=$(uname -v || echo "null")

arch=$(uname -m || echo "null")
vendor=$(grep -m1 '^vendor_id' /proc/cpuinfo | cut -d: -f2 | xargs || echo "null")
model=$(grep -m1 '^model name' /proc/cpuinfo | cut -d: -f2 | xargs || echo "null")
cores=$(nproc || echo "0")
flags=$(grep -m1 '^flags' /proc/cpuinfo | cut -d: -f2 | xargs || echo "null")

l1d=$(lscpu 2>/dev/null | awk '/L1d cache:/ {print $3}' || echo "0")
l1d_SIZE=$(lscpu 2>/dev/null | awk '/L1d cache:/ {print $4}' || echo "0")
l1d_X=$(lscpu 2>/dev/null | awk '/L1d cache:/ {print $5}' || echo "0")

l1i=$(lscpu 2>/dev/null | awk '/L1i cache:/ {print $3}' || echo "0")
l1i_SIZE=$(lscpu 2>/dev/null | awk '/L1i cache:/ {print $4}' || echo "0")
l1i_X=$(lscpu 2>/dev/null | awk '/L1i cache:/ {print $5}' || echo "0")

l2=$(lscpu 2>/dev/null | awk '/L2 cache:/ {print $3}' || echo "0")
l2_SIZE=$(lscpu 2>/dev/null | awk '/L2 cache:/ {print $4}' || echo "0")
l2_X=$(lscpu 2>/dev/null | awk '/L2 cache:/ {print $5}' || echo "0")

l3=$(lscpu 2>/dev/null | awk '/L3 cache:/ {print $3}' || echo "0")
l3_SIZE=$(lscpu 2>/dev/null | awk '/L3 cache:/ {print $4}' || echo "0")
l3_X=$(lscpu 2>/dev/null | awk '/L3 cache:/ {print $5}' || echo "0")

microcode=$(grep -m1 '^microcode' /proc/cpuinfo | cut -d: -f2 | xargs || echo "null")
mem_total=$(awk '/MemTotal/ {print int($2/1024)"MB"}' /proc/meminfo || echo "0")

# Output key=value lines
echo "os=$os"
echo "cc=$cc"
echo "linker=$ld"
echo "assembler=$as"
echo "hostname=$hostname"
echo "kern_name=$kern_name"
echo "kern_rel=$kern_rel"
echo "kern_ver=$kern_ver"
echo "cpu_arch=$arch"
echo "cpu_vendor=$vendor"
echo "cpu_model=$model"
echo "cpu_cores=$cores"
echo "cpu_flags=$flags"
echo "cpu_cache_l1d=$l1d"
echo "cpu_cache_l1d_SIZE=$l1d_SIZE"
echo "cpu_cache_l1d_X=$l1d_X)"
echo "cpu_cache_l1i=$l1i"
echo "cpu_cache_l1i_SIZE=$l1i_SIZE"
echo "cpu_cache_l1i_X=$l1i_X)"
echo "cpu_cache_l2=$l2"
echo "cpu_cache_l2_SIZE=$l2_SIZE"
echo "cpu_cache_l2_X=$l2_X)"
echo "cpu_cache_l3=$l3"
echo "cpu_cache_l3_SIZE=$l3_SIZE"
echo "cpu_cache_l3_X=$l3_X)"
echo "mem_total=$mem_total"

