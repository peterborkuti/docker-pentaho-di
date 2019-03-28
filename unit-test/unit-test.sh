#!/usr/bin/env bash

echo "I am running with $1"
exit


remove_container_by_name() {
    NAME=$1
    C_ID=$( docker ps -a --no-trunc --filter name=^/${NAME}$|grep -v "CONTAINER" |tail -1|awk '{print $1;}' )
    if [ ! -z "$C_ID" ]; then
        docker container stop $C_ID
	docker container rm $C_ID
    fi;
}

# quoting "$(...)" preserves multi lines output

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
