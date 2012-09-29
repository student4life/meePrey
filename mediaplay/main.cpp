#include <QtCore/QCoreApplication>
#include <QtCore/QObject>
#include <QtMultimediaKit/QMediaPlayer>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    QMediaPlayer *player = new QMediaPlayer();
    player->setMedia(QUrl::fromLocalFile(a.arguments().at(1)));
    player->setVolume(100);
    player->play();
    QObject::connect(player,SIGNAL(stateChanged(QMediaPlayer::State)),&a,SLOT(quit()),Qt::QueuedConnection);

    return a.exec();
}
