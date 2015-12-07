// Replace a text file's adjacent double quotation mark characters with a single pipe character
// That is: "" becomes |
// Why? Because Google Sheets CSV download translates a cell's single double quotation mark into
// two adjacent double quotation mark characters (the ol' double-double). That sucks.

FileReader inputStream = null
FileWriter outputStream = null

try {
    inputStream = new FileReader("/Users/theguy/Downloads/aciData.csv")
    outputStream = new FileWriter("./noQuoteQuotes.txt")

    int DOUBLE_QUOTE = '"'
    int NO_SUCH = -2 // no character has code -2

    int current = NO_SUCH

    int TRIGGERED = 1
    int IDLE = 2
    int state = IDLE

    while( (current = inputStream.read()) != -1 ) {
        if( current == DOUBLE_QUOTE ) {
            if( state == TRIGGERED ) {
                // Previous char was also a double quote.
                // Those two double quotes become one pipe character:
                outputStream.write('|')
                state = IDLE
            } else {
                // The character after the current double quote determines what we will do
                state = TRIGGERED
            }
        } else {
            if( state == TRIGGERED ) {
                // The previous char (a double quote) was not followed by a second DQ
                outputStream.write( DOUBLE_QUOTE )
                state = IDLE
            }
            outputStream.write( current )
        }
    }
} finally {
    if (inputStream != null) {
        inputStream.close()
    }
    if (outputStream != null) {
        outputStream.close()
    }
}
