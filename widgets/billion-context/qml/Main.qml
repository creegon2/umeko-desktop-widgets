import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    objectName: "billionContextWidget"
    required property var sdk
    readonly property var c: sdk.colors
    readonly property real s: sdk.scale
    property var report: ({})
    property string request: ""
    property string error: ""
    color: c.surface

    function t(zh, en) { return sdk.language.indexOf("zh") === 0 ? zh : en }
    function refresh() {
        if (!sdk.active || request) return
        error = ""
        request = sdk.call("status", {})
        if (!request) error = t("插件暂时繁忙，请稍后重试", "The Widget is busy. Please retry.")
    }
    function statusText() {
        if (report.installed === undefined) return t("正在检查…", "Checking…")
        if (!report.installed) return t("未检测到全局 billion-context", "No global billion-context installation found")
        return t("已安装", "Installed") + " · " + report.version
    }

    Component.onCompleted: refresh()
    Connections {
        target: root.sdk
        function onActiveChanged() { if (root.sdk.active) root.refresh() }
        function onResponse(token, value) {
            if (token !== root.request) return
            root.request = ""
            if (!value.ok) {
                root.error = value.error || root.t("检查失败，请重试", "Status check failed. Please retry.")
                return
            }
            root.report = value.result
        }
    }

    Flickable {
        anchors.fill: parent
        clip: true
        contentWidth: width
        contentHeight: content.implicitHeight + 32 * root.s
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
        ColumnLayout {
            id: content
            x: 16 * root.s
            y: 16 * root.s
            width: parent.width - 32 * root.s
            spacing: 14 * root.s

            Text {
                text: "Billion Context"
                color: root.c.ink
                font.pixelSize: 20 * root.s
                font.weight: Font.DemiBold
                Layout.fillWidth: true
            }
            Text {
                text: root.t("全局安装检查与轻量状态面板；不自动安装、启动代理或修改 Pi 配置。", "Global installation and status only. It does not install packages, start the proxy or change Pi settings.")
                color: root.c.muted
                font.pixelSize: 12 * root.s
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: statusColumn.implicitHeight + 20 * root.s
                color: root.c.hover
                border.color: root.c.line
                radius: 8
                ColumnLayout {
                    id: statusColumn
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 10 * root.s
                    spacing: 5 * root.s
                    Text {
                        objectName: "billionContextStatus"
                        text: root.statusText()
                        color: root.report.installed === false ? root.c.danger : root.c.ink
                        font.pixelSize: 14 * root.s
                        font.weight: Font.DemiBold
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                    Text {
                        visible: root.report.installed === true
                        text: root.report.running ? root.t("本地代理运行中", "Local proxy is running") : root.t("已安装，但本地代理未运行", "Installed, but the local proxy is not running")
                        color: root.report.running ? root.c.accent : root.c.muted
                        font.pixelSize: 12 * root.s
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                    Text {
                        visible: root.report.installed === true && !!root.report.upstream
                        text: root.report.upstream || ""
                        color: root.c.muted
                        font.pixelSize: 11 * root.s
                        elide: Text.ElideMiddle
                        Layout.fillWidth: true
                    }
                    Text {
                        objectName: "billionContextDetail"
                        visible: !!root.report.detail
                        text: root.report.detail || ""
                        color: root.c.muted
                        font.pixelSize: 11 * root.s
                        wrapMode: Text.WrapAnywhere
                        Layout.fillWidth: true
                    }
                }
            }
            ColumnLayout {
                visible: root.report.installed === false
                Layout.fillWidth: true
                spacing: 8 * root.s
                Text {
                    objectName: "billionContextInstallGuide"
                    text: root.t("此 Widget 需要先安装全局 billion-context。请阅读项目说明后自行安装，然后点击“重新检查”。", "This Widget requires a global billion-context installation. Review the project and install it yourself, then choose Check again.")
                    color: root.c.ink
                    font.pixelSize: 12 * root.s
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 38 * root.s
                    color: root.c.bg
                    border.color: root.c.line
                    radius: 6
                    TextEdit {
                        objectName: "billionContextInstallCommand"
                        anchors.fill: parent
                        anchors.margins: 8 * root.s
                        readOnly: true
                        text: "npm install -g billion-context"
                        color: root.c.ink
                        font.family: "Consolas"
                        font.pixelSize: 12 * root.s
                        selectByMouse: true
                        persistentSelection: true
                        verticalAlignment: TextEdit.AlignVCenter
                    }
                }
            }
            ColumnLayout {
                visible: root.report.installed === true && !root.report.running
                Layout.fillWidth: true
                spacing: 8 * root.s
                Text {
                    text: root.t("安装不等于压缩已生效。需要时可自行启动代理，再重新检查。", "Installation alone does not enable compression. Start the proxy yourself when needed, then check again.")
                    color: root.c.muted
                    font.pixelSize: 12 * root.s
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }
                TextEdit {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 28 * root.s
                    readOnly: true
                    text: "bili pi"
                    color: root.c.ink
                    font.family: "Consolas"
                    font.pixelSize: 12 * root.s
                    selectByMouse: true
                    persistentSelection: true
                }
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: 8 * root.s
                Button {
                    objectName: "billionContextRefresh"
                    text: root.request ? root.t("正在检查…", "Checking…") : root.t("重新检查", "Check again")
                    enabled: !root.request && root.sdk.active
                    onClicked: root.refresh()
                }
                Button {
                    objectName: "billionContextDashboard"
                    visible: root.report.installed === true
                    text: root.t("打开管理页", "Open dashboard")
                    enabled: root.report.running === true
                    onClicked: Qt.openUrlExternally(root.report.dashboardUrl)
                }
                Button {
                    objectName: "billionContextDocs"
                    text: root.t("项目与安装说明", "Project and installation")
                    onClicked: Qt.openUrlExternally("https://github.com/ranxianglei/billion-context")
                }
            }
            Text {
                visible: !!root.error
                text: root.error
                color: root.c.danger
                font.pixelSize: 12 * root.s
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
            Item { Layout.fillHeight: true }
        }
    }
}
