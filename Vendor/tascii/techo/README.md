# techo - TETO's echo

![demo gif](https://github.com/nwp8861/techo/blob/main/techo-demo.gif)

## Sublime Overview

This Python script is simply print text message to stdout like echo or cat command on Linux, but it can decorate your terminal with dotted [Teto](https://kasaneteto.jp/)'s face at that time. 

The appearance of 8 color dotted Teto offers not only relaxation and happiness to extremely hard and severe system administration tasks, but also useful to prevent missing important notices. 

## Yet Another Overview

kawaii 

## Requirement

- Python3
- CLI terminal supporting ANSI escape sequence. 

## Install

As simply, save techo.py in your computer and execute it on terminal. 

If you save techo.py in a directory included in the PATH, it is recommended to change the filename into techo. Or, it may be useful to save the file in anywhere you want and alias it with the alias command, such as “alias techo=/_ _FILE_PATH_ _/techo.py”.

## Usage
```
techo [-0~5|-q|-b|-d|-l|-r|-f text-file] [--] [message ... ]

  -0 ~ -5      ... change face (default: -0)
  -q           ... output no message (show face only)
  -b           ... color brightness change
  -d           ... reduce Teto's vertical width
  -l           ... position face to the left
  -r           ... position face to the right (default)
  -f text-file ... read message from text-file
  --           ... end of command line options
```

(simple example)
```
$ techo hello world
```

(reading message from pipeline)
```
$ date | techo
```

(just print Teto's face)
```
$ techo -q
```

(change face depending on command execution result)
```
$ gcc sample.c && techo -1 -q -d || techo -5 -q -d
```

(instant ramen timer)
```
$ sleep 180; techo -1 'READY!'
```

## License

- source code:
  - 2024, nwp8861, released under the MIT No Attribution license (MIT-0)
  - MIT-0: https://opensource.org/license/MIT-0

- Teto:
  - PCL (applied mutatis mutandis)
  - [https://kasaneteto.jp/guideline/ctu.html](https://kasaneteto.jp/guideline/ctu.html)

## Author

- [blog](http://nwp8861.blog92.fc2.com/)
- [X](https://x.com/nwp8861)
- [nicovideo](https://www.nicovideo.jp/user/5717366/video)
- [YouTube](http://www.youtube.com/user/nwp8861)
