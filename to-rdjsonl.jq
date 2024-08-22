.[] |
. as $item |
{
    "message": (if .note then (.message + " (Note: " + .note + ")") else .message end),
    "severity": .severity | ascii_upcase,
    "location": {
        "path": .file,
        "range": {
            "start": {
                "line": (.range.start.line + 1),
                "column": (.range.start.column + 1)
            },
            "end": {
                "line": (.range.end.line + 1),
                "column": (.range.end.column + 1)
            }
        }
    },
    "code": {
        "value": .ruleId,
        "url": "https://github.com/ast-grep/ast-grep"
    },
    "source": {
        "name": "ast-grep",
        "url": "https://github.com/ast-grep/ast-grep"
    },
    "original_output": . | tostring
} + if .replacement then
{
    "suggestions": [
    {
        "range": {
            "start": {
                "line": (.range.start.line + 1),
                    "column": (.range.start.column + 1)
            },
                "end": {
                    "line": (.range.end.line + 1),
                    "column": (.range.end.column + 1)
                }
        },
            "text": .replacement
    }
    ]
}
else {} end
