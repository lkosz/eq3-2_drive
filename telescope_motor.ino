#include <SPI.h>
#include <AMIS30543.h>
#include "TM1637.h"

#define CLK 7
#define DIO 6
TM1637 tm1637(CLK,DIO);

const uint8_t amisDirPin = 2;
const uint8_t amisStepPin = 3;
const uint8_t amisSlaveSelect = 5;

AMIS30543 stepper;

/*  x = (number of steps)/(number of seconds per solar day) = (mount_ra_gear_turns * stepper_motor_steps * driver_steps_resolution)/(24*60*60)
 *  microseconds_between_steps = (int) (1/x * 10^6);
 *  picoseconds_rest = (x - (int)(x)) * 10^6
 *
 *  eg. for my mount have 1:130 gear, motor 400 steps, driver resolution 128 steps
 *  then x = 2080/27
 *  microseconds_between_steps = 12980
 *  picosecodns_rest = 769230.769230769
 */

unsigned long microseconds_between_steps = 12980;
double picoseconds_rest = 769230.769230769;
int driver_resolution = 128;
int max_miliamps = 1680;
//-----------------------------------------

bool motor_state = LOW;
bool volt_blink_state = false;
double aku_volt = 0.0;
double picoseconds_correction = 0.0;
int aku_perc = 0;
unsigned long next_butt_time = 0;
unsigned long next_disp_time = 0;
unsigned long next_step_time = 0;

//-----------------------------------------
void setup() {
  delay(3000);

  tm1637.init();
  tm1637.set(0);

  SPI.begin();
  stepper.init(amisSlaveSelect);

  digitalWrite(amisStepPin, LOW);
  pinMode(amisStepPin, OUTPUT);
  digitalWrite(amisDirPin, LOW);
  pinMode(amisDirPin, OUTPUT);
  delay(10);
  stepper.resetSettings();
  stepper.setCurrentMilliamps(max_miliamps);
  stepper.setStepMode(driver_resolution);
}

void loop() { while (1) {

  if ((unsigned long)(micros()) >= (unsigned long)(next_step_time)){
    step();
    next_step_time = next_step_time + microseconds_between_steps;
    picoseconds_correction = picoseconds_correction + picoseconds_rest;
    if (picoseconds_correction > (double)(1000000)){
      next_step_time = next_step_time + (unsigned long)(1);
      picoseconds_correction = picoseconds_correction - (double)(1000000);
    }
  }

  if (next_disp_time <= millis()){
    voltage_read();
    calc_battery_perc();
    print_voltage();
    next_disp_time = millis() + 3000;
    continue;
  }

  if (next_butt_time <= millis()){
    button_read();
    set_direction();
    next_butt_time = millis() + 50;
    continue;
  }

  delayMicroseconds((unsigned long)(microseconds_between_steps/50));

}}

void setup_motor(bool enable_motor){

  if (motor_state == LOW && enable_motor == HIGH){
    stepper.enableDriver();
    motor_state = HIGH;
    next_step_time = micros();
  }
  else if (motor_state == HIGH && enable_motor == LOW){
    motor_state = LOW;
    stepper.disableDriver();
    next_step_time = micros();
  }

}

void print_real_multiplier(int real_multiplier){
  if ( real_multiplier >= 1000 ){
    int n4 = real_multiplier%10;
    int n3 = ((real_multiplier - n4)/10)%10;
    int n2 = ((real_multiplier - n4 - n3)/100)%10;
    int n1 = ((real_multiplier - n4 - n3 - n2)/1000)%10;

    tm1637.display(0,n1);
    tm1637.display(1,n2);
    tm1637.display(2,n3);
    tm1637.display(3,n4);
  }
  else if ( real_multiplier >= 100 ){
    int n3 = real_multiplier%10;
    int n2 = ((real_multiplier - n3)/10)%10;
    int n1 = ((real_multiplier - n3 - n2)/100)%10;

    tm1637.display(0,n1);
    tm1637.display(1,n2);
    tm1637.display(2,n3);
    tm1637.display(3,16);
  }
  else if ( real_multiplier >= 10 ){
    int n2 = real_multiplier%10;
    int n1 = ((real_multiplier - n2)/10)%10;

    tm1637.display(0,n1);
    tm1637.display(1,n2);
    tm1637.display(2,16);
    tm1637.display(3,16);
  }
  else{
    int n1 = real_multiplier%10;

    tm1637.display(0,n1);
    tm1637.display(1,16);
    tm1637.display(2,16);
    tm1637.display(3,16);
  }
}

