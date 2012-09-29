#ifndef TIMEDSCRIPT_H
#define TIMEDSCRIPT_H

#include <QObject>
#include <QProcess>
#include <QString>
//#include <QDebug>
#include <QtSystemInfo/qsystemalignedtimer.h>

QTM_USE_NAMESPACE

class timedScript : public QObject
{
    Q_OBJECT
public:
    explicit timedScript(QObject *parent = 0);
    void start(int);

signals:
    void startTimer(int minTime, int maxTime);

public slots:

private slots:
    void runScript();
    //void scriptErr(QProcess::ProcessError);

private:
    QSystemAlignedTimer *timer;
    QProcess *myProcess;
    QString script;
};

#endif // TIMEDSCRIPT_H
