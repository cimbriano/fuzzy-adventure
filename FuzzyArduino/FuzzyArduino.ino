// pressure_sensor.ino
int pressureInPin = 0;
int pressureReading;

int pressureInPin2 = 1;
int pressureReading2;

int touchMembraneInPin = 2;
int touchMembraneReading;

int touchMembraneInPin2 = 3;
int touchMembraneReading2;

int irInPin = 4;
int irReading;

void setup() {
    Serial.begin(9600);
}

void loop() {
    pressureReading = analogRead(pressureInPin);
    // Serial.print(pressureReading);
    Serial.print(650);
    Serial.print(',');

    pressureReading2 = analogRead(pressureInPin2);
    // Serial.print(pressureReading2);
    Serial.print(650);
    Serial.print(',');

    touchMembraneReading = analogRead(touchMembraneInPin);
    // Serial.print(touchMembraneReading);
    Serial.print(650);
    Serial.print(',');

    touchMembraneReading2 = analogRead(touchMembraneInPin2);
    // Serial.print(touchMembraneReading2);
    Serial.print(650);
    Serial.print(',');

    irReading = analogRead(irInPin);
    Serial.print(irReading);
    Serial.print('\n');

    delay(300);
}