void motor_change_speed(int multiplier, bool motor_dir, int b_pin, int resolution){

  int real_multiplier = (int)(multiplier)*((int)(driver_resolution)/(int)(resolution));
  print_real_multiplier(real_multiplier);

  setup_motor(LOW);
  digitalWrite(amisDirPin, motor_dir);
  setup_motor(HIGH);

  unsigned long step_delay = (unsigned long)((unsigned long)microseconds_between_steps / (unsigned long)(multiplier)) - (unsigned long)(20);
  int state = 0;
  stepper.setStepMode(resolution);

  while (1){
    state = analogRead(b_pin);
    if ((state < 700) && (state > 50)){
      break;
    }
    step();
    delayMicroseconds(step_delay);
  }

  stepper.setStepMode(driver_resolution);
  print_voltage();
  next_step_time = micros();
  delay(20);
}

void set_direction(){
  int state = analogRead(A8);

  if (state > 990){
    setDirection(LOW);
    setup_motor(HIGH);
  }
  else if (state < 60){
    setDirection(HIGH);
    setup_motor(HIGH);
  }
  else{
    setup_motor(LOW);
  }
}

void button_read(){
  int state = 0;

  state = analogRead(A3);
  if (state > 990){ motor_change_speed(2, HIGH, A3, 128);}
  else if (state < 60){motor_change_speed(2, LOW, A3, 128);}

//---------------------------------

  state = analogRead(A10);
  if (state > 900){ motor_change_speed(8, HIGH, A10, 128);}
  else if (state < 60){motor_change_speed(8, LOW, A10, 128);}

//---------------------------------

  state = analogRead(A9);
  if (state > 900){ motor_change_speed(32, HIGH, A9, 128);}
  else if (state < 60){motor_change_speed(32, LOW, A9, 128);}

//---------------------------------

  state = analogRead(A0);
  if (state > 900){ motor_change_speed(96, HIGH, A0, 128);}
  else if (state < 60){motor_change_speed(96, LOW, A0, 128);}

//---------------------------------

  state = analogRead(A1);
  if (state > 900){ motor_change_speed(256, HIGH, A1, 64);}
  else if (state < 60){motor_change_speed(256, LOW, A1, 64);}

//---------------------------------

  state = analogRead(A2);
  if (state > 900){ motor_change_speed(512, HIGH, A2, 32);}
  else if (state < 60){motor_change_speed(512, LOW, A2, 32);}
}

void voltage_read(){
  aku_volt = (double)(analogRead(A6)) * 5.075/512 ;
}

void calc_battery_perc(){
  aku_perc = (int)((100.0 * aku_volt) - 550.0);
}

void print_voltage(){
  tm1637.display(0,1);
  tm1637.display(1,16);

  if (aku_perc > 99){
    tm1637.display(2,9);
    tm1637.display(3,9);
  }
  else if (aku_perc <= 99 && aku_perc >= 10){
    int sec_num = aku_perc%10;
    int first_num = (aku_perc - sec_num)/10;
    tm1637.display(2,first_num);
    tm1637.display(3,sec_num);
  }
  else{
    tm1637.display(2,16);
    volt_blink_state = not volt_blink_state;
    if (volt_blink_state){
      tm1637.display(3,aku_perc);
    }
    else{
      tm1637.display(3,16);
    }
  }

}

void step(){
  digitalWrite(amisStepPin, HIGH);
  delayMicroseconds(4);
  digitalWrite(amisStepPin, LOW);
  delayMicroseconds(4);
}

void setDirection(bool dir){
  delayMicroseconds(1);
  digitalWrite(amisDirPin, dir);
  delayMicroseconds(1);
}
