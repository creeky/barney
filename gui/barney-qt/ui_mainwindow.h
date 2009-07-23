/********************************************************************************
** Form generated from reading ui file 'mainwindow.ui'
**
** Created: Thu Jul 23 16:47:32 2009
**      by: Qt User Interface Compiler version 4.5.0
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QHBoxLayout>
#include <QtGui/QHeaderView>
#include <QtGui/QMainWindow>
#include <QtGui/QMenu>
#include <QtGui/QMenuBar>
#include <QtGui/QStatusBar>
#include <QtGui/QTableWidget>
#include <QtGui/QTreeWidget>
#include <QtGui/QVBoxLayout>
#include <QtGui/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindowClass
{
public:
    QAction *actionBeenden;
    QAction *actionEinstellungen;
    QWidget *centralWidget;
    QVBoxLayout *verticalLayout;
    QHBoxLayout *horizontalLayout;
    QTableWidget *anbieterliste;
    QTreeWidget *sportartenliste;
    QTableWidget *spielliste;
    QMenuBar *menuBar;
    QMenu *menuDatei;
    QMenu *menuBearbeiten;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *MainWindowClass)
    {
        if (MainWindowClass->objectName().isEmpty())
            MainWindowClass->setObjectName(QString::fromUtf8("MainWindowClass"));
        MainWindowClass->resize(761, 503);
        actionBeenden = new QAction(MainWindowClass);
        actionBeenden->setObjectName(QString::fromUtf8("actionBeenden"));
        actionEinstellungen = new QAction(MainWindowClass);
        actionEinstellungen->setObjectName(QString::fromUtf8("actionEinstellungen"));
        centralWidget = new QWidget(MainWindowClass);
        centralWidget->setObjectName(QString::fromUtf8("centralWidget"));
        verticalLayout = new QVBoxLayout(centralWidget);
        verticalLayout->setSpacing(6);
        verticalLayout->setMargin(11);
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setSpacing(6);
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        anbieterliste = new QTableWidget(centralWidget);
        if (anbieterliste->columnCount() < 2)
            anbieterliste->setColumnCount(2);
        QTableWidgetItem *__qtablewidgetitem = new QTableWidgetItem();
        anbieterliste->setHorizontalHeaderItem(0, __qtablewidgetitem);
        QTableWidgetItem *__qtablewidgetitem1 = new QTableWidgetItem();
        anbieterliste->setHorizontalHeaderItem(1, __qtablewidgetitem1);
        anbieterliste->setObjectName(QString::fromUtf8("anbieterliste"));

        horizontalLayout->addWidget(anbieterliste);

        sportartenliste = new QTreeWidget(centralWidget);
        sportartenliste->setObjectName(QString::fromUtf8("sportartenliste"));
        sportartenliste->header()->setVisible(false);

        horizontalLayout->addWidget(sportartenliste);


        verticalLayout->addLayout(horizontalLayout);

        spielliste = new QTableWidget(centralWidget);
        if (spielliste->columnCount() < 7)
            spielliste->setColumnCount(7);
        QTableWidgetItem *__qtablewidgetitem2 = new QTableWidgetItem();
        spielliste->setHorizontalHeaderItem(0, __qtablewidgetitem2);
        QTableWidgetItem *__qtablewidgetitem3 = new QTableWidgetItem();
        spielliste->setHorizontalHeaderItem(1, __qtablewidgetitem3);
        QTableWidgetItem *__qtablewidgetitem4 = new QTableWidgetItem();
        spielliste->setHorizontalHeaderItem(2, __qtablewidgetitem4);
        QTableWidgetItem *__qtablewidgetitem5 = new QTableWidgetItem();
        spielliste->setHorizontalHeaderItem(3, __qtablewidgetitem5);
        QTableWidgetItem *__qtablewidgetitem6 = new QTableWidgetItem();
        spielliste->setHorizontalHeaderItem(4, __qtablewidgetitem6);
        QTableWidgetItem *__qtablewidgetitem7 = new QTableWidgetItem();
        spielliste->setHorizontalHeaderItem(5, __qtablewidgetitem7);
        QTableWidgetItem *__qtablewidgetitem8 = new QTableWidgetItem();
        spielliste->setHorizontalHeaderItem(6, __qtablewidgetitem8);
        if (spielliste->rowCount() < 1)
            spielliste->setRowCount(1);
        spielliste->setObjectName(QString::fromUtf8("spielliste"));
        spielliste->setRowCount(1);
        spielliste->setColumnCount(7);

        verticalLayout->addWidget(spielliste);

        MainWindowClass->setCentralWidget(centralWidget);
        menuBar = new QMenuBar(MainWindowClass);
        menuBar->setObjectName(QString::fromUtf8("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 761, 25));
        menuDatei = new QMenu(menuBar);
        menuDatei->setObjectName(QString::fromUtf8("menuDatei"));
        menuBearbeiten = new QMenu(menuBar);
        menuBearbeiten->setObjectName(QString::fromUtf8("menuBearbeiten"));
        MainWindowClass->setMenuBar(menuBar);
        statusBar = new QStatusBar(MainWindowClass);
        statusBar->setObjectName(QString::fromUtf8("statusBar"));
        MainWindowClass->setStatusBar(statusBar);

        menuBar->addAction(menuDatei->menuAction());
        menuBar->addAction(menuBearbeiten->menuAction());
        menuDatei->addAction(actionBeenden);
        menuBearbeiten->addAction(actionEinstellungen);

        retranslateUi(MainWindowClass);

        QMetaObject::connectSlotsByName(MainWindowClass);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindowClass)
    {
        MainWindowClass->setWindowTitle(QApplication::translate("MainWindowClass", "MainWindow", 0, QApplication::UnicodeUTF8));
        actionBeenden->setText(QApplication::translate("MainWindowClass", "Beenden", 0, QApplication::UnicodeUTF8));
        actionEinstellungen->setText(QApplication::translate("MainWindowClass", "Einstellungen", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem = anbieterliste->horizontalHeaderItem(0);
        ___qtablewidgetitem->setText(QApplication::translate("MainWindowClass", "Anbieter", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem1 = anbieterliste->horizontalHeaderItem(1);
        ___qtablewidgetitem1->setText(QApplication::translate("MainWindowClass", "Verwenden?", 0, QApplication::UnicodeUTF8));
        QTreeWidgetItem *___qtreewidgetitem = sportartenliste->headerItem();
        ___qtreewidgetitem->setText(1, QApplication::translate("MainWindowClass", "id", 0, QApplication::UnicodeUTF8));
        ___qtreewidgetitem->setText(0, QApplication::translate("MainWindowClass", "Sportarten / Ligen", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem2 = spielliste->horizontalHeaderItem(0);
        ___qtablewidgetitem2->setText(QApplication::translate("MainWindowClass", "Spiel ID", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem3 = spielliste->horizontalHeaderItem(1);
        ___qtablewidgetitem3->setText(QApplication::translate("MainWindowClass", "Team 1", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem4 = spielliste->horizontalHeaderItem(2);
        ___qtablewidgetitem4->setText(QApplication::translate("MainWindowClass", "Odd 1", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem5 = spielliste->horizontalHeaderItem(3);
        ___qtablewidgetitem5->setText(QApplication::translate("MainWindowClass", "Anbieter 1", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem6 = spielliste->horizontalHeaderItem(4);
        ___qtablewidgetitem6->setText(QApplication::translate("MainWindowClass", "Team 2", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem7 = spielliste->horizontalHeaderItem(5);
        ___qtablewidgetitem7->setText(QApplication::translate("MainWindowClass", "Odd 2", 0, QApplication::UnicodeUTF8));
        QTableWidgetItem *___qtablewidgetitem8 = spielliste->horizontalHeaderItem(6);
        ___qtablewidgetitem8->setText(QApplication::translate("MainWindowClass", "Anbieter 2", 0, QApplication::UnicodeUTF8));
        menuDatei->setTitle(QApplication::translate("MainWindowClass", "Datei", 0, QApplication::UnicodeUTF8));
        menuBearbeiten->setTitle(QApplication::translate("MainWindowClass", "Bearbeiten", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class MainWindowClass: public Ui_MainWindowClass {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
