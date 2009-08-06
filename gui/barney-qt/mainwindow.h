#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QtGui>
#include <QtXml>
#include <QDomDocument>

namespace Ui
{
    class MainWindowClass;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = 0);
    ~MainWindow();

private:
    Ui::MainWindowClass *ui;

private slots:
    void on_actionBeenden_triggered();
};

#endif // MAINWINDOW_H
