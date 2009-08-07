#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "einstellungendialog.h"

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
        s = s.nextSiblingElement("sport");
    }

    return ret;
}

QString Sportanbieter::get_name() {
    return xmlfile.documentElement().attribute("name");
}

QVector<Game> Sportanbieter::get_games(QString sport) {
    QVector<Game> gamelist;

    QDomElement s = xmlfile.documentElement().firstChildElement("sport");
    while(!s.isNull()) {
        if(s.attribute("name") == sport) {
            QDomElement s2 = s.firstChildElement("game");

            Game g;
            while(!s2.isNull()) {
                g.team1 = s2.firstChildElement("team1").text();
                g.team2 = s2.firstChildElement("team2").text();
                g.odd1 = s2.firstChildElement("odd1").text().toFloat();
                g.odd2 = s2.firstChildElement("odd2").text().toFloat();
                g.date = s2.firstChildElement("date").text();
                g.time = s2.firstChildElement("time").text();
                g.id = s2.attribute("id");
                g.anbieter1 = get_name();
                g.anbieter2 = get_name();
                g.sport = sport;

                if(g.team1 > g.team2) {
                    QString temp = g.team1;
                    g.team1 = g.team2;
                    g.team2 = temp;

                    float temp2 = g.odd1;
                    g.odd1 = g.odd2;
                    g.odd2 = temp2;
                }

                gamelist.push_back(g);

                s2 = s2.nextSiblingElement("game");
            }
        }
        s = s.nextSiblingElement("sport");
    }

    return gamelist;
}

void MainWindow::optimize_gamelist(QVector<Game>& gamelist) {
    QVector<Game> optgames;
    for(int i = 0; i < gamelist.size(); i++) {
        bool exists = false;
        for(int j = 0; j < optgames.size(); j++) {
            if(optgames.at(j).team1 == gamelist.at(i).team1 && optgames.at(j).team2 == gamelist.at(i).team2) {
                exists = true;
                if(gamelist.at(i).odd1 > optgames.at(j).odd1) {
                    optgames[j].odd1 = gamelist[i].odd1;
                    optgames[j].anbieter1 = gamelist[i].anbieter1;
                }
                if(gamelist.at(i).odd2 > optgames.at(j).odd2) {
                    optgames[j].odd2 = gamelist[i].odd2;
                    optgames[j].anbieter2 = gamelist[i].anbieter2;
                }
            }
        }

        if(!exists) {
            optgames.push_back(gamelist.at(i));
        }
    }
    gamelist = optgames;
}

void MainWindow::fill_grid(QVector<Game> gamelist) {
    ui->spielliste->setRowCount(gamelist.size());
    for(int i = 0; i < gamelist.size(); i++) {
        ui->spielliste->setItem(i, 0, new QTableWidgetItem(gamelist.at(i).id));
        ui->spielliste->setItem(i, 1, new QTableWidgetItem(gamelist.at(i).team1));
        ui->spielliste->setItem(i, 2, new QTableWidgetItem(QString("%1").arg(gamelist.at(i).odd1)));
        ui->spielliste->setItem(i, 3, new QTableWidgetItem(gamelist.at(i).anbieter1));
        ui->spielliste->setItem(i, 4, new QTableWidgetItem(gamelist.at(i).team2));
        ui->spielliste->setItem(i, 5, new QTableWidgetItem(QString("%1").arg(gamelist.at(i).odd2)));
        ui->spielliste->setItem(i, 6, new QTableWidgetItem(gamelist.at(i).anbieter2));
    }
}

void MainWindow::set_xml_path(QString path) {
    xml_path = path;

    for(int i = 0; i < anbieter.size(); i++) {
        delete anbieter.at(i);
    }
    anbieter.resize(0);

    QStringList xmlfiles, filters;
    QDir outputdir(path);
    filters << "*.xml";
    outputdir.setNameFilters(filters);

    xmlfiles = outputdir.entryList();

    for (int i = 0; i < xmlfiles.size(); ++i)
        anbieter.push_back(new Sportanbieter(outputdir.absolutePath()+QDir::separator()+xmlfiles.at(i)));
}

void MainWindow::updateAnbieterliste() {
    ui->anbieterliste->setRowCount(anbieter.size());

    QStringList sportarten;
    QCheckBox *box;

    for (int i = 0; i < anbieter.size(); i++) {
        box = new QCheckBox();
        ui->anbieterliste->setItem(i, 0, new QTableWidgetItem(anbieter.at(i)->get_name()));
        ui->anbieterliste->setCellWidget(i, 1, box);
        box->setCheckState(Qt::Checked);
        connect(box, SIGNAL(clicked()), this, SLOT(on_anbieterCheckBox_clicked()));

        sportarten << anbieter.at(i)->get_sports();
    }

    sportarten.removeDuplicates();

    ui->sportartenliste->clear();
    ui->sportartenliste->addItems(sportarten);
}

void MainWindow::set_refresh_command(QString command) {
    refresh_cmd = command;
}

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent), ui(new Ui::MainWindowClass)
{
    ui->setupUi(this);

    set_xml_path("../../output");
    set_refresh_command("cd ../..; ruby main.rb");
    updateAnbieterliste();

}

MainWindow::~MainWindow()
{
    delete ui;
    for(int i = 0; i < anbieter.size(); i++) {
        delete anbieter.at(i);
    }
}

void MainWindow::on_anbieterCheckBox_clicked() {
    ui->sportartenliste->clear();
    QStringList sportarten;
    QCheckBox *box;

    for (int i = 0; i < anbieter.size(); i++) {
        box = (QCheckBox*)ui->anbieterliste->cellWidget(i, 1);
        if(box->checkState() == Qt::Checked)
            sportarten << anbieter.at(i)->get_sports();
    }

    sportarten.removeDuplicates();
    ui->sportartenliste->addItems(sportarten);
}

void MainWindow::on_actionBeenden_triggered()
{
    close();
}


void MainWindow::on_sportartenliste_itemSelectionChanged()
{
    QList<QListWidgetItem*> auswahl = ui->sportartenliste->selectedItems();
    QVector<Game> gameslist;
    QCheckBox *box;

    for(int i = 0; i < auswahl.size(); i++) {
        QString sport = auswahl.at(i)->text();
        for(int j = 0; j < anbieter.size(); j++) {
            box = (QCheckBox*)ui->anbieterliste->cellWidget(j, 1);
            if(box->checkState() == Qt::Checked)
                gameslist << anbieter.at(j)->get_games(sport);
        }
    }
    optimize_gamelist(gameslist);
    fill_grid(gameslist);
}

void MainWindow::on_actionEinstellungen_triggered()
{
    EinstellungenDialog opt_dlg;
    opt_dlg.set_xml_path(xml_path);
    opt_dlg.set_refresh_command(refresh_cmd);

    if(opt_dlg.exec() == QDialog::Accepted) {
        set_xml_path(opt_dlg.get_xml_path());
        updateAnbieterliste();
        set_refresh_command(opt_dlg.get_refresh_command());
    }
}

void MainWindow::on_action_ber_Qt_triggered()
{
    QApplication::aboutQt();
}
