#include "mainwindow.h"
#include "ui_mainwindow.h"

class Sportanbieter {
    private:
        QFile file;
        QDomDocument xmlfile;
    public:
        Sportanbieter(QString dateiname);
        ~Sportanbieter();
        QStringList get_sports();
        QString get_name();
};

Sportanbieter::Sportanbieter(QString dateiname) : file(dateiname) {
    file.open(QFile::ReadOnly);
    xmlfile.setContent(&file);
}

Sportanbieter::~Sportanbieter() {
    file.close();
}

QStringList Sportanbieter::get_sports() {
    QStringList ret;
    QDomElement s = xmlfile.documentElement().firstChildElement("sport");
    while(s.attribute("name") != "") {
        ret << s.attribute("name");
        s = xmlfile.documentElement().nextSiblingElement("sport");
    }

    return ret;
}

QString Sportanbieter::get_name() {
    return xmlfile.documentElement().attribute("name");
}

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent), ui(new Ui::MainWindowClass)
{
    ui->setupUi(this);

    QStringList anbieter;
    xmlfiles << "../../output/pinnacle.xml" << "../../output/expekt.xml";

    QVector<Sportanbieter> anbieter;

    for (int i = 0; i < xmlfiles.size(); ++i)
          anbieter.push_back(Sportanbieter(xmlfiles.at(i)));

    ui->anbieterliste->setRowCount(anbieter.size());

    QStringList sportarten;

    for (int i = 0; i < anbieter.size(); i++) {
        ui->anbieterliste->setItem(0, i, new QTableWidgetItem(anbieter.at(i).get_name()));
        sportarten << anbieter.at(i).get_sports();
    }

    sportarten.sort();

    for(int i = 0; i < sportarten.size(); i++)
        ui->sportartenliste->add_item(sportarten.at(i));
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_actionBeenden_triggered()
{
    close();
}
