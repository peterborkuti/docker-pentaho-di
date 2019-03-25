#!/usr/bin/env bats

setup() {
  load test_env
  : ${IMAGE:=$IMG_NAME:$TEST_TAG}
  : ${NAME:=pdi_test_$BATS_TEST_NUMBER}

  remove_container_by_name $NAME
}

@test "pan.sh exists in the path" {
  run docker run --rm --name=$NAME $IMAGE which pan.sh
  [ "$output" = '/opt/pentaho-di/data-integration/pan.sh' ]
}


@test "pan.sh runs test transformation to print message to log" {
  run docker run --rm --name=$NAME $IMAGE pan.sh -rep=docker-pentaho-di -dir=/ -trans=test-trans
  [ "$status" -eq 0 ]
  echo "$output" | grep 'MY_MESSAGE = Hello World!'
}
