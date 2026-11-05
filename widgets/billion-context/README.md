# Billion Context Widget

[`billion-context`](https://github.com/ranxianglei/billion-context) is a third-party context-compression plugin. It compresses the conversation history sent to the model, so a single session can run for weeks or a month within a small context window (the author reports that 100K is enough) while using about five times fewer tokens.

This is a lightweight, built-in-ready status Widget for Umeko Desktop. It checks a global [`billion-context`](https://github.com/ranxianglei/billion-context) installation and its local proxy, then presents installation guidance or opens the author's dashboard.

The Widget is **disabled by default** and must be enabled explicitly. It does not bundle `billion-context`, implement compression, install packages, start the proxy, or change Pi settings.

## Requirements

Install `billion-context` separately if you want to use the status and dashboard features:

```sh
npm install -g billion-context
```

Review the upstream project and its [license and attribution terms](https://github.com/ranxianglei/billion-context/blob/master/LICENSE) before enabling it.

## Status display

- **Not installed:** shows the detection result, `npm install -g billion-context`, and a link to the project documentation.
- **Installed but proxy is not running:** shows the installed version and explains that installation alone does not enable compression.
- **Installed and proxy is running:** shows the version and enables **Open dashboard** at `http://127.0.0.1:8787`.

Use **Check again** after installing the package or changing the proxy state. The dashboard is provided by the upstream `billion-context` package, not by this Widget.

## Scope and privacy

The Widget runs `bili --version` only for detection and queries the loopback health endpoint for proxy status. It does not start model traffic, install or upgrade software, or modify global Pi configuration. No project workspace is required for the global installation check.
