import strutils



const 
    WHITESPACE*          = " \t\n\r"
    NEWLINE*             = "\n\r"
    QUOTES*              = "\"'"
    COMMENTS*            = "#;"
    DIGITS*              = "0123456789"
    LOWERCASE_LETTERS*   = "abcdefghijklmnopqrstuvwxyz"
    UPPERCASE_LETTERS*   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    LETTERS*             = LOWERCASE_LETTERS & UPPERCASE_LETTERS
    ALPHANUMERICAL*      = LETTERS & DIGITS
    HEXDIGITS*           = DIGITS & "abcdefABCDEF"
    LOWERCASE_HEXDIGITS* = DIGITS & "abcdef"


func asciiIsDigit*(ascii: char): bool {.inline.} =
    return ascii >= '0' and ascii <= '9'

func extractFirstWord*(str: string): string {.inline.} =
    let parts = str.splitWhitespace(maxsplit = 1)
    if parts.len > 0: parts[0] else: ""

func stripPrefix*(str, pre: string): string {.inline.} =
    if str.startsWith(pre):
        str[pre.len .. ^1]
    else:
        ""

func deleteChars*(str: string, bad: string = WHITESPACE): string {.inline.} =
    result = newStringOfCap(str.len)
    for c in str:
        if c notin bad:
            result.add c
  