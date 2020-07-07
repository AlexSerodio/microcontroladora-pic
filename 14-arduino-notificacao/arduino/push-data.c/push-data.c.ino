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

// You should get Auth Token in the Blynk App.
// Go to the Project Settings (nut icon).
char auth[] = "4pCU5i2GXHBwGBdRMRvxlWXbkX7WKnZh";

BlynkTimer timer;

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
//  Serial.println(digitalRead(8));

  int cozinha = digitalRead(8);
  int quarto = digitalRead(9);
  int sala = digitalRead(12);
  int escritorio = digitalRead(13);

  if(cozinha != old_cozinha)
  {
    Blynk.virtualWrite(V0, "add", 0, "Cozinha", cozinha ? "Aberto" : "Fechado");
    Blynk.virtualWrite(V0, cozinha ? "select" : "deselect", 0);
    if(notificar)
    {
      if(cozinha)
        Blynk.notify("Você esqueceu a cozinha aberta!"); 
      else
        Blynk.notify("A cozinha foi fechada."); 
    }
    old_cozinha = cozinha;
  }

  if(quarto != old_quarto)
  {
    Blynk.virtualWrite(V0, "add", 1, "Quarto", quarto ? "Aberto" : "Fechado");
    Blynk.virtualWrite(V0, quarto ? "select" : "deselect", 1);
    if(notificar)
    {
      if(quarto)
        Blynk.notify("Você esqueceu o quarto aberto!");
      else
        Blynk.notify("O quarto foi fechado.");
    }
    old_quarto = quarto;
  }

  if(sala != old_sala)
  {
    Blynk.virtualWrite(V0, "add", 2, "Sala", sala ? "Aberto" : "Fechado");
    Blynk.virtualWrite(V0, sala ? "select" : "deselect", 2);
    if(notificar)
    {
      if(sala)
        Blynk.notify("Você esqueceu a sala aberta!"); 
      else
        Blynk.notify("A sala foi fechada."); 
    }
    old_sala = sala;
  }

  if(escritorio != old_escritorio)
  {
    Blynk.virtualWrite(V0, "add", 3, "Escritorio", escritorio ? "Aberto" : "Fechado");
    Blynk.virtualWrite(V0, escritorio ? "select" : "deselect", 3);
    if(notificar)
    {
      if(escritorio)
        Blynk.notify("Você esqueceu o escritório aberto!"); 
      else
        Blynk.notify("O escritório foi fechado."); 
    }
    old_escritorio = escritorio;
  }
  
//  Blynk.virtualWrite(V1, t);
}

BLYNK_WRITE(V1)
{
  int buttonState = param.asInt();
  notificar = buttonState;
}

void setup()
{
  // Debug console
  Serial.begin(9600);
  
  pinMode(8, INPUT);
  pinMode(9, INPUT);
  pinMode(12, INPUT);
  pinMode(13, INPUT);

  Blynk.begin(auth);

  Blynk.virtualWrite(V0, "clr");
  Blynk.virtualWrite(V1, LOW);

  timer.setInterval(1000L, myTimerEvent);
}

void loop()
{
  Blynk.run();
  timer.run();
}
