#include "TimerOne.h"
#define RED 6
#define GREEN 7
#define ORANGE 5
#define ZERO 2

#define PWM_MAX 7800
#define PWM_MIN 300

#define TEMP 25
 
volatile long timeChange = micros();
short state = 0;
int stateDebug = LOW;
long pwmOrange,pwmGreen, pwmRed;
long i;

void setup() {
  pinMode(RED, OUTPUT);
  pinMode(GREEN, OUTPUT);
  pinMode(ORANGE, OUTPUT);
  pinMode(ZERO, INPUT);
  pinMode(13, OUTPUT);
  digitalWrite(RED, LOW);
  digitalWrite(GREEN, LOW);
  digitalWrite(ORANGE, LOW);
  attachInterrupt(0, counter, CHANGE);
  Timer1.initialize(50);
  Timer1.attachInterrupt(callAnalogLight);
  pwmOrange = PWM_MAX;
  pwmRed = PWM_MIN;
  pwmGreen = 5000;
}

void loop() {
/*  for(i=old;i<PWM_MAX/10;i++)
  {
    pwmRed = i*10;
    pwmOrange = (i*10 + (PWM_MAX-PWM_MIN)/3) % PWM_MAX;
    pwmGreen = (i*10 + 2*(PWM_MAX-PWM_MIN)/3) % PWM_MAX;
    delay(2);
  }
  old = i;
  for(i=old;i>PWM_MIN/10;i--)
  {
    pwmRed = i*10;
    pwmOrange = (i*10 + (PWM_MAX-PWM_MIN)/3) % PWM_MAX;
    pwmGreen = (i*10 + 2*(PWM_MAX-PWM_MIN)/3) % PWM_MAX;
    delay(2);
  }
  old = i;*/
  for(i=PWM_MAX;i>PWM_MIN;i--)
  {
    pwmGreen = i;
    delayMicroseconds(TEMP);
  }
  for(i=pwmGreen;i<PWM_MAX;i++)
  {
    pwmGreen = i;
    delayMicroseconds(TEMP);
  }
  for(i=PWM_MAX;i>PWM_MIN;i--)
  {
    pwmOrange = i;
    delayMicroseconds(TEMP);
  }
  for(i=pwmOrange;i<PWM_MAX;i++)
  {
    pwmOrange = i;
    delayMicroseconds(TEMP);
  }
  for(i=PWM_MAX;i>PWM_MIN;i--)
  {
    pwmRed = i;
    delayMicroseconds(TEMP);
  }
  for(i=pwmRed;i<PWM_MAX;i++)
  {
    pwmRed = i;
    delayMicroseconds(TEMP);
  }
  changeState();
}

void counter()
{
  timeChange = micros();
  state = 0;
}

void analogLight( long time, int port)
{
  if( time < PWM_MIN )
    time = PWM_MIN;
  if( time > PWM_MAX )
    time = PWM_MAX;
  if( (state & (1 << port))  == 0)
  {
    if( micros() - timeChange > time )
    {
      state |= (1 << port);
      impulse(port);
    }
  }
}

void impulse( int port)
{
  digitalWrite( port, HIGH);
  delayMicroseconds(50);
  digitalWrite( port, LOW);
}

void callAnalogLight()
{
  analogLight(pwmGreen, GREEN);
  analogLight(pwmRed,RED);
  analogLight(pwmOrange,ORANGE);
}

void changeState()
{
  if( stateDebug == LOW )
  {
    stateDebug = HIGH;
    digitalWrite(13,HIGH);
  }
  else
  {
    stateDebug = LOW;
    digitalWrite(13,LOW);
  }
}
