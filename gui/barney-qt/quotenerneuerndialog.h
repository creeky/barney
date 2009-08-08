#ifndef QUOTENERNEUERNDIALOG_H
#define QUOTENERNEUERNDIALOG_H

#include <QtGui/QDialog>
#include <QtCore/QProcess>

namespace Ui {
    class QuotenErneuernDialog;
}

class QuotenErneuernDialog : public QDialog {
    Q_OBJECT
    Q_DISABLE_COPY(QuotenErneuernDialog)
public:
    explicit QuotenErneuernDialog(QWidget *parent = 0);
    virtual ~QuotenErneuernDialog();

public slots:
    void starte_befehl(QStringList s);
    void update();
    void finish(int exitCode, QProcess::ExitStatus exitStatus);

protected:
    virtual void changeEvent(QEvent *e);

private:
    QProcess process;

    Ui::QuotenErneuernDialog *m_ui;
};

#endif // QUOTENERNEUERNDIALOG_H
