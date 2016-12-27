#!/bin/bash
clear
echo -e "-------------------------------------------------------------"
echo -e "        Google BBR拥塞控制算法                           "
echo -e "    \033[41;37m 1.目前支持CENOTS6和7 \033[0m"
echo -e "    \033[41;37m 2.安装前请百度、google什么是BBR，出任何问题概不负责 \033[0m"
echo -e "    \033[41;37m 本脚本发布于群号140155447，作者CHORD \033[0m"
echo -e "-------------------------------------------------------------"
echo "按任意键继续"
read -n1
if [ $(id -u) != "0" ]; then
    echo "请使用ROOT权限运行此脚本, 例如bash Centos_bbr.sh"
    exit
fi

echo -n "即将替换内核，回车继续"
read -n1
clear
echo "开始替换内核，请耐心等待"
if grep -Eqi "release 6." /etc/redhat-release; then
    yum install -y https://mirrors.tuna.tsinghua.edu.cn/elrepo/kernel/el6/x86_64/RPMS/kernel-ml-4.9.0-1.el6.elrepo.x86_64.rpm
    sed -i 's:default=.*:default=0:g' /etc/grub.conf
elif grep -Eqi "release 7." /etc/redhat-release; then
    yum install -y https://mirrors.tuna.tsinghua.edu.cn/elrepo/kernel/el7/x86_64/RPMS/kernel-ml-4.9.0-1.el7.elrepo.x86_64.rpm
    grub2-set-default 0
fi
if [ ! `cat /etc/sysctl.conf | grep -i -E "net.core.default_qdisc=fq"` ]; then
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
fi
if [ ! `cat /etc/sysctl.conf | grep -i -E "net.ipv4.tcp_congestion_control=bbr"` ]; then
	echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
fi
sysctl -p >/dev/null 2>&1
echo -n "重启后生效，是否重启？[y]："
read is_reboot
if [ $is_reboot = "y" -o $is_reboot = "Y" ]; then
	    reboot
	else
	    exit
	fi