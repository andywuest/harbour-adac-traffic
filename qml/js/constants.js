.pragma library

var loggingEnabled = true;

var BACKEND_ADAC = 0;

var COUNTRY_GERMANY = 0;
var COUNTRY_AUSTRIA = 1;
var COUNTRY_SWITZERLAND = 2;
var COUNTRY_ITALY = 3;

var COUNTRY_MAP = [];
COUNTRY_MAP[0] = "D";
COUNTRY_MAP[1] = "AT";
COUNTRY_MAP[2] = "CH";
COUNTRY_MAP[3] = "IT";

var STATE_NONE = 0;
var STATE_BW = 1;

var STATE_MAP = [];
STATE_MAP[0] = "";
STATE_MAP[1] = "Baden-Württemberg";
STATE_MAP[2] = "Bayern";
STATE_MAP[3] = "Berlin";
STATE_MAP[4] = "Brandenburg";
STATE_MAP[5] = "Bremen";
STATE_MAP[6] = "Hamburg";
STATE_MAP[7] = "Hessen";
STATE_MAP[8] = "Mecklenburg-Vorpommern";
STATE_MAP[9] = "Niedersachsen";
STATE_MAP[10] = "Nordrhein-Westfalen";
STATE_MAP[11] = "Rheinland-Pfalz";
STATE_MAP[12] = "Saarland";
STATE_MAP[13] = "Sachsen";
STATE_MAP[14] = "Sachsen-Anhalt";
STATE_MAP[15] = "Schleswig-Holstein";
STATE_MAP[16] = "Thüringen";

// TODO wird diese map noch benoetigt?
var STATE_MAP_SEARCH = [];
STATE_MAP_SEARCH[0] = "";
STATE_MAP_SEARCH[1] = "BW";
STATE_MAP_SEARCH[2] = "Bayern";
STATE_MAP_SEARCH[3] = "Berlin";
STATE_MAP_SEARCH[4] = "Brandenburg";
STATE_MAP_SEARCH[5] = "Bremen";
STATE_MAP_SEARCH[6] = "Hamburg";
STATE_MAP_SEARCH[7] = "Hessen";
STATE_MAP_SEARCH[8] = "MV";
STATE_MAP_SEARCH[9] = "Niedersachsen";
STATE_MAP_SEARCH[10] = "NW";
STATE_MAP_SEARCH[11] = "RP";
STATE_MAP_SEARCH[12] = "Saarland";
STATE_MAP_SEARCH[13] = "Sachsen";
STATE_MAP_SEARCH[14] = "Sachsen-Anhalt";
STATE_MAP_SEARCH[15] = "SH";
STATE_MAP_SEARCH[16] = "Thüringen";
