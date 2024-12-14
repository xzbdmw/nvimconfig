fd --type f -0 | xargs -0 -n1 -P8 sh -c '
    file="$1"
    abs_path=$(realpath "$file")
    lines=$(wc -l < "$file" 2>/dev/null || echo 0)
    echo "$lines $abs_path"
	' sh
