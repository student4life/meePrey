#include <QtCore/QCoreApplication>
#include "timedscript.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    timedScript *timer =  new timedScript();
    //int delay = a.arguments().at(1).toInt();
    timer->start(a.arguments().at(1).toInt());

    return a.exec();
}
