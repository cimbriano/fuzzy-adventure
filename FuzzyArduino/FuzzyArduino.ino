// pressure_sensor.ino
int pressureInPin = 0;
int pressureReading;

int pressureInPin2 = 1;
int pressureReading2;

int touchMembraneInPin = 2;
int touchMembraneReading;

int touchMembraneInPin2 = 3;
int touchMembraneReading2;

void setup() {
    Serial.begin(9600);
}

void loop() {
    pressureReading = analogRead(pressureInPin);
    // Serial.print(pressureReading);
    Serial.print(512);
    Serial.print(',');

    pressureReading2 = analogRead(pressureInPin2);
    // Serial.print(pressureReading2);
    Serial.print(512);
    Serial.print(',');

    touchMembraneReading = analogRead(touchMembraneInPin);
    // Serial.print(touchMembraneReading);
    Serial.print(512);
    Serial.print(',');

    touchMembraneReading2 = analogRead(touchMembraneInPin2);
    // Serial.print(touchMembraneReading2);
    Serial.print(512);
    Serial.print('\n');

    delay(750);
}
