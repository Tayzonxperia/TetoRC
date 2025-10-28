######## TetoRC FIFO intergration file
import posix, os, json, strutils

## Include imports 
import "../../include/universal", "../../include/dposix"

## Project importd
import "../core/msg"



#### FIFO init ####
###################

proc initfifo*(fifoInPath, fifoOutPath: string) =
  # Check if the FIFOs exist first
    if not fileExists(fifoInPath) or not fileExists(fifoOutPath):
        discard mkfifo(fifoInPath, 0o755)
        discard mkfifo(fifoOutPath, 0o755)
        tmesg(0, "FIFOs created")
        return

  # Open FIFOs
    let fifo_in = open(fifoInPath, fmRead)
    let fifo_out = open(fifoOutPath, fmWrite)

    tmesg(0, "FIFO IPC online")

    while true:
        let line = fifo_in.readLine()
        if line.len > 0:
            try:
                let msg = parseJson(line)
                stdout.write("[JSON] CMD: " & msg["cmd"].getStr & "\n")
                stdout.write("[JSON] Val: " & msg["value"].getStr & "\n")
            except Exception as e:
                let respond = %*{"status":"jsonerr","msg":"invalid json"}
                fifo_out.writeLine(respond.repr)
                stderr.write("[JSON] Invalid JSON: " & e.msg & "\n")

