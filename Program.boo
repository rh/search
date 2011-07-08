VERSION = "0.1"

HELP = """Usage: search [options] <pattern> [file]
Search for <pattern> in [file]

Example: search -r \\t{2} *.cs

Options:
  -r, --recursive            Recurse into subdirectories
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

options = Options()

for arg in argv:
    if arg == "-r" or arg == "--recursive":
        options.Recursive = true
    elif arg == "-m" or arg == "--match-only":
        options.MatchOnly = true
    elif arg == "-l" or arg == "--files-with-matches":
        options.FileOnly = true
    else:
        options.File    = arg if options.Pattern != ""
        options.Pattern = arg if options.Pattern == ""

options.Regex = Regex(options.Pattern)

Search DirectoryInfo("."), options

print
print "Searched ${options.FileCount} files"
