// pressure_sensor.ino
int pressureInPin = 0;
int pressureReading;

int pressureInPin2 = 2;
int pressureReading2;

int touchMembraneInPin = 5;
int touchMembraneReading;

void setup() {
    Serial.begin(9600);
}

void loop() {
    pressureReading = analogRead(pressureInPin);
    // Serial.print("P1 = ");
    Serial.print(pressureReading);
    Serial.print(',');

    pressureReading2 = analogRead(pressureInPin2);
    // Serial.print("\tP2 = ");
    Serial.print(pressureReading2);
    Serial.print(',');

    touchMembraneReading = analogRead(touchMembraneInPin);
    // Serial.print("\tT1 = ");
    Serial.print(touchMembraneReading);
    Serial.print(',');

    // 4th sensor not set up yet
    Serial.print(850);
    Serial.print('\n');

    delay(750);
}
