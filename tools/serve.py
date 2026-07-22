import http.server, socketserver, os

os.chdir(os.path.dirname(os.path.abspath(__file__)))

class H(http.server.SimpleHTTPRequestHandler):
    extensions_map = {
        **http.server.SimpleHTTPRequestHandler.extensions_map,
        '.mjs': 'text/javascript',
        '.js': 'text/javascript',
        '.wasm': 'application/wasm',
        '.onnx': 'application/octet-stream',
        '.html': 'text/html',
    }
    def do_GET(self):
        if self.path == '/' or self.path.startswith('/?'):
            self.send_response(302)
            self.send_header('Location', '/LayerLab_v2.html')
            self.end_headers()
            return
        return super().do_GET()

class ThreadingServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    daemon_threads = True
    allow_reuse_address = True

PORT = 8899
with ThreadingServer(('', PORT), H) as httpd:
    print(f'serving LayerLab (threaded) on {PORT}')
    httpd.serve_forever()
