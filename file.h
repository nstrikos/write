#ifndef FILE_H
#define FILE_H

#include <QObject>

class File : public QObject
{
    Q_OBJECT
public:
    File();

    Q_INVOKABLE void write(QString text);
    Q_INVOKABLE QString read();
};

#endif // FILE_H
