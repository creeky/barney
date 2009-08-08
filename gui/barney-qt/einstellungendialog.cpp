#include "einstellungendialog.h"
#include "ui_einstellungendialog.h"
#include "quotenerneuerndialog.h"
#include <QtGui/QFileDialog>

EinstellungenDialog::EinstellungenDialog(QWidget *parent) :
    QDialog(parent),
    m_ui(new Ui::EinstellungenDialog)
{
    m_ui->setupUi(this);
}

EinstellungenDialog::~EinstellungenDialog()
{
    delete m_ui;
}

void EinstellungenDialog::changeEvent(QEvent *e)
{
    switch (e->type()) {
    case QEvent::LanguageChange:
        m_ui->retranslateUi(this);
        break;
    default:
        break;
    }
}

QString EinstellungenDialog::get_xml_path() {
    return m_ui->lineEdit->text();
}

QStringList EinstellungenDialog::get_refresh_command() {
    QStringList ret;
    ret << m_ui->lineEdit_2->text() << m_ui->lineEdit_3->text() << m_ui->lineEdit_4->text();
    return ret;
}

void EinstellungenDialog::set_xml_path(QString s) {
    m_ui->lineEdit->setText(s);
}

void EinstellungenDialog::set_refresh_command(QStringList s) {
    m_ui->lineEdit_2->setText(s[0]);
    m_ui->lineEdit_3->setText(s[1]);
    m_ui->lineEdit_4->setText(s[2]);
}

void EinstellungenDialog::on_pushButton_clicked()
{
    QString s = QFileDialog::getExistingDirectory(this, "Verzeichnis wählen", ".", QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks);
    if(s != "")
        m_ui->lineEdit->setText(s);
}

void EinstellungenDialog::on_pushButton_2_clicked()
{
    QuotenErneuernDialog d;
    QStringList l;
    l << m_ui->lineEdit_2->text() << m_ui->lineEdit_3->text() << m_ui->lineEdit_4->text();
    d.starte_befehl(l);
    //system(m_ui->lineEdit_2->text().toAscii());
}
