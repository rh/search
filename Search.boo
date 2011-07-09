import System
import System.Console
import System.IO
import System.Text.RegularExpressions

class Search:
    public IgnoredDirectories = [".git", ".svn", "bin", "obj"]
    public IgnoredExtensions = [".dll", ".exe", ".pdb", ".mdb", ".zip"]
    private Regex = Regex(".")
    public FilePattern = "*"
    public FileCount = 0
    public FileMatchCount = 0
    public MatchCount = 0
    public Recursive = true
    public MatchOnly = false
    public FileOnly = false

    Pattern:
        set: pattern = value; Regex = Regex(value)
        get: return pattern
    pattern as string = ""

    def Search(directory as string):
        Search(DirectoryInfo(directory))

    def Search(directory as DirectoryInfo):
        return if directory.Name in IgnoredDirectories

        for file in directory.GetFiles(FilePattern):
            continue if file.Extension in IgnoredExtensions
            FileCount += 1
            line_number = 0
            filename_shown = false
            try:
                for line in File.ReadAllLines(file.FullName):
                    line_number = line_number + 1
                    matches = Regex.Matches(line)
                    if matches.Count > 0:
                        MatchCount += matches.Count
                        if FileOnly:
                            FileMatchCount += 1
                            PrintFile file, false
                            break
                        if not filename_shown:
                            FileMatchCount += 1
                            PrintFile file, true
                        if MatchOnly:
                            PrintLineNumber line_number
                            for match as Match in matches:
                                value = match.Value.Replace(Convert.ToString(0x7), "")
                                Write value
                            print
                        else:
                            PrintLineNumber line_number
                            PrintMatches line, matches
                        filename_shown = true
            except e as IOException:
                pass # Ignore 'The process cannot access the file '...' because it is being used by another process.'
        if Recursive:
            for subdirectory in directory.GetDirectories():
                Search(subdirectory)

    def PrintMatches(line as string, matches as MatchCollection):
        characters = []

        for match as Match in matches:
            for i in range(match.Index, match.Index + match.Length):
                characters.Add(i)

        fg = ForegroundColor
        bg = BackgroundColor

        for i in range(0, line.Length):
            if i in characters:
                ForegroundColor = ConsoleColor.White
                BackgroundColor = ConsoleColor.DarkGray
            else:
                ForegroundColor = ConsoleColor.Gray
                BackgroundColor = bg
            if line[i] == char('\t'):
                Write "    "
            else:
                Write line[i]

        ForegroundColor = fg
        BackgroundColor = bg
        print
