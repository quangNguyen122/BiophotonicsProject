void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  delay(50);
}

void loop() {
  // put your main code here, to run repeatedly:
  int sensorValue = analogRead(A0);               // read the input on analog pin 0:
  float voltage = sensorValue * (5.0 / 1023.0);   // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  Serial.println(voltage);                        // print out the value you read:
  
  delay(1);
}
