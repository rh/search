import System.Console
import System.IO

def PrintFile(file as FileInfo):
    color = ForegroundColor
    ForegroundColor = ConsoleColor.DarkYellow

    cwd = DirectoryInfo(".").FullName
    if file.FullName.StartsWith(cwd):
        Write file.FullName.Substring(cwd.Length + 1)
    else:
        Write file.FullName

    ForegroundColor = ConsoleColor.DarkGray
    WriteLine ":"
    ForegroundColor = color

def PrintLineNumber(line_number):
    color = ForegroundColor
    ForegroundColor = ConsoleColor.DarkGray
    Write "{0,6}: ", line_number
    ForegroundColor = color
