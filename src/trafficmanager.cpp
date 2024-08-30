#include "trafficmanager.h"

TrafficManager::TrafficManager(QObject *parent) : QObject(parent)
  , networkAccessManager(new QNetworkAccessManager(this))
      , networkConfigurationManager(new QNetworkConfigurationManager(this))
      , settings("harbour-vvs-incidents", "settings")
{
    adacBackend = new ADACBackend(this->networkAccessManager, this);
}

ADACBackend *TrafficManager::getAdacBackend() {
    return this->adacBackend;
}
