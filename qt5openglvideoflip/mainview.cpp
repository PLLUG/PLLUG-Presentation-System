#include "mainview.h"
#include <QQuickView>
#include <QtWidgets/QApplication>
#include <QtWidgets/QDesktopWidget>
#include <QQmlContext>
#include <QQmlEngine>
#include <QUrl>
#include <QFile>
#include <QDir>
#include <QDebug>



#include "megaparse.h"
#include "blocksview.h"
#include "page.h"
#include "helper.h"

#if defined(Q_OS_WIN)
    #include "qt_windows.h"
#endif

MainView::MainView(const QString &pContentDir, QWindow *parent) :
    QQuickView(parent)
{
//    mParser = new MegaParse(this);
//    mParser->setContentDir(pContentDir);
//    qDebug() << "content dir = " << pContentDir;
//    mParser->parsePagesData();
//    mParser->parseTemplatesData();

    this->setSurfaceType(QQuickView::OpenGLSurface);

//    QString fshader;
//    QFile file1(":/shaders/flipPage.fsh"/*pContentDir+"/../resources/shaders/flipPage.fsh"*/);
//    if (file1.open(QIODevice::ReadOnly | QIODevice::Text))
//    {
//        fshader = file1.readAll();
//    }
//    QString vshader;
//    QFile file2(":/shaders/flipPage.vsh");
//    if (file2.open(QIODevice::ReadOnly | QIODevice::Text))
//    {
//        vshader = file2.readAll();
//    }
//    this->rootContext()->setContextProperty("vshader", vshader);
//    this->rootContext()->setContextProperty("fshader",fshader);
    mHelper = new Helper();
    this->rootContext()->setContextProperty("helper",mHelper);
    this->rootContext()->setContextProperty("screenPixelWidth", qApp->desktop()->screenGeometry().width());
    this->rootContext()->setContextProperty("screenPixelHeight",qApp->desktop()->screenGeometry().height());

    //    QDir dir( pContentDir+"/image/");
    //    QStringList list;
    //    foreach (QFileInfo file, dir.entryInfoList(QDir::AllEntries | QDir::NoDotAndDotDot))
    //    {
    //        list.append("file:///" + file.absoluteFilePath());
    //    }
    //    this->rootContext()->setContextProperty("filesModel", list);


    QString lSourceFile = QString::fromLatin1("%1/../qml/DemoView/TestPresentation.qml").arg(pContentDir);
    this->setSource(QUrl::fromLocalFile(lSourceFile));

//    QQuickItem *rootItem = this->rootObject();

//    for (int i=0; i < mParser->pagesList().count(); i++)
//    {
//        Page* item = mParser->pagesList().at(i);
//        item->setVisible(false);
//        item->setVisible((i == 0));
//        item->setParentItem(rootItem);
//        // connect(item, SIGNAL(fullBrowser(QQuickItem*)), this, SLOT(test(QQuickItem*)));
//        mPagesList.append(item);
//    }
    this->setResizeMode(QQuickView::SizeRootObjectToView);


    mActualSize = QSize(qApp->desktop()->screenGeometry().width()/1.5, qApp->desktop()->screenGeometry().height()/1.5);
    mOldSize = mActualSize;
    mAspectRatio = (qreal)mActualSize.width() / mActualSize.height();
    resize(mActualSize);

//    connect(this, SIGNAL(heightChanged(int)), this, SLOT(test1(int)));
}



bool MainView::nativeEvent(const QByteArray& eventType, void* pMessage, long* result)
{
#if defined(Q_OS_WIN)
    MSG* message = (MSG*)pMessage;
    switch(message->message)
    {
    case (WM_SIZING):
    {
        RECT* rect = (RECT*) message->lParam;
        int fWidth = frameGeometry().width() - width();
        int fHeight = frameGeometry().height() - height();
        int nWidth = rect->right-rect->left - fWidth;
        int nHeight = rect->bottom-rect->top - fHeight;

        switch(message->wParam) {
        case WMSZ_BOTTOM:
        case WMSZ_TOP:
            rect->right = rect->left+(qreal)nHeight*mAspectRatio + fWidth;
            break;

        case WMSZ_BOTTOMLEFT:
        case WMSZ_BOTTOMRIGHT:
            if( (qreal)nWidth / nHeight > mAspectRatio )
                rect->bottom = rect->top+(qreal)nWidth/mAspectRatio +fHeight;
            else
                rect->right = rect->left+(qreal)nHeight*mAspectRatio + fWidth;
            break;

        case WMSZ_LEFT:
        case WMSZ_RIGHT:
            rect->bottom = rect->top+(qreal)nWidth/mAspectRatio +fHeight;
            break;

        case WMSZ_TOPLEFT:
        case WMSZ_TOPRIGHT:
            if( (qreal)nWidth / nHeight > mAspectRatio )
                rect->bottom = rect->top+(qreal)nWidth/mAspectRatio +fHeight;
            else
                rect->right = rect->left+(qreal)nHeight*mAspectRatio + fWidth;
            break;
        }
    }
        return true;
    default:
        return false;
    };
    return true;
#endif
}


//void MainView::resizeEvent(QResizeEvent *event)
//{
//    qDebug() << "event size" << event->size() << event->oldSize() << mOldSize;
//    qDebug() <<"+++++"<< frameGeometry();
//    QSize lNewSize = event->size();

//    if (lNewSize != event->oldSize())
//    {
//        if (event->size().width() != event->oldSize().width())
//        {
//            lNewSize = QSize(event->size().width(), event->size().width()/mAspectRatio);
//        }
//        else if (event->size().height() != event->oldSize().height())
//        {
//            lNewSize = QSize(event->size().height()*mAspectRatio, event->size().height());
//        }
//        foreach (Page *page, mPagesList)
//        {
//            page->setProperty("height", this->height());
//            page->setProperty("width", this->width());
//        }

//        mOldSize = lNewSize;
//        resize(lNewSize);
//        qDebug() <<"after"<< width();
//        qDebug() << height();
//    }
//    else
//    {
//        mOldSize = lNewSize;
//    }

//    QQuickView::resizeEvent(event);
//}


void MainView::test(QQuickItem* item)
{
    qDebug() << "full browser";
    Page *page = new Page(item);
    if (!page)
    {
        qDebug() << "ZZZZZZZZZZz";
    }
    page->setParentItem(this->rootObject());
    mPagesList.append(page);

}

void MainView::test1(int w)
{
}
