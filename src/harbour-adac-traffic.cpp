#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>

#include "trafficmanager.h"

int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/harbour-adac-traffic.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //   - SailfishApp::pathToMainQml() to get a QUrl to the main QML file
    //
    // To display the view, call "show()" (will show fullscreen on device).

    // return SailfishApp::main(argc, argv);
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    QQmlContext *context = view.data()->rootContext();
// TODO
//     context->setContextProperty("applicationVersion", QString(VERSION_NUMBER));

    TrafficManager trafficManager;
    context->setContextProperty("trafficManager", &trafficManager);

    ADACBackend *adacBackend = trafficManager.getAdacBackend();
    context->setContextProperty("adacBackend", adacBackend);

    view->setSource(SailfishApp::pathTo("qml/harbour-adac-traffic.qml"));
    view->show();
    return app->exec();

}
