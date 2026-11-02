"""Read-only status and installation guidance for a global billion-context install."""
import json
import os
import urllib.request

from umeko_plugin_sdk import Plugin, PluginError


DASHBOARD = 'http://127.0.0.1:8787'


class BillionContext(Plugin):
    def status(self):
        installed, version, detail = False, '', ''
        try:
            previous = self.context.request_session
            # A global check must not depend on the chat workspace.
            self.context.request_session = {}
            try:
                command = '[Console]::OutputEncoding=[Text.UTF8Encoding]::new($false);$OutputEncoding=[Console]::OutputEncoding;bili --version'
                arguments = ['-NoLogo', '-NoProfile', '-Command', command] if os.name == 'nt' else ['--version']
                result = self.context.run_executable('bili-cmd' if os.name == 'nt' else 'bili', arguments, timeout=5, limit=16384)
            finally:
                self.context.request_session = previous
            installed = result['code'] == 0
            text = result['text'].strip()
            if installed:
                version = (text.splitlines()[0] if text else '未知版本')[:200]
            else:
                detail = text[:500]
        except PluginError as error:
            detail = str(error)
        running, upstream = False, ''
        if installed:
            try:
                with urllib.request.urlopen(DASHBOARD + '/__bili/health', timeout=1) as response:
                    health = json.loads(response.read(16384))
                running = bool(health.get('ok'))
                upstream = str(health.get('upstream') or '')[:300]
            except (OSError, ValueError):
                pass
        return {'installed': installed, 'version': version, 'running': running,
                'upstream': upstream, 'detail': detail, 'dashboardUrl': DASHBOARD}

    def handle(self, method, arguments):
        if method == 'status':
            return self.status()
        raise PluginError('未知 Billion Context 操作')


def create_plugin(context):
    return BillionContext(context)
