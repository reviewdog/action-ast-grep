#!/bin/bash
set -e

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

mkdir -p "${INPUT_OUTPUT_DIR}"
OUTPUT_FILE_NAME="reviewdog-${INPUT_TOOL_NAME}"
if [[ "${INPUT_REPORTER}" == "sarif" ]]; then
  OUTPUT_FILE_NAME="${OUTPUT_FILE_NAME}.sarif"
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo '::group::🐶 Installing misspell ... https://github.com/client9/misspell'
TEMP_PATH="$(mktemp -d)"
PATH="${TEMP_PATH}:$PATH"
wget -O - -q https://git.io/misspell | sh -s -- -b "${TEMP_PATH}"
echo '::endgroup::'

echo '::group:: Running misspell with reviewdog 🐶 ...'
# shellcheck disable=SC2086
misspell -locale="${INPUT_LOCALE}" . |
  reviewdog -efm="%f:%l:%c: %m" \
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
