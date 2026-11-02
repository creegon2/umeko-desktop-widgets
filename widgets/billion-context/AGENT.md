# Billion Context Widget

This Widget is disabled by default and requires explicit user activation. It checks the global `billion-context` installation and local proxy status only. It does not bundle the package, install software, start a proxy, or change Pi configuration.

`status({})` returns:

- `installed`: whether the global `bili --version` command succeeded.
- `version`: the first line of the version output.
- `running`: whether `http://127.0.0.1:8787/__bili/health` is healthy.
- `upstream`: the upstream reported by the health endpoint, when available.
- `dashboardUrl`: the local dashboard address.
- `detail`: a short detection error, when present.

Do not claim that compression is active when the package is missing or the proxy is not running. Direct the user to https://github.com/ranxianglei/billion-context for installation and configuration instead of performing a global installation or using another Pi instance without permission.
