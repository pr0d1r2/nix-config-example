runHook preBuild
export HOME="$TMPDIR"
export PYTHONPATH="$VULNIX_PYTHONPATH"
mkdir -p "$TMPDIR/cache"
port=$((20000 + $(echo "$NIX_BUILD_TOP" | cksum | cut -d' ' -f1) % 20000))
python3 "$SERVE_FEEDS" "$FEED_FARM" "$port" &
server=$!
trap 'kill "$server"' EXIT
until curl -sf "http://127.0.0.1:$port/nvdcve-2.0-modified.json.gz" -o /dev/null; do
  sleep 0.2
done
python3 "$POPULATE" "http://127.0.0.1:$port/" "$TMPDIR/cache"
test -s "$TMPDIR/cache/Data.fs"
runHook postBuild
