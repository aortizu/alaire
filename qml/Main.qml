import Felgo 3.0
import QtQuick 2.0
import QtGraphicalEffects 1.0

App {
    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://felgo.com/licenseKey>"
    id: app

    onInitTheme: {
        Theme.colors.tintColor = "#314D6D"
    }

    Storage {
        id: storage
    }

    property var jsonData: null

    Component.onCompleted: {
        loadJsonData()
    }

    NavigationStack {
        id: navigationStack
        Page {
            id: inicio
            navigationBarHidden: true
            backgroundColor: "#314d6d"
            AppImage {
                id: alaire
                width: dp(200)
                height: dp(200)
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                opacity: 0
                source: "https://raw.githubusercontent.com/aortizu/AlAireJson/master/alaire.png"
            }

            SequentialAnimation {
                running: true
                loops: 1
                // logo fade in
                PauseAnimation {
                    duration: 1500
                }
                ParallelAnimation {
                    id: logoFadeIn
                    readonly property int duration: 1500
                    NumberAnimation {
                        target: alaire
                        property: "opacity"
                        to: 1
                        duration: logoFadeIn.duration * 0.75
                    }
                    NumberAnimation {
                        target: alaire
                        property: "scale"
                        from: 1.5
                        to: 1
                        duration: logoFadeIn.duration
                        easing.type: Easing.OutBounce
                    }
                }

                PauseAnimation {
                    duration: 1000
                }
                // all fade out
                ParallelAnimation {
                    id: allFadeOut
                    readonly property int duration: 500
                    NumberAnimation {
                        target: alaire
                        property: "opacity"
                        to: 0
                        duration: allFadeOut.duration
                    }
                    NumberAnimation {
                        target: alaire
                        property: "scale"
                        to: 1.5
                        easing.type: Easing.InExpo
                        duration: allFadeOut.duration
                    }
                }
                PauseAnimation {
                    duration: 1000
                }
            }

            AppImage {
                id: colaeros
                width: dp(250)
                height: dp(150)
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                opacity: 0
                source: "https://raw.githubusercontent.com/aortizu/AlAireJson/master/colaerospotters.png"
            }

            SequentialAnimation {
                running: true
                loops: 1
                // logo fade in
                PauseAnimation {
                    duration: 4500
                }
                ParallelAnimation {
                    id: logoFadeIn1
                    readonly property int duration: 1500
                    NumberAnimation {
                        target: colaeros
                        property: "opacity"
                        to: 1
                        duration: logoFadeIn.duration * 0.75
                    }
                    NumberAnimation {
                        target: colaeros
                        property: "scale"
                        from: 1.5
                        to: 1
                        duration: logoFadeIn.duration
                        easing.type: Easing.OutBounce
                    }
                }

                PauseAnimation {
                    duration: 1000
                }
                // all fade out
                ParallelAnimation {
                    id: allFadeOut1
                    readonly property int duration: 500
                    NumberAnimation {
                        target: colaeros
                        property: "opacity"
                        to: 0
                        duration: allFadeOut.duration
                    }
                    NumberAnimation {
                        target: colaeros
                        property: "scale"
                        to: 1.5
                        easing.type: Easing.InExpo
                        duration: allFadeOut.duration
                    }
                }
                PauseAnimation {
                    duration: 1000
                }
                onStopped: {
                    inicio.navigationStack.push(page1)
                }
            }
        }
    }

    Component {
        id: page1
        Page {
            id: lista
            title: "AL AIRE"
            backNavigationEnabled: false
            rightBarItem: ActivityIndicatorBarItem {
                id: loading
                enabled: false
                visible: enabled
            }

            AppListView {
                id: page
                spacing: 2
                backgroundColor: "#efeff4"
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                model: app.jsonData

                delegate: SwipeOptionsContainer {
                    id: container
                    SimpleRow {
                        height: dp(100)

                        AppImage {
                            id: img
                            width: dp(100)
                            height: dp(100)
                            fillMode: "Stretch"
                            source: "https://raw.githubusercontent.com/aortizu/AlAireJson/master/"
                                    + modelData.edicion + ".png"
                        }

                        AppText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: dp(105)
                            wrapMode: Text.WordWrap
                            text: "Edición: " + modelData.edicion + " " + modelData.fecha
                        }

                        Icon {
                            id: icono
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: dp(10)
                            icon: IconType.download
                        }

                        onSelected: {
                            pdfResource.source = modelData.url
                            pdfResource.storageName = modelData.edicion + modelData.fecha + ".pdf"
                            page.visible = false
                            mensaje.visible = true
                            if (pdfResource.available) {
                                openPdf()
                            } else {
                                loading.enabled = true
                                pdfResource.download()
                            }
                            actualizar(modelData.edicion, true)
                        }
                    }

                    rightOption: SwipeButton {
                        icon: {
                            if (storage.getValue(modelData.edicion)) {
                                icono.icon = IconType.check
                                IconType.trash
                            } else {
                                icono.icon = null
                                IconType.download
                            }
                        }
                        height: parent.height
                        onClicked: {
                            pdfResource.source = modelData.url
                            pdfResource.storageName = modelData.edicion + modelData.fecha + ".pdf"
                            page.visible = false
                            mensaje.visible = true
                            if (pdfResource.available) {
                                openPdf()
                                deleteFile(modelData.edicion)
                            } else {
                                loading.enabled = true
                                pdfResource.download()
                                actualizar(modelData.edicion, true)
                            }
                            container.hideOptions()
                        }
                    }
                }
            }

            AppText {
                id: mensaje
                visible: false
                text: qsTr("Descargando archivo esto puede tomar un tiempo...")
                anchors.bottomMargin: 0
                anchors.fill: parent
                wrapMode: Text.WordWrap
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    DownloadableResource {
        id: pdfResource
        storageLocation: FileUtils.DocumentsLocation
        extractAsPackage: false
        onAvailableChanged: if (available) {
                                openPdf()
                            }
    }

    function actualizar(id, value) {
        storage.setValue(id, value)
        app.jsonData[app.jsonData.length - 1].guardado
                = !app.jsonData[app.jsonData.length - 1].guardado
        app.jsonDataChanged()
        page.forceLayout()
    }

    function openPdf() {
        loading.enabled = false
        console.log(pdfResource.storagePath)
        fileUtils.openFile(pdfResource.storagePath)
        page.visible = true
        mensaje.visible = false
        page.forceLayout()
    }
    function deleteFile(id) {
        pdfResource.remove()
        if (!pdfResource.available) {
            nativeUtils.displayAlertDialog("", "Archivo eliminado!", "ok")
            actualizar(id, false)
        } else {
            nativeUtils.displayAlertDialog("", "Archivo NO eliminado!", "ok")
        }
    }
    function loadJsonData() {
        var xhr = new XMLHttpRequest
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var dataString = xhr.responseText
                app.jsonData = JSON.parse(dataString)
                for (var i = 0; i < app.jsonData.length; i++) {
                    if (storage.getValue(
                                app.jsonData[i].edicion) === undefined) {
                        storage.setValue(app.jsonData[i].edicion, false)
                    }
                }
            }
        }
        xhr.open("GET", Qt.resolvedUrl(
                     "https://raw.githubusercontent.com/aortizu/AlAireJson/master/alaire.json"))
        xhr.send()
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:6;invisible:true}D{i:13;invisible:true}
D{i:3;invisible:true}D{i:14;anchors_width:126;anchors_x:0;invisible:true}
}
 ##^##*/
