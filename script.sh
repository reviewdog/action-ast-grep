#!/bin/bash
set -e

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

if [ -z "${INPUT_SG_VERSION}" ]; then
  INPUT_SG_VERSION="${DEFAULT_SG_VERSION}"
fi

mkdir -p "${INPUT_OUTPUT_DIR}"
OUTPUT_FILE_NAME="reviewdog-${INPUT_TOOL_NAME}"
if [[ "${INPUT_REPORTER}" == "sarif" ]]; then
  OUTPUT_FILE_NAME="${OUTPUT_FILE_NAME}.sarif"
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo '::group::🐶 Installing ast-grep ... https://github.com/ast-grep/ast-grep'
TEMP_PATH="$(mktemp -d)"
PATH="${TEMP_PATH}:$PATH"

curl --silent --show-error --fail \
  --location "https://github.com/ast-grep/ast-grep/releases/download/${INPUT_SG_VERSION}/app-x86_64-unknown-linux-gnu.zip" \
  --output "${TEMP_PATH}/sg.zip"

unzip -u "${TEMP_PATH}/sg.zip" -d "${TEMP_PATH}/temp-sg"
install "${TEMP_PATH}/temp-sg/ast-grep" "${TEMP_PATH}"
rm -rf "${TEMP_PATH}/sg.zip" "${TEMP_PATH}/temp-sg"

echo '::endgroup::'

echo '::group:: Running ast-grep with reviewdog 🐶 ...'

# shellcheck disable=SC2086
ast-grep scan --config="${INPUT_SG_CONFIG}" --json=compact |
  jq -f "${GITHUB_ACTION_PATH}/to-rdjsonl.jq" -c |
  reviewdog \
    -f=rdjsonl \
    -name="${INPUT_TOOL_NAME}" \
    -reporter="${INPUT_REPORTER}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
    -level="${INPUT_LEVEL}" \
    ${INPUT_REVIEWDOG_FLAGS} |
  tee "${INPUT_OUTPUT_DIR}/${OUTPUT_FILE_NAME}"

exit_code=${PIPESTATUS[1]}
echo '::endgroup::'
exit "$exit_code"
