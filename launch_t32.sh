#!/bin/sh


usage()
{
    echo "Usage:"
    echo "    $0 [vmlinux file]"
    echo ""
    exit 1
}

if [[ -z $1 || ! -f $1 ]];then
    usage
fi

VMLINUX=`echo $1 | sed 's#\/#\\\/#g'`
T32SCT=`which $0 `
T32CONFDIR=`dirname $T32SCT`
sed "s/@VMLINUX@/$VMLINUX/g" $T32CONFDIR/t32_startup_script.cmm.template >/tmp/t32_startup_script.cmm
/opt/t32/bin/pc_linux64/t32marm-qt -c $T32CONFDIR/t32_config.t32, /tmp/t32_startup_script.cmm &
