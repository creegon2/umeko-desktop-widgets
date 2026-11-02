# Umeko Desktop Widgets

A collection of interesting and practical Widgets for [Umeko Desktop](https://github.com/umeiko/umeko-desktop). This repository is intended to make small desktop extensions easy to discover, install, and understand.

## Available Widgets

| Widget | What it does |
| --- | --- |
| [Billion Context](widgets/billion-context) | Checks a global `billion-context` installation, shows its version and local proxy health, provides installation guidance, and opens the author's dashboard. |

## Install a Widget

1. Download the Widget ZIP from the GitHub Release for this repository.
2. In Umeko Desktop, open **Settings → Agent → Plugin Management** and import the ZIP.
3. Enable the Widget explicitly and open its page from the chat Widget menu.

The installable ZIP is attached to a GitHub Release and is not tracked as an artifact in this repository.

## Billion Context requirements

The Billion Context Widget requires a separate global installation of [`billion-context`](https://github.com/ranxianglei/billion-context):

```sh
npm install -g billion-context
```

The Widget is **disabled by default**. It does not install the package, start the proxy, change Pi settings, or implement context compression itself. It only reports installation and proxy status and provides links to the author's project and local dashboard.

See the [Widget README](widgets/billion-context/README.md) for behavior and status meanings, and the [billion-context license](https://github.com/ranxianglei/billion-context/blob/master/LICENSE) for the upstream attribution requirements.

## Repository layout

```text
widgets/
  <widget-id>/
    manifest.json
    config.json
    config.schema.json
    scripts/plugin.py
    qml/Main.qml
    README.md
    AGENT.md
```

Each Widget includes its own documentation and manifest. Installable packages are built with the Umeko Plugin SDK and published through GitHub Releases.
