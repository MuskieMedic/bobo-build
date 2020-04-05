curl "https://api.github.com/users/PeterDauwe/repos?per_page=500&page=1" | jq -r '.[] | .name'

