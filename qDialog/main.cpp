#include <QtGui/QApplication>
//#include <QtGui/QGraphicsObject>
#include <QDeclarativeContext>
#include <QDebug>
#include "qmlapplicationviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QString msg = app->arguments().at(1);
    //QScopedPointer<QmlApplicationViewer> viewer(QmlApplicationViewer::create());
    QmlApplicationViewer viewer;

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.rootContext()->setContextProperty("alert_message",msg);
    viewer.setMainQmlFile(QLatin1String("qrc:/qml/dialog.qml"));
    //viewer->setSource(QUrl("qrc:/qml/dialog.qml"));
    viewer.showExpanded();
    //QObject *object = viewer.rootObject();
    //object->setProperty("alert_message", app->arguments().at(1));
    return app->exec();
}
