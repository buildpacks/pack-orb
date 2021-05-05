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

testTagFlagsWithNoValues() {
  local values=""
  local results=$(create_tag_flags "${values}") code="$?"
  assertEquals 0 "$code"
  assertEquals "$results" ""
}

testTagFlagsWithValues() {
  local values="my-image;docker.io/org/image:2"
  local results=$(create_tag_flags "${values}") code="$?"
  assertEquals 0 "$code"
  assertContains "$results" "--tag \"my-image\""
  assertContains "$results" "--tag \"docker.io/org/image:2\""
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
  local results=$(PARAM_BUILDER=some-builder PARAM_IMAGE_NAME=some/image:latest PARAM_PATH=some/dir PARAM_BUILDPACKS=my-buildpack@1.2.3 PARAM_ENV_VARS="ENV_1=VAL_1" PARAM_TAGS="another/tag:2" create_command) code="$?"
  assertEquals 0 "$code"
  assertEquals 'pack build --no-color --builder "some-builder" --path "some/dir" --buildpack "my-buildpack@1.2.3" --env ENV_1="VAL_1" --tag "another/tag:2" "some/image:latest"' "$results"
}

oneTimeSetUp() {
  echo "> Loading script under test..."
  source './../scripts/pack-build.sh'
}

# Load shUnit2
. ./shunit2
