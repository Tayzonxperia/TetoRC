#### Code styling

- Nim style indentation required, even when coding in a different language

- Braces (Not used in Nim, but when used elsewhere) follow style:

"function()  
{
    code
    code
}
"

- Code must only be seperated when needed or it differs enough, example:

" function() xyz
    code code
    code code
    code code
    code code
    code code
    code code
    code code
    code code
    code code
    return 0

    new code 
    new code
    new code
    new code
    new code
    new code
    return 1
"


- Functions follow style "thisfunction"

- Variables follow style "THISVAR" for constants, "thisvar" for vars and "THISVAR" for lets 
or equivelents

- Enums follow style "ThisEnum", same for Objects/Structs

- Imports follow style "Import stdlibray \n Import somelocalfile", \n is a actual newline
Imports must always be at top of file, local importing must be "../folder/file" if its in 
another dir, it must be quoted, stdlib imports or same-dir imports must not be quoted

= Comment rules:

- Comments can be in your own style, but it has to convey meaning, no
jargon unless you explain it, but it cannot be plain simple or basic
in which it cannot explain thoughroly

"# Xyz" for simple inlines
- Inline comments follow style "while this.code # This does this and that"

"## Xyz 
 ######" for headers

 - Where the bottom row of comment hashes must be as long as header text


" ## Xyz ... " for longer inlines

- Follows same rule as single hash inlines


" #### Xyz ... ... " for large inlines or explainations

- Can be above/below code, spanning multiple lines, if it spans 8+ lines it should
- be in its own .txt, .doc or .info file, place the specifed docs in ~/Projectroot/
Documentation/thefileofcode/whatthisthingdoes.{txt,doc,info}
- If it spans multiple lines, each line it spans needs a seperate "####"

## Sample pesuado code

import posix # Imports
import "../include/dposix" # Project imports

myfunc(): cint {.inline.} =
    var x = 2
    const Y = 6
    let z = 914
    while x != z:
        x + 1
        stdout.write "This is ", x ## We keep adding 1 to x while its not equal to z
        #### Blah blah blah blah blah blah code linux blah
        #### Blah blah blah i love coding blah blahhhh 
        more code more code more code and return 0

        new code more code more code more code more code else
        return 1 # Return 1 to signal failure
