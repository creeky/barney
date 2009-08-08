#include "quotenerneuerndialog.h"
#include "ui_quotenerneuerndialog.h"

QuotenErneuernDialog::QuotenErneuernDialog(QWidget *parent) :
    QDialog(parent),
    m_ui(new Ui::QuotenErneuernDialog)
{
    m_ui->setupUi(this);

//    connect(&process, SIGNAL(readyReadStandardError()), this, SLOT(update()));
    connect(&process, SIGNAL(readyReadStandardOutput()), this, SLOT(update()));
    connect(&process, SIGNAL(finished(int, QProcess::ExitStatus)), this, SLOT(finish(int, QProcess::ExitStatus)));
    connect(m_ui->pushButton, SIGNAL(clicked()), &process, SLOT(terminate()));
}

QuotenErneuernDialog::~QuotenErneuernDialog()
{
    delete m_ui;
}

void QuotenErneuernDialog::changeEvent(QEvent *e)
{
    switch (e->type()) {
    case QEvent::LanguageChange:
        m_ui->retranslateUi(this);
        break;
    default:
        break;
    }
}

void QuotenErneuernDialog::starte_befehl(QStringList s) {
    process.setWorkingDirectory(s[1]);
//    process.setProcessChannelMode(QProcess::MergedChannels);
    process.setReadChannel(QProcess::StandardOutput);
    QStringList s3;

    s3 = s[2].split(" ");

    if(s3[0] == "" || s3.isEmpty())
        process.start(s[0]);
    else
        process.start(s[0], s3);

    exec();
}

void QuotenErneuernDialog::update() {
    m_ui->plainTextEdit->appendPlainText(process.readAllStandardOutput());
}

void QuotenErneuernDialog::finish(int exitCode, QProcess::ExitStatus exitStatus) {
    update();
    m_ui->plainTextEdit->appendPlainText(QString("Skript beendet mit ExitCode %1").arg(exitCode));
    close();
}
