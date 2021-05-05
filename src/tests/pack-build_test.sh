#!/usr/bin/env bash

testBuildpackFlagsWithNoValues() {
  local values=""
  local results=$(create_buildpack_flags "${values}") code="$?"
  assertEquals 0 "$code"
  assertEquals "$results" ""
}

testBuildpackFlagsWithValues() {
  local values="my-buildpack@1.2.3;docker.io/org/other-buildpack:latest"
  local results=$(create_buildpack_flags "${values}") code="$?"
  assertEquals 0 "$code"
  assertContains "$results" "--buildpack \"my-buildpack@1.2.3\""
  assertContains "$results" "--buildpack \"docker.io/org/other-buildpack:latest\""
}

testEnvVarsFlagsWithNoValues() {
  local values=""
  local results=$(create_env_var_flags "${values}") code="$?"
  assertEquals 0 "$code"
  assertEquals "$results" ""
}

testEnvVarsFlagsWithValues() {
  local values="ENV_1=VAL_1;ENV_2=VAL 2;"
  local results=$(create_env_var_flags "${values}") code="$?"
  assertEquals 0 "$code"
  assertContains "$results" "--env ENV_1=\"VAL_1\""
  assertContains "$results" "--env ENV_2=\"VAL 2\""
}

testPathFlagWithNoValue() {
  local value=""
  local results=$(create_path_flag "${value}") code="$?"
  assertEquals 0 "$code"
  assertEquals "$results" ""
}

testPathFlagWithValue() {
  local value="some/nested/dir"
  local results=$(create_path_flag "${value}") code="$?"
  assertEquals 0 "$code"
  assertContains "$results" "--path \"some/nested/dir\""
}

testCreateCommandMissingBuilder() {
  local results=$(create_command) code="$?"
  assertEquals 1 "$code"
  assertContains "$results" "param 'builder' is required!"
}

testCreateCommandMissingImageName() {
  local results=$(PARAM_BUILDER=some-builder create_command) code="$?"
  assertEquals 1 "$code"
  assertContains "$results" "param 'image-name' is required!"
}

testCreateCommandFull() {
  local results=$(PARAM_BUILDER=some-builder PARAM_IMAGE_NAME=some/image:latest PARAM_PATH=some/dir PARAM_ENV_VARS="ENV_1=VAL_1" PARAM_BUILDPACKS=my-buildpack@1.2.3 create_command) code="$?"
  assertEquals 0 "$code"
  assertEquals 'pack build --no-color --builder "some-builder" --path "some/dir" --env ENV_1="VAL_1" --buildpack "my-buildpack@1.2.3" "some/image:latest"' "$results"
}

oneTimeSetUp() {
  echo "> Loading script under test..."
  source './../scripts/pack-build.sh'
}

# Load shUnit2
. ./shunit2
