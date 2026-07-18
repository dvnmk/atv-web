#include <WiFi.h>
#include <WebServer.h>
#include <ESPmDNS.h>
#include <IRremote.hpp>
#include "secrets.h"

#define IR_SEND_PIN 4

WebServer server(80);

// ======================
// IR command codes
// ======================

#define IR_UP       0x01
#define IR_DOWN     0x02
#define IR_LEFT     0x03
#define IR_RIGHT    0x04
#define IR_SELECT   0x05
#define IR_MENU     0x06
#define IR_HOME     0x07

#define IR_PLAY     0x08
#define IR_PAUSE    0x08
#define IR_STOP     0x10
#define IR_RWD      0x11
#define IR_FWD      0x12
#define IR_PRE      0x13
#define IR_NXT      0x14
#define IR_BEG      0x15
#define IR_END      0x16

// Send one IR frame
void sendIR(uint8_t code)
{
  Serial.printf("IR SEND : 0x%02X\n", code);
  IrSender.sendNEC(0x00, code, 0);
}

// Send repeated IR frames for duration
void sendIRRepeat(uint8_t code, uint32_t duration)
{
  uint32_t start = millis();
  while (millis() - start < duration)
  {
    IrSender.sendNEC(0x00, code, 0);
    delay(110);
    server.handleClient();
  }
}

constexpr uint16_t HOLD_INTERVAL = 30;
constexpr uint32_t HOLD_TIME = 1500;

// Emulate a held button by rapidly retransmitting the command.
void sendIRHold(uint8_t code, uint32_t duration)
{
	uint32_t start = millis();

	while (millis() - start < duration)
		{
			sendIR(code);
			delay(HOLD_INTERVAL);
			server.handleClient();
		}
}

// Create normal, double, hold and setup URLs
void addButton(const char* name, uint8_t code)
{
  String normal = "/" + String(name);
  String doublePress = "/" + String(name) + "/2";
  String hold = "/" + String(name) + "/hold";

  // Normal button
  server.on(normal.c_str(), [code, name]()
  {
    sendIR(code);
    server.send(200, "text/plain", String(name));
  });

  // Double press
  server.on(doublePress.c_str(), [code, name]()
  {
    sendIR(code);
    delay(150);
    sendIR(code);
    server.send(200, "text/plain", String(name) + " x2");
  });

	// Hold button
	server.on(hold.c_str(), [code, name]()
{
    sendIRHold(code, HOLD_TIME);
    server.send(200, "text/plain", String(name) + " HOLD");
});



}

void setup()
{
  Serial.begin(115200);
  delay(500);

  Serial.println();
  Serial.println("ATOMS3 Apple TV IR Remote");

  // IR transmitter
  IrSender.begin(IR_SEND_PIN);

  // WiFi
  WiFi.begin(ssid, password);
  Serial.print("Connecting WiFi");
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println();
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  // mDNS
  if (MDNS.begin("atv-ir"))
  {
    Serial.println("mDNS started");
    Serial.println("URL:");
    Serial.println("http://atv-ir.local");
    MDNS.addService("http", "tcp", 80);
  }
  else
  {
    Serial.println("mDNS failed");
  }

  // API URLs
  addButton("up", IR_UP);
  addButton("down", IR_DOWN);
  addButton("left", IR_LEFT);
  addButton("right", IR_RIGHT);
  addButton("select", IR_SELECT);
  addButton("menu", IR_MENU);
  addButton("home", IR_HOME);

  addButton("play", IR_PLAY);
  addButton("pause", IR_PAUSE);
  addButton("stop", IR_STOP);
  addButton("rwd", IR_RWD);
  addButton("fwd", IR_FWD);
  addButton("pre", IR_PRE);
  addButton("nxt", IR_NXT);
  addButton("beg", IR_BEG);
  addButton("end", IR_END);

  // Web control page
  server.on("/", []()
  {
    String html;
    html += "<html><head><meta name='viewport' content='width=device-width'>";
    html += "<style>button{width:120px;height:50px;font-size:20px;margin:5px;}</style></head><body>";
    html += "<h2>ATOMS3 Apple TV IR</h2>";

    html += "<h3>Remote</h3>";
    html += "<button onclick=\"location.href='/up'\">UP</button><br>";
    html += "<button onclick=\"location.href='/left'\">LEFT</button>";
    html += "<button onclick=\"location.href='/select'\">OK</button>";
    html += "<button onclick=\"location.href='/right'\">RIGHT</button><br>";
    html += "<button onclick=\"location.href='/down'\">DOWN</button><br>";
    html += "<button onclick=\"location.href='/menu'\">MENU</button>";
    html += "<button onclick=\"location.href='/home'\">HOME</button><br>";

    html += "<h3>Playback</h3>";
    html += "<button onclick=\"location.href='/play'\">PLAY</button>";
    html += "<button onclick=\"location.href='/pause'\">PAUSE</button>";
    html += "<button onclick=\"location.href='/stop'\">STOP</button><br>";
    html += "<button onclick=\"location.href='/rwd'\">RWD</button>";
    html += "<button onclick=\"location.href='/fwd'\">FWD</button>";
    html += "<button onclick=\"location.href='/pre'\">PREV</button>";
    html += "<button onclick=\"location.href='/nxt'\">NEXT</button><br>";
    html += "<button onclick=\"location.href='/beg'\">BEGIN</button>";
    html += "<button onclick=\"location.href='/end'\">END</button><br>";

		html += "<button onclick=\"location.href='/menu/2'\">MENU x2</button>";
    html += "<button onclick=\"location.href='/menu/hold'\">MENU HOLD</button>";
		html += "<button onclick=\"location.href='/select/hold'\">SELECT HOLD</button>";
    html += "</body></html>";

    server.send(200, "text/html", html);
  });

  // Status API
  server.on("/status", []()
  {
    String json = "{";
    json += "\"device\":\"ATOMS3 Apple TV IR\",";
    json += "\"wifi\":\"" + String(WiFi.status() == WL_CONNECTED ? "connected" : "disconnected") + "\",";
    json += "\"ip\":\"" + WiFi.localIP().toString() + "\",";
    json += "\"rssi\":" + String(WiFi.RSSI());
    json += "}";
    server.send(200, "application/json", json);
  });

  server.begin();
  Serial.println("HTTP server started");
}

void loop()
{
  server.handleClient();
}
