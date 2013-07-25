#include <QtGui/QGuiApplication>
#include <QtWidgets/QApplication>
#include <QDir>
#include <QDebug>
#include <QQmlContext>
#include <QDesktopWidget>
#include <QQuickView>
#include "mainview.h"
#include "page.h"
#include "megaparse.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QString contentDir;
    foreach (QString arg, QCoreApplication::arguments())
    {
        if ( arg.contains("-contentdir="))
        {
            contentDir = arg.remove("-contentdir=");
        }
        else
        {
            QDir appDir = QCoreApplication::applicationDirPath();
            appDir.cdUp();
            #ifdef Q_OS_WIN
            appDir.cdUp();
            contentDir = appDir.absolutePath() + "/data";
            #endif
            #ifdef Q_OS_MAC
            contentDir = appDir.absolutePath() + "/Resources/data";
            qDebug() << contentDir;
            #endif
        }
    }
    MainView *view = new MainView(contentDir);
    view->show();

    return app.exec();
}
