#!/bin/bash

SERVERS=(shizhan1 shizhan2 shizhan3 shizhan4)
echo $SERVERS

# for i in 1 2 3
# do
# eval $1
# done

#jps | grep QuorumPeerMain| awk '{print $1}'| xargs kill -9
# a=me
# b=$(printf 'I to %s' $a)
# echo $b

while getopts "a:b:c" arg #选项后面的冒号表示该选项需要参数
do
    case $arg in
        a)
			echo "a's arg:$OPTARG" #参数存在$OPTARG中
			;;
        b)
			echo "b's arg:$OPTARG"
			;;
        c)
			echo "c's arg:$OPTARG"
			;;
        ?)  #当有不认识的选项的时候arg为?
			echo "unkonw argument"
			exit 1
		;;
    esac
done

foo()
{
    foo_usage() { echo "foo: [-a <arg>]" 1>&2; exit; }

    local OPTIND o a
    while getopts ":a:" o; do
        case "${o}" in
            a)
                a="${OPTARG}"
                ;;
            *)
                foo_usage
                ;;
        esac
    done
    # shift $((OPTIND-1))

    # echo "a: [${a}], non-option arguments: $*"
}

killAll(){
    
# while getopts "s:"  arg #选项后面的冒号表示该选项需要参数
# do
#     case $arg in
#     s)
#         echo "s..."
#         echo "s:$OPTARG"
#         SERVERS = $OPTARG
#         ;;
#     ?)  #当有不认识的选项的时候arg为?
#         echo "unknow argument"
#         exit 1
#         ;;
#     esac
# done

while getopts "a:b:c" arg #选项后面的冒号表示该选项需要参数
do
    case $arg in
        a)
			echo "a's arg:$OPTARG" #参数存在$OPTARG中
			;;
        b)
			echo "b's arg:$OPTARG"
			;;
        c)
			echo "c's arg:$OPTARG"
			;;
        ?)  #当有不认识的选项的时候arg为?
			echo "unkonw argument"
			exit 1
		;;
    esac
done

    for host in $SERVERS
    do
        # cmd=$(printf "ssh root@%s  \"source /etc/profile;jps | grep %s \"" $host $1)
        # result=$(eval $cmd)
        # if [ "x$result" != "x" ] 
        # then
        #     pid=$(echo $result | awk '{print $1}')
        #     echo "root@$host kill $pid"
        #     ssh root@"$host" "kill -9 $pid"
        # fi
        echo "..."
        echo $host
    done
}
