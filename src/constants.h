#ifndef CONSTANTS_H
#define CONSTANTS_H

const char MIME_TYPE_JSON[] = "application/json";
const char USER_AGENT[] = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/73.0";
const char ADAC_URL[] = "https://www.adac.de/bff";

const char ADAC_POST_BODY[] = "{"
        "   \"operationName\":\"TrafficNews\","
        "   \"variables\":{"
        "      \"filter\":{"
        "         \"country\":{"
        "            \"country\":\"%1\","
        "            \"federalState\":\"%2\","
        "            \"street\":\"%3\","
        "            \"showConstructionSites\":%4,"
        "            \"showTrafficNews\":true,"
        "            \"pageNumber\":%5"
        "         }"
        "      }"
        "   },"
        "   \"query\":\"query TrafficNews($filter: TrafficNewsFilterInput!) {  trafficNews(filter: $filter) {...TrafficNewsItems} }  fragment TrafficNewsItems on TrafficNews {  size  items {...TrafficNewsItem}} fragment TrafficNewsItem on TrafficNewsItem {  id   type  details  street  timeLoss  streetSign {    streetNumber    country  }  headline {    __typename    ...TrafficNewsDirectionHeadline    ...TrafficNewsNonDirectionHeadline  }} fragment TrafficNewsDirectionHeadline on TrafficNewsDirectionHeadline {  from  to} fragment TrafficNewsNonDirectionHeadline on TrafficNewsNonDirectionHeadline {  text }\""
        "}";

//const char ADAC_POST_BODY[] = "{"
//        "   \"operationName\":\"TrafficNews\","
//        "   \"variables\":{"
//        "      \"filter\":{"
//        "         \"country\":{"
//        "            \"country\":\"%1\","
//        "            \"federalState\":\"%2\","
//        "            \"street\":\"%3\","
//        "            \"showConstructionSites\":false,"
//        "            \"showTrafficNews\":true,"
//        "            \"pageNumber\":1"
//        "         }"
//        "      }"
//        "   },"
//        "   \"query\":\"%4\""
//        "}";

const char GRAPHQL_QUERY[] = R"(
query TrafficNews($filter: TrafficNewsFilterInput!) {
  trafficNews(filter: $filter) {
    ...TrafficNewsItems
    __typename
  }
}
fragment TrafficNewsItems on TrafficNews {
  size
  items {
    ...TrafficNewsItem
    __typename
  }
  __typename
}
fragment TrafficNewsItem on TrafficNewsItem {
  id
  type
  image {
    ...Image
    __typename
  }
  details
  street
  timeLoss
  streetSign {
    streetNumber
    country
    __typename
  }
  headline {
    __typename
    ...TrafficNewsDirectionHeadline
    ...TrafficNewsNonDirectionHeadline
  }
  __typename
}
fragment TrafficNewsDirectionHeadline on TrafficNewsDirectionHeadline {
  from
  to
  __typename
}
fragment TrafficNewsNonDirectionHeadline on TrafficNewsNonDirectionHeadline {
  text
  __typename
}
)";


#endif // CONSTANTS_H

// "   \"query\":\"query TrafficNews($filter: TrafficNewsFilterInput!) {\n  trafficNews(filter: $filter) {\n    ...TrafficNewsItems\n    __typename\n  }\n}\n\nfragment TrafficNewsItems on TrafficNews {\n  size\n  items {\n    ...TrafficNewsItem\n    __typename\n  }\n  __typename\n}\n\nfragment TrafficNewsItem on TrafficNewsItem {\n  id\n  type\n  image {\n    ...Image\n    __typename\n  }\n  details\n  street\n  timeLoss\n  streetSign {\n    streetNumber\n    country\n    __typename\n  }\n  headline {\n    __typename\n    ...TrafficNewsDirectionHeadline\n    ...TrafficNewsNonDirectionHeadline\n  }\n  __typename\n}\n\nfragment TrafficNewsDirectionHeadline on TrafficNewsDirectionHeadline {\n  from\n  to\n  __typename\n}\n\nfragment TrafficNewsNonDirectionHeadline on TrafficNewsNonDirectionHeadline {\n  text\n  __typename}\"\n"
