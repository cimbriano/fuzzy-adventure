// pressure_sensor.ino
int irIn = 0;
int irReading;


void setup() {
    Serial.begin(9600);
}

void loop() {
    irReading = analogRead(irIn);
    Serial.print(irReading);
    Serial.print('\n');

    delay(750);
}
