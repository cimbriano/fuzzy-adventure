// pressure_sensor.ino
int pressureInPin = 0;
int pressureReading;

int touchMembraneInPin = 5;
int touchMembraneReading;

void setup() {
    Serial.begin(9600);
}

void loop() {
    pressureReading = analogRead(pressureInPin);
    Serial.print("Pressure reading = ");
    Serial.println(pressureReading);

    touchMembraneReading = analogRead(touchMembraneInPin);
    Serial.print("Touch Reading = ");
    Serial.println(touchMembraneReading);

    delay(750);
}
