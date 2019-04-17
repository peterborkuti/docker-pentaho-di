#!/usr/bin/env bash

# input parameter $1 should be the image name:tag

IMAGE=$1
CONTAINER_NAME=pentahounittest


# docker run --rm must delete the container after running, however, sometimes it does not do it.
# In this case, you have to delete the container manually which is named pentahounittest


# quoting "$(...)" preserves multi lines output

docker run --rm --name=$CONTAINER_NAME $IMAGE maitre.sh -f /pentaho-di/run-ut.ktr > log.txt 2> err.txt

TEST_LINES="$( grep -n 'Unit test.*\(passed\|failed\)' log.txt )"
TESTNAMES="$( echo $TESTNAME_LINES|sed -e 's/^.*Unit test //;s/ \(passed\|failed\).*//' )"
NUM_OF_TESTS=$( echo "$TEST_LINES"| wc -l )


echo "1..$NUM_OF_TESTS"

OIFS=$IFS
IFS=$'\n'
test_idx=1
for test in $TEST_LINES; do
    name=$( echo $test|sed -e 's/^.*Unit test //;s/ \(passed\|failed\).*//')
    passed=$( echo $test|grep -q 'passed'; echo $? ) # 0 - passed , 1 - failed
    lineno=$( echo $test|awk -F: '{print $1}' )
    reason=$( sed -ne "$lineno,/Transformation duration/p" log.txt )

    if [ $passed == "0" ]; then
	echo -n "ok "
    else
	echo -n "not ok "
    fi;

    echo "$test_idx $name"

    if [ $passed == "1" ]; then
	echo "$reason"| awk '{print "#", $0}'
    fi;

    let "test_idx++"
done

IFS=$OIFS
