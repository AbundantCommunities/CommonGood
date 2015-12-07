// Fix a downloaded CSV from Google Sheets
// The problem: newlines embedded in a cell's contents must be converted to commas
// While we're at it, convert existing commas (that separate cells) into tabs

FileReader inputStream = null
FileWriter outputStream = null

try {
    inputStream = new FileReader("./noQuoteQuotes.txt")
    outputStream = new FileWriter("./pureNewlines.txt")

    int thisChar
    int OUTSIDE_QUOTE = 0
    int INSIDE_QUOTE = 1
    int state = OUTSIDE_QUOTE

    while ((thisChar = inputStream.read()) != -1) {
        if (thisChar == '\n') {
            if (state == INSIDE_QUOTE) {
                // Convert newline inside quote to comma
                outputStream.write(',')
            } else {
                // This is simply the usual end-of-line signifier
                outputStream.write('\n')
            }
        } else if( thisChar == ',' ) {
            // Some of our commas are inside quoted cells
            // Other commas separate cells
            if( state == INSIDE_QUOTE ) {
                // Preserve commas inside a quote
                outputStream.write(',')
            } else {
                // We prefer tab characters between fields
                // (We'd use Google Sheets TSV files but they discard our embedded newlines)
                outputStream.write('\t')
            }
        } else if (thisChar == '"') {
            // Double quotation mark charaters used only to delimit begin+end of a cell
            // Note we do not output anything from this state
            if (state == INSIDE_QUOTE) {
                state = OUTSIDE_QUOTE
            } else {
                state = INSIDE_QUOTE
            }
        } else {
            outputStream.write( thisChar )
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
