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

    licenseKey: "846E5EAD14C35A0911AE1604CE242C5054B5305C05793D88D65F6F18D430FD29439EC7EC46B4CB2F09DE2DC7094CE3AD4D8A56BEF5F6DAAC384FAAD4A276E601B5ACCAA7032286332D49C2BB1DDA4681C1F65584A9052BC4275C47FBFBF29CA98238FEFF6AC0E2030C1F6600134B3A0FB4AB1326AB630885A23D296EC098C752B6620B2511635FAB29B64B9D4E7CC5F4C032EB1B219218DFF8B99FEC17183BC32844014575DE0B9EC66132D8B840F82BF184A0F82D776B65C2D2FF8A7CDD914B8860184919E8DFE6C5F07DB89122DDD67E843E465E0F30CD6EE48B3AAE5EA9943583A5C196B08BC410361705AEEC512D181111557182EC4DEA9A0D2CABFAF223671ECC45A715D195B10449B51F4740CDA4CCFC0C6101E004B0B7A8A1B1ADAAB22F4F3C08F05EE6E18633B6F20DC748A5"

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
            id: page1
            title: "AL AIRE"
            navigationBarHidden: true
            backgroundColor: "#314d6d"
            rightBarItem: ActivityIndicatorBarItem {
                id: loading
                enabled: false
                visible: enabled
            }
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
                    page1.navigationBarHidden = false
                    page1.backgroundColor = "#ffffff"
                    page.visible = true
                }
            }

            AppListView {
                id: page
                visible: false
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
                            anchors.leftMargin: dp(100)
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
                            if (pdfResource.available) {
                                openPdf()
                                deleteFile(modelData.edicion)
                            } else {
                                page.visible = false
                                mensaje.visible = true
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
        nativeUtils.openUrl(pdfResource.storagePath)
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
