import gzip
import json
import lzma
import os
import re
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer

FEED_DIR = os.path.abspath(sys.argv[1])
PORT = int(sys.argv[2])
FEED_RE = re.compile(r"^/nvdcve-2\.0-(\d{4}|modified)\.json\.gz$")
EMPTY_FEED = gzip.compress(
    json.dumps(
        {
            "resultsPerPage": 0,
            "startIndex": 0,
            "totalResults": 0,
            "format": "NVD_CVE",
            "version": "2.0",
            "vulnerabilities": [],
        }
    ).encode(),
    mtime=0,
)
EMPTY_LEGACY_FEED = lzma.compress(json.dumps({"cve_items": []}).encode())


class Handler(BaseHTTPRequestHandler):
    def send_feed(self, code, body):
        self.send_response(code)
        self.send_header("Content-Type", "application/gzip")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        legacy = re.match(r"^/CVE-(\d{4}|modified)\.json\.xz$", self.path)
        modern = FEED_RE.match(self.path)
        if not legacy and not modern:
            self.send_feed(404, b"")
            return
        if legacy:
            name = legacy.group(1)
            path = os.path.join(FEED_DIR, f"nvdcve-2.0-{name}.json.gz")
            if not os.path.exists(path):
                self.send_feed(200, EMPTY_LEGACY_FEED)
                return
            with gzip.open(path, "rt", encoding="utf-8") as feed:
                data = json.load(feed)
            self.send_feed(
                200,
                lzma.compress(json.dumps({"cve_items": data["vulnerabilities"]}).encode()),
            )
            return
        path = os.path.join(FEED_DIR, os.path.basename(self.path))
        if os.path.exists(path):
            with open(path, "rb") as feed:
                self.send_feed(200, feed.read())
        else:
            self.send_feed(200, EMPTY_FEED)

    def log_message(self, *_):
        pass


HTTPServer(("127.0.0.1", PORT), Handler).serve_forever()
