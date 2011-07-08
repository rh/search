import System.Console
import System.IO

def Search(directory as DirectoryInfo, options as Options):
    return if directory.Name in options.IgnoredDirectories

    for file in directory.GetFiles(options.File):
        continue if file.Extension in options.IgnoredExtensions
        options.FileCount += 1
        line_number = 0
        filename_shown = false
        try:
            for line in File.ReadAllLines(file.FullName):
                line_number = line_number + 1
                characters = {}
                for i in range(0, line.Length):
                    characters[i] = false
                matches = options.Regex.Matches(line)
                if matches.Count > 0:
                    if options.FileOnly:
                        PrintFile file
                        break
                    if not filename_shown:
                        PrintFile file
                    if options.MatchOnly:
                        PrintLineNumber line_number
                        for match as Match in matches:
                            value = match.Value.Replace(Convert.ToString(0x7), "")
                            Write value
                        print
                    else:
                        PrintLineNumber line_number
                        for match as Match in matches:
                            for i in range(match.Index, match.Index + match.Length):
                                characters[i] = true
                        fg = ForegroundColor
                        bg = BackgroundColor
                        for i in range(0, line.Length):
                            if characters[i] == true:
                                ForegroundColor = ConsoleColor.White
                                BackgroundColor = ConsoleColor.DarkGray
                            else:
                                ForegroundColor = ConsoleColor.DarkGray
                                BackgroundColor = bg
                            Write line[i]
                        ForegroundColor = fg
                        BackgroundColor = bg
                        print
                    filename_shown = true
        except e as IOException:
            pass # Ignore 'The process cannot access the file '...' because it is being used by another process.'
    if options.Recursive:
        for subdirectory in directory.GetDirectories():
            Search subdirectory, options
