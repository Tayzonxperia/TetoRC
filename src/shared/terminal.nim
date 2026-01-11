import posix



const 
    ANSI_ERASE_TO_END_OF_LINE*      = "\x1B[K"
    ANSI_ERASE_TO_END_OF_SCREEN*    = "\x1B[J"
    ANSI_REVERSE_LINEFEED*          = "\x1BM"
    ANSI_HOME_CLEAR*                = "\x1B[H\x1B[2J"
    ANSI_DCS*                       = "\eP"
    ANSI_OSC*                       = "\e]"
    ANSI_ST*                       = "\e\\"



