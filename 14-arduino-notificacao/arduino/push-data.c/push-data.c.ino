/*************************************************************
  Download latest Blynk library here:
    https://github.com/blynkkk/blynk-library/releases/latest

  Blynk is a platform with iOS and Android apps to control
  Arduino, Raspberry Pi and the likes over the Internet.
  You can easily build graphic interfaces for all your
  projects by simply dragging and dropping widgets.

    Downloads, docs, tutorials: http://www.blynk.cc
    Sketch generator:           http://examples.blynk.cc
    Blynk community:            http://community.blynk.cc
    Follow us:                  http://www.fb.com/blynkapp
                                http://twitter.com/blynk_app

  Blynk library is licensed under MIT license
  This example code is in public domain.

 *************************************************************
  For this example you need UIPEthernet library:
    https://github.com/UIPEthernet/UIPEthernet

  Typical wiring would be (this is for Arduino UNO,
  search for correct wiring for your board):
   VCC -- 5V
   GND -- GND
   CS  -- D10
   SI  -- D11
   SCK -- D13
   SO  -- D12
   INT -- D2

  This example shows how value can be pushed from Arduino to
  the Blynk App.

  NOTE:
  BlynkTimer provides SimpleTimer functionality:
    http://playground.arduino.cc/Code/SimpleTimer

  App project setup:
    Value Display widget attached to Virtual Pin V5
 *************************************************************/

/* Comment this out to disable prints and save space */
#define BLYNK_PRINT Serial
#define DHTPIN 3
#define DHTTYPE DHT11

#include <UIPEthernet.h>
#include <BlynkSimpleUIPEthernet.h>
#include "DHT.h"

// You should get Auth Token in the Blynk App.
// Go to the Project Settings (nut icon).
char auth[] = "4pCU5i2GXHBwGBdRMRvxlWXbkX7WKnZh";

BlynkTimer timer;

DHT dht(DHTPIN, DHTTYPE);

float h, t;

int old_cozinha = -1;
int old_quarto = -1;
int old_sala = -1;
int old_escritorio = -1;

int notificar = 0;

// This function sends Arduino's up time every second to Virtual Pin (5).
// In the app, Widget's reading frequency should be set to PUSH. This means
// that you define how often to send data to Blynk App.
void myTimerEvent()
{
  // You can send any value at any time.
  // Please don't send more that 10 values per second.
//  Serial.println(analogRead(A0));
//  Blynk.virtualWrite(V0, analogRead(A0));
//  Blynk.virtualWrite(V1, analogRead(A1));
//  Blynk.virtualWrite(V2, analogRead(A2));
//  Blynk.virtualWrite(V3, analogRead(A3));
  //Blynk.virtualWrite(V0, millis() / 1000);

//  h = dht.readHumidity();
//  Blynk.virtualWrite(V0, h);
//  
//  t = dht.readTemperature();
//  Blynk.virtualWrite(V1, t);

//  Serial.println(digitalRead(8));

  int cozinha = digitalRead(8);
  int quarto = digitalRead(9);
  int sala = digitalRead(12);
  int escritorio = digitalRead(13);

  if(cozinha != old_cozinha)
  {
    Blynk.virtualWrite(V0, "add", 0, "Cozinha", cozinha ? "Aberto" : "Fechado");
    Blynk.virtualWrite(V0, cozinha ? "select" : "deselect", 0);
    if(cozinha and notificar)
      Blynk.notify("Você esqueceu a cozinha aberta!");
    old_cozinha = cozinha;
  }

  if(quarto != old_quarto)
  {
    Blynk.virtualWrite(V0, "add", 1, "Quarto", quarto ? "Aberto" : "Fechado");
    Blynk.virtualWrite(V0, quarto ? "select" : "deselect", 1);
    if(quarto && notificar)
      Blynk.notify("Você esqueceu o quarto aberto!");
    old_quarto = quarto;
  }

  if(sala != old_sala)
  {
    Blynk.virtualWrite(V0, "add", 2, "Sala", sala ? "Aberto" : "Fechado");
    Blynk.virtualWrite(V0, sala ? "select" : "deselect", 2);
    if(sala && notificar)
      Blynk.notify("Você esqueceu a sala aberta!");
    old_sala = sala;
  }

  if(escritorio != old_escritorio)
  {
    Blynk.virtualWrite(V0, "add", 3, "Escritorio", escritorio ? "Aberto" : "Fechado");
    Blynk.virtualWrite(V0, escritorio ? "select" : "deselect", 3);
    if(escritorio && notificar)
      Blynk.notify("Você esqueceu o escritório aberto!");
    old_escritorio = escritorio;
  }
  
//  Blynk.virtualWrite(V1, t);
}

void notifyUptime()
{
  long uptime = millis() / 60000L;

  // Actually send the message.
  // Note:
  //   We allow 1 notification per 5 seconds for now.
  Blynk.notify(String("Você esqueceu algo aberto") + uptime + " minutes.");

  // You can also use {DEVICE_NAME} placeholder for device name,
  // that will be replaced by your device name on the server side.
  // Blynk.notify(String("{DEVICE_NAME} running for ") + uptime + " minutes.");
}

BLYNK_WRITE(V1)
{
  int buttonState = param.asInt();
  notificar = buttonState;
}

// This function will be called every time Slider Widget
// in Blynk app writes values to the Virtual Pin 1
//BLYNK_WRITE(V4)
//{
//  int pinValue = param.asInt();
//  digitalWrite(4, pinValue);
//}
//
//BLYNK_WRITE(V5)
//{
//  int pinValue = param.asInt();
//  digitalWrite(5, pinValue);
//}
//
//BLYNK_WRITE(V6)
//{
//  int pinValue = param.asInt();
//  digitalWrite(6, pinValue);
//}
//
//BLYNK_WRITE(V7)
//{
//  int pinValue = param.asInt();
//  digitalWrite(7, pinValue);
//}

void setup()
{
  // Debug console
  Serial.begin(9600);

//  dht.begin();

//  pinMode(4, OUTPUT);
//  pinMode(5, OUTPUT);
//  pinMode(6, OUTPUT);
//  pinMode(7, OUTPUT);
//
//  digitalWrite(4, LOW);
//  digitalWrite(5, LOW);
//  digitalWrite(6, LOW);
//  digitalWrite(7, LOW);

  pinMode(8, INPUT);
  pinMode(9, INPUT);
  pinMode(12, INPUT);
  pinMode(13, INPUT);

  Blynk.begin(auth);
  // You can also specify server:
  //Blynk.begin(auth, "blynk-cloud.com", 80);
  //Blynk.begin(auth, IPAddress(192,168,100,1), 8080);

  // Notify immediately on startup
//  Blynk.notify("Device started");

  // Setup a function to be called every minute
  //timer.setInterval(60000L, notifyUptime);

  Blynk.virtualWrite(V0, "clr");

  // Setup a function to be called every second
  timer.setInterval(1000L, myTimerEvent);
}

void loop()
{
  Blynk.run();
  timer.run(); // Initiates BlynkTimer  
}
