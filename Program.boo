VERSION = "0.1"

HELP = """Usage: search [options] <pattern> [file]
Search for <pattern> in [file]

Example: search \t{2} *.cs

Options:
  -n, --non-recursive        Do not search subdirectories
  -m, --match-only           Only show the match, not the entire line
  -l, --files-with-matches   Only print file names containing matches

  -h, --help                 Show this message
  -v, --version              Show version"""

if "-h" in argv or "--help" in argv or argv.Length == 0:
    print HELP
    return

if "-v" in argv or "--version" in argv:
    print VERSION
    return

search = Search()

for arg in argv:
    if arg == "-n" or arg == "--non-recursive":
        search.Recursive = false
    elif arg == "-m" or arg == "--match-only":
        search.MatchOnly = true
    elif arg == "-l" or arg == "--files-with-matches":
        search.FileOnly = true
    else:
        search.FilePattern = arg if search.Pattern != ""
        search.Pattern     = arg if search.Pattern == ""

search.Search(".")

print
print "Searched ${search.FileCount} files"
