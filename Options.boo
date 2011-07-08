import System
import System.Text.RegularExpressions

class Options:
    public IgnoredDirectories = [".git", ".svn", "bin", "obj"]
    public IgnoredExtensions = [".dll", ".exe", ".pdb", ".mdb", ".zip"]
    public Pattern = ""
    public Regex as Regex = null
    public File = ""
    public FileCount = 0
    public Recursive = false
    public MatchOnly = false
    public FileOnly = false
