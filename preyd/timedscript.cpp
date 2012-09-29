#include "timedscript.h"

timedScript::timedScript(QObject *parent) :
    QObject(parent)
{
    timer = new QSystemAlignedTimer();
    myProcess = new QProcess();
    script = "bash /opt/prey/run";
    connect(timer,SIGNAL(timeout()),this, SLOT(runScript()));
    connect(this,SIGNAL(startTimer(int,int)),timer, SLOT(start(int,int)));

    //error log
    //connect(myProcess,SIGNAL(error(QProcess::ProcessError)),this, SLOT(scriptErr(QProcess::ProcessError)));
}


void timedScript::runScript()
{
    //qDebug() << "Starting Script";
    myProcess->start(script);
    //qDebug() << "Script Finished";
}

/*void timedScript::scriptErr(QProcess::ProcessError ErrNo)
{
    //qDebug() << "Script failed due to Error:" << ErrNo;
}*/

void timedScript::start(int delay)
{
    int minTime = delay*60-1;
    int maxTime = delay*60+1;
    emit startTimer(minTime,maxTime);
}
