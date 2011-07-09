import System
import System.Console
import System.IO
import System.Text.RegularExpressions

class Search:
    public IgnoredDirectories = [".git", ".svn", "bin", "obj"]
    public IgnoredExtensions = [".dll", ".exe", ".pdb", ".mdb", ".zip"]
    private Regex = Regex(".")
    public FilePattern = ""
    public FileCount = 0
    public Recursive = false
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
                    characters = {}
                    for i in range(0, line.Length):
                        characters[i] = false
                    matches = Regex.Matches(line)
                    if matches.Count > 0:
                        if FileOnly:
                            PrintFile file
                            break
                        if not filename_shown:
                            PrintFile file
                        if MatchOnly:
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
                                if line[i] == char('\t'):
                                    Write "    "
                                else:
                                    Write line[i]
                            ForegroundColor = fg
                            BackgroundColor = bg
                            print
                        filename_shown = true
            except e as IOException:
                pass # Ignore 'The process cannot access the file '...' because it is being used by another process.'
        if Recursive:
            for subdirectory in directory.GetDirectories():
                Search(subdirectory)
