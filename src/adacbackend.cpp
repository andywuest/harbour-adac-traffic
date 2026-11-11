/**
 * harbour-adac-traffic - Sailfish OS Version
 * Copyright © 2024 Andreas Wüst (andreas.wuest.freelancer@gmail.com)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
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

void ADACBackend::getTrafficData(const QString country, const QString state, const QString streetName, bool showConstructionSites, int page) {
 qDebug() << "ADACBackend::getTrafficData";

 QNetworkReply *reply = executeGetRequest(QUrl(ADAC_URL), country, state, streetName, showConstructionSites, page);

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

QNetworkReply *ADACBackend::executePostRequest(const QUrl &url, const QString country, const QString state, const QString streetName, bool showConstructionSites, int page) {
  qDebug() << "ADACBackend::executePostRequest " << url;
  qDebug() << "country : " << country;
  qDebug() << "federalState : " << state;
  qDebug() << " streetName : " << streetName;
  qDebug() << " showConstructionSites : " << showConstructionSites;
  qDebug() << " page : " << page;

  QNetworkRequest request(url);
  request.setHeader(QNetworkRequest::UserAgentHeader, USER_AGENT);
  request.setHeader(QNetworkRequest::ContentTypeHeader, MIME_TYPE_JSON);
  request.setRawHeader("Origin", "https://www.adac.de");

  QString postBody(ADAC_POST_BODY);

  QString postBodyString = postBody.arg(country, state, streetName, showConstructionSites ? "true" : "false", QString::number(page));

  QByteArray finalPostBody = postBodyString.toUtf8();

  qDebug() << "body : " << postBodyString;

  return manager->post(request, finalPostBody);
}

QNetworkReply *ADACBackend::executeGetRequest(const QUrl &url, const QString country, const QString state, const QString streetName, bool showConstructionSites, int page) {
  qDebug() << "ADACBackend::executeGetRequest " << url;
  qDebug() << "country : " << country;
  qDebug() << "federalState : " << state;
  qDebug() << " streetName : " << streetName;
  qDebug() << " showConstructionSites : " << showConstructionSites;
  qDebug() << " page : " << page;

  QString requestUrl(ADAC_GET_URL);
  requestUrl.replace("{country}", country);
  requestUrl.replace("{state}", state);
  requestUrl.replace("{street}", QString::fromUtf8(QUrl::toPercentEncoding(streetName)));
  requestUrl.replace("{constructionSites}", showConstructionSites ? "true" : "false");
  requestUrl.replace("{pageNumber}", QString::number(page));

  qDebug() << "url : " << requestUrl;

  QNetworkRequest request{QUrl(requestUrl)};
  request.setHeader(QNetworkRequest::UserAgentHeader, USER_AGENT);
  request.setHeader(QNetworkRequest::ContentTypeHeader, MIME_TYPE_JSON);
  request.setRawHeader("Origin", "https://www.adac.de");
  request.setRawHeader("apollo-require-preflight", "true");

  return manager->get(request);
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
