#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent), ui(new Ui::MainWindowClass)
{
    ui->setupUi(this);
    QFile file("../../output/pinnacle.xml");
    file.open(QFile::ReadOnly);
    xmlfile.setContent(&file);

    ui->anbieterliste->setRowCount(1);
    ui->anbieterliste->setItem(0, 0, new QTableWidgetItem(xmlfile.documentElement().attribute("name")));

    QDomElement s = xmlfile.documentElement().firstChildElement("sport");
    QTreeWidgetItem *sports = new QTreeWidgetItem(ui->sportartenliste);
    sports->setText(0, "Sportarten/Ligen");
    sports->setText(1, "id");
    QTreeWidgetItem *newitem;
    while(s.attribute("name") != "") {
        newitem = new QTreeWidgetItem(sports);
        newitem->setText(0, s.attribute("name"));
        newitem->setText(1, s.attribute("id"));
        s = xmlfile.documentElement().nextSiblingElement("sport");
    }
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_actionBeenden_triggered()
{
    close();
}
