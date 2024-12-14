# Ensure the output directory exists
mkdir -p /Users/xzb/.config/nvim/.count

# Capture the current directory name to use in the filename
# Convert the absolute path in $PWD into a single string safe for filenames
cwd="${PWD//\//_}" # This replaces all '/' with '_'

# Run the parallel command and redirect output to the file
fd --type f -0 | xargs -0 -n1 -P8 sh -c '
    file="$1"
    abs_path=$(realpath "$file")
    lines=$(wc -l < "$file" 2>/dev/null || echo 0)
    echo "$lines $abs_path"
    ' sh >"/Users/xzb/.config/nvim/.count/${cwd}.txt"
