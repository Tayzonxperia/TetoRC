#### Imports
import osproc, strutils
#### Project imports

## tetshell

proc tetshell*() =
    when defined(build_extra):
        while true:
            stdout.write("TetoRC Shell>>> ")
            let line = stdin.readline().strip()
            if line == "exit":
                break
            if line.len == 0:
                continue
            let parts = line.split(" ")
            let command = parts[0]
            let args = if parts.len > 1: parts[1..^1] else: @[]

            try: 
                let result = execprocess(command, "", args)
                stdout.write(result)
                stdout.write("\n")
            except OSError:
                break
            
            