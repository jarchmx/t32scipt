#!/bin/sh

usage()
{
    cat << EOF
    Usage:
    $0 <options ...>

      Global:
      -p [product, Ex: mdm9xxx/sdx55]
      -f [vmlinux file]
      -h [this help]
EOF
    exit 1
}

T32SCT=`which $0 `
T32CONFDIR=`dirname $T32SCT`

#default is for sdx55
cmmfile=$T32CONFDIR/t32_startup_script.cmm.template.sdx55

while getopts "p:f:h" arg
do
    case $arg in
    p)
        case $OPTARG in
        mdm9xxx)
            cmmfile=$T32CONFDIR/t32_startup_script.cmm.template.mdm9xxx
            ;;
        sdx55)
            cmmfile=$T32CONFDIR/t32_startup_script.cmm.template.sdx55
            ;;
        ?)
            echo "Wrong product $OPTARG, only support mdm9xxx/sdx55"
            usage
            ;;
        esac
        ;;
    f)
        VMLINUX=$OPTARG
        ;;
    h)
        usage
        ;;
    ?)
        echo "$0: invalid option -$OPTARG" 1>&2
        usage
        ;;

    esac
done

VMLINUX=`echo $VMLINUX | sed 's#\/#\\\/#g'`
sed "s/@VMLINUX@/$VMLINUX/g" $cmmfile >/tmp/t32_startup_script.cmm
/opt/t32/bin/pc_linux64/t32marm-qt -c $T32CONFDIR/t32_config.t32, /tmp/t32_startup_script.cmm &
