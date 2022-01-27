#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QApplication>

#include <QQmlContext>

#include <QSharedMemory>

#include "file.h"

static QSharedMemory sharedMemory;


int main(int argc, char *argv[])
{

    sharedMemory.setKey("4c8ff818-1a54-4861-8ab5-1233e76735d2");

    if (!sharedMemory.create(1))
    {
        exit(0);
    }

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

#ifdef QT_WIDGETS_LIB
    QApplication app(argc, argv);
#else
    QGuiApplication app(argc, argv);
#endif

    app.setOrganizationName("Nick Strikos");
    app.setOrganizationDomain("nstrikos@yahoo.gr");
    app.setApplicationName("Write");

    File file;

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("file", &file);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
