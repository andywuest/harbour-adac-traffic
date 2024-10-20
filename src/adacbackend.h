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

  Q_INVOKABLE virtual void getTrafficData(const QString country, const QString state, const QString streetName, bool showConstructionSites, int page);

  Q_SIGNAL void requestError(const QString &errorMessage);

    // signals for the qml part
    Q_SIGNAL void getTrafficDataResultAvailable(const QString &reply);

private slots:
  void handleGetTrafficDataFinished();

protected:
  QNetworkAccessManager *manager;

  QNetworkReply *executePostRequest(const QUrl &url, const QString country, const QString state, const QString streetName, bool showConstructionSites, int page);
  void connectErrorSlot(QNetworkReply *reply);
  QString processSearchResult(QByteArray searchReply);

};

#endif // ADAC_BACKEND_H
