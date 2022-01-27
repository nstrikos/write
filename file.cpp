#include "file.h"

#include <QFile>
#include <QTextStream>

File::File()
{

}

void File::write(QString text)
{
    QFile file("/media/data/nick/Desktop/notes.txt");
    if(file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        QTextStream stream(&file);
        stream << text;
        file.close();
    }
}

QString File::read()
{
    QFile file("/media/data/nick/Desktop/notes.txt");

    QString text;

    if (file.open(QIODevice::ReadOnly | QIODevice::Text)){
         QTextStream stream(&file);
         while (!stream.atEnd()){
             text = stream.readAll();
         }
     }
     file.close();

     return text;
}
