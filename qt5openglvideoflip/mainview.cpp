#include "mainview.h"
#include <QQuickWindow>
#include <QtWidgets/QApplication>
#include <QtWidgets/QDesktopWidget>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QUrl>
#include <QFile>
#include <QDir>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonArray>
#include <QMessageBox>
#include <QTimer>
#include <QFileDialog>

#include "presentationmanager.h"
#include "megaparse.h"
#include "blocksview.h"
#include "slide.h"
#include "helper.h"

#if defined(Q_OS_WIN)
#include "qt_windows.h"
#endif

MainView::MainView(const QString &pContentDir, QObject *parent)
    : QObject(parent)
{
    mContentDir = pContentDir;
#if defined(Q_OS_MAC)
    //DON"T FORGET TO CHANGE PATH BEFORE DEPLOY!!!!
    mContentDir = "/Users/Admin/Projects/qt5openglvideoflip_1/qt5openglvideoflip/data";
#endif
    mHelper = new Helper();
    mHelper->setScreenPixelSize(qApp->desktop()->screenGeometry().size());

    mQmlEngine = new QQmlApplicationEngine();
    mQmlEngine->rootContext()->setContextProperty("helper",mHelper);
    mQmlEngine->rootContext()->setContextProperty("screenPixelWidth", mHelper->screenSize().width());
    mQmlEngine->rootContext()->setContextProperty("screenPixelHeight", mHelper->screenSize().height());

    QUrl qmlFilePath = QUrl(QStringLiteral("qrc:/main.qml"));
    QQmlComponent component(mQmlEngine, qmlFilePath);
    if (!component.isReady())
    {
        qDebug() << "Error while creating New Project window :" << component.errorString();
    }
    mMainWindow = qobject_cast<QQuickWindow*>(component.create(mQmlEngine->rootContext()));
    mManager = new PresentationManager(mContentDir, mMainWindow, mHelper);
    connect(mHelper, SIGNAL(createPresentationMode()), mManager, SLOT(setCreateEditPresentationMode()));
    connect(mHelper, SIGNAL(open(QString)), mManager, SLOT(openPresentation(QString)));

    mActualSize = QSize(qApp->desktop()->screenGeometry().width()/1.5, qApp->desktop()->screenGeometry().height()/1.5);
    mHelper->setMainViewSize(mActualSize);
    mAspectRatio = (qreal)mActualSize.width() / mActualSize.height();
    mMainWindow->resize(mActualSize);
    mMainWindow->installEventFilter(this);
}

void MainView::showWindow()
{
    mMainWindow->show();
}

#if defined(Q_OS_WIN)
bool MainView::nativeEvent(const QByteArray& eventType, void* pMessage, long* result)
{
//    Q_UNUSED(eventType);
//    Q_UNUSED(result);

////#if defined(Q_OS_WIN)
//    MSG* message = (MSG*)pMessage;
//    switch(message->message)
//    {
//    case (WM_SIZING):
//    {
//        RECT* rect = (RECT*) message->lParam;
//        int fWidth = frameGeometry().width() - width();
//        int fHeight = frameGeometry().height() - height();
//        int nWidth = rect->right-rect->left - fWidth;
//        int nHeight = rect->bottom-rect->top - fHeight;

//        switch(message->wParam) {
//        case WMSZ_BOTTOM:
//        case WMSZ_TOP:
//            rect->right = rect->left+(qreal)nHeight*mAspectRatio + fWidth;
//            break;

//        case WMSZ_BOTTOMLEFT:
//        case WMSZ_BOTTOMRIGHT:
//            if( (qreal)nWidth / nHeight > mAspectRatio )
//                rect->bottom = rect->top+(qreal)nWidth/mAspectRatio +fHeight;
//            else
//                rect->right = rect->left+(qreal)nHeight*mAspectRatio + fWidth;
//            break;

//        case WMSZ_LEFT:
//        case WMSZ_RIGHT:
//            rect->bottom = rect->top+(qreal)nWidth/mAspectRatio +fHeight;
//            break;

//        case WMSZ_TOPLEFT:
//        case WMSZ_TOPRIGHT:
//            if( (qreal)nWidth / nHeight > mAspectRatio )
//                rect->bottom = rect->top+(qreal)nWidth/mAspectRatio +fHeight;
//            else
//                rect->right = rect->left+(qreal)nHeight*mAspectRatio + fWidth;
//            break;
//        }
//    }
//        return true;
//    default:
//        return false;
//    };
//    return true;
//#endif
    return false;

}
#endif

//bool MainView::event(QEvent *event)
//{
////    if (event->type() == QEvent::Close)
////    {
////        if (mManager->mode() == PresentationManager::Create || mManager->mode() == PresentationManager::Edit )
////        {
////            QString lFilePath = QFileDialog::getSaveFileName(0, tr("Save Presentation"), QDir::currentPath(), tr("Presentation (*.json)"));
////            mManager->savePresentation(lFilePath);
////        }
////    }
//    return QQuickView::event(event);
//}



