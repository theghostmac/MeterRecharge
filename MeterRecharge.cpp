#include <WiFi.h>
#include <WebServer.h>
#include <SPIFFS.h>

// Add the correct network credentials.
const char* ssid = "NETWORK_SSID"p;
const char* password = "NETWORK_PASSWORD";

WebServer server(80);

void setup()  {
    Serial.begin(115200);

    // Initialize SPIFFS
    if(!SPIFFS.begin(true)){
        Serial.println("An error has occurred while mounting SPIFFS");
        return;
    }

    // Connect to Wi-Fi
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.println("Connecting to WiFi...");
    }

    // Print ESP32 Local IP Address.
    Serial.println(WiFi.localIP());

    // Route for root / web page.
    server.on("/", HTTP_GET, [](WebServer *server){
        server->send(SPIFFS, "/index.html", "text/html");
    });

    // Route to load MeterRecharge.json file.
    server.on("/MeterRecharge.json", HTTP_GET, [](WebServer *server){
        server->send(SPIFFS, "/MeterRecharge.json", "application/json");
    });

    server.begin();
}

void loop() {
    server.handleClient();
}