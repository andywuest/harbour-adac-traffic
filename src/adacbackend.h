#ifndef ADAC_BACKEND_H
#define ADAC_BACKEND_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QObject>

class ADACBackend : public QObject
{
    Q_OBJECT
public:
    explicit ADACBackend(QNetworkAccessManager *manager, QObject *parent = nullptr);
    ~ADACBackend();

  Q_INVOKABLE virtual void getTrafficData(const QString country, const QString state, const QString streetName, bool showConstructionSites);

  Q_SIGNAL void requestError(const QString &errorMessage);

    // signals for the qml part
    Q_SIGNAL void getTrafficDataResultAvailable(const QString &reply);

private slots:
  void handleGetTrafficDataFinished();

protected:
  QNetworkAccessManager *manager;

  QNetworkReply *executePostRequest(const QUrl &url, const QString country, const QString state, const QString streetName, bool showConstructionSites);
  void connectErrorSlot(QNetworkReply *reply);
  QString processSearchResult(QByteArray searchReply);

};

#endif // ADAC_BACKEND_H
