#ifndef EINSTELLUNGENDIALOG_H
#define EINSTELLUNGENDIALOG_H

#include <QtGui/QDialog>

namespace Ui {
    class EinstellungenDialog;
}

class EinstellungenDialog : public QDialog {
    Q_OBJECT
    Q_DISABLE_COPY(EinstellungenDialog)
public:
    explicit EinstellungenDialog(QWidget *parent = 0);
    virtual ~EinstellungenDialog();

    QString get_xml_path();
    void set_xml_path(QString s);
    QString get_refresh_command();
    void set_refresh_command(QString s);

protected:
    virtual void changeEvent(QEvent *e);

private:
    Ui::EinstellungenDialog *m_ui;

private slots:
    void on_pushButton_2_clicked();
    void on_pushButton_clicked();
};

#endif // EINSTELLUNGENDIALOG_H
