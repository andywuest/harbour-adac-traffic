#include "adacbackend.h"
#include "constants.h"

#include <QJsonArray>
#include <QJsonDocument>

ADACBackend::ADACBackend(QNetworkAccessManager *manager, QObject *parent) : QObject(parent)
{
  qDebug() << "Initializing ADAC Traffic Backend...";
  this->manager = manager;
}

ADACBackend::~ADACBackend() {
  qDebug() << "Shutting down ADAC Traffic Backend...";
}

void ADACBackend::getTrafficData(QString country, QString streetName) {
 qDebug() << "ADACBackend::getTrafficData";
 qDebug() << "country : " << country << ", streetName : " << streetName;

 QNetworkReply *reply = executePostRequest(QUrl(ADAC_URL), country, streetName);

 connectErrorSlot(reply);
 connect(reply, SIGNAL(finished()), this, SLOT(handleGetTrafficDataFinished()));
}

void ADACBackend::handleGetTrafficDataFinished() {
  qDebug() << "ADACBackend::handleGetIncidentsFinished";
  QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
  reply->deleteLater();
  if (reply->error() != QNetworkReply::NoError) {
    return;
  }

  QByteArray searchReply = reply->readAll();
  QJsonDocument jsonDocument = QJsonDocument::fromJson(searchReply);
  if (jsonDocument.isObject()) {
    emit getTrafficDataResultAvailable(processSearchResult(searchReply));
  } else {
    qDebug() << "not a json object !";
  }
}

QString ADACBackend::processSearchResult(QByteArray searchReply) {
    return QString(searchReply);
}

QNetworkReply *ADACBackend::executePostRequest(const QUrl &url, const QString country, const QString streetName) {
  qDebug() << "ADACBackend::executePostRequest " << url;
  qDebug() << "country : " << country << ", streetName : " << streetName << " !";

  QNetworkRequest request(url);
  request.setHeader(QNetworkRequest::UserAgentHeader, USER_AGENT);
  request.setHeader(QNetworkRequest::ContentTypeHeader, MIME_TYPE_JSON);
  request.setRawHeader("Origin", "https://www.adac.de");

  QString postBody(ADAC_POST_BODY);

  QByteArray finalPostBody = postBody.arg(country, "", streetName, GRAPHQL_QUERY).toUtf8();

  QString encodedPass = QString(QCryptographicHash::hash(finalPostBody, QCryptographicHash::Md5));
  QByteArray hash = QCryptographicHash::hash(finalPostBody, QCryptographicHash::Md5);

//  qDebug() << encodedPass << endl;
  qDebug() << finalPostBody << endl;
  qDebug() << QString(encodedPass.toUtf8().toHex()) << endl;
  qDebug() << QString(hash.toHex()) << endl;
  qDebug() << "length: " << finalPostBody.size() << endl;
  qDebug() << "length: " << finalPostBody.mid(410, finalPostBody.size() - 1) << endl;

  request.setRawHeader("x-graph-query-hash", hash.toHex()); // TODO calculate

  return manager->post(request, finalPostBody/*postBody.arg(country, "", streetName).toUtf8()*/);
}

void ADACBackend::connectErrorSlot(QNetworkReply *reply) {
  // connect the error and also emit the error signal via a lambda expression
  connect(reply,
          static_cast<void (QNetworkReply::*)(QNetworkReply::NetworkError)>(
              &QNetworkReply::error),
          [=](QNetworkReply::NetworkError error) {
            reply->deleteLater();
            qWarning() << "ADACBackend::connectErrorSlot:"
                       << static_cast<int>(error) << reply->errorString()
                       << reply->readAll();
            emit requestError(
                "Return code: " + QString::number(static_cast<int>(error)) +
                " - " + reply->errorString());
          });
}
