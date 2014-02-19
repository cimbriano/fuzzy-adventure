import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.serial.*;

 
Minim minim;
AudioPlayer beats;
AudioPlayer synbass;
AudioPlayer shaker;
AudioPlayer vinyl;

AudioPlayer[] playersList;

FFT fft;

int volumeMode = 1;

float gain = 0.5;
float GAIN_MAX = 6;
float GAIN_MIN = -80;
float gain_step_size = 1;
float[] gainLevels;

// Serial reading
String serialMsg = "";
String[] stringValues;
Serial myPort;
 
void setup() {
  size(512, 200);
 
  println(Serial.list());

  myPort = new Serial(this, "/dev/cu.usbmodemfa131", 9600);

  // Read first line incase its a partial message
  myPort.readStringUntil('\n');

  // always start Minim first!
  minim = new Minim(this);
 
  // specify 512 for the length of the sample buffers
  // the default buffer size is 1024
  beats = minim.loadFile("beats.mp3", 512);
  synbass = minim.loadFile("SynBass.mp3", 512);
  shaker = minim.loadFile("Shaker.mp3", 512);
  vinyl = minim.loadFile("Vinyl.mp3", 512);

  playersList = new AudioPlayer[4];
  playersList[0] = beats;
  playersList[1] = synbass;
  playersList[2] = shaker;
  playersList[3] = vinyl;


  beats.loop();
  synbass.loop();
  shaker.loop();
  vinyl.loop();

  gainLevels = new float[playersList.length];

  // an FFT needs to know how 
  // long the audio buffers it will be analyzing are
  // and also needs to know 
  // the sample rate of the audio it is analyzing
  fft = new FFT(beats.bufferSize(), beats.sampleRate());
}
 
void draw() {
  background(0);
  // first perform a forward fft on one of song's buffers
  // I'm using the mix buffer
  //  but you can use any one you like
  fft.forward(beats.mix);
 
  stroke(255, 0, 0, 128);
  // draw the spectrum as a series of vertical lines
  // I multiple the value of getBand by 4 
  // so that we can see the lines better
  for(int i = 0; i < fft.specSize(); i++)
  {
    line(i, height, i, height - fft.getBand(i)*4);
  }
 
  stroke(255);
  // I draw the waveform by connecting 
  // neighbor values with a line. I multiply 
  // each of the values by 50 
  // because the values in the buffers are normalized
  // this means that they have values between -1 and 1. 
  // If we don't scale them up our waveform 
  // will look more or less like a straight line.
  for(int i = 0; i < beats.left.size() - 1; i++)
  {
    line(i, 50 + beats.left.get(i)*50, i+1, 50 + beats.left.get(i+1)*50);
    line(i, 150 + beats.right.get(i)*50, i+1, 150 + beats.right.get(i+1)*50);
  }

  setGainLevels();
}

void setGainLevels(){
  setGainStringValuesFromSerialRead();


  for(int i = 0; i < stringValues.length; i++) {
    float f = new Float(stringValues[i]);
    float mappedLevel = map(f, 0, 1024, -30, 4);
    playersList[i].setGain(mappedLevel);
  }
}

void setGainStringValuesFromSerialRead(){

  if(myPort.available() > 0){
    serialMsg = myPort.readStringUntil('\n');

    if(serialMsg != null) {
      println("Recvd = " + serialMsg);
      stringValues = serialMsg.split(",");
    }
  }

}

void keyPressed() {
  print(key);
  println(" was pressed");

  switch(key) {
    case '0':
      volumeMode = 0;
      break;
    case '1':
      volumeMode = 1;
      break;
    case '2':
      volumeMode = 2;
      break;
    case '3':
      volumeMode = 3;
      break;
      
    case 'q':
      // Volume Up
      if(gain <= GAIN_MAX) {
        gain += gain_step_size ;
      } else {
        gain = GAIN_MAX;
      }
      playersList[volumeMode].setGain(gain);
      break;

    case 'a':
      // Volume Down
      if (gain >= GAIN_MIN) {
        gain -= gain_step_size;
      } else {
        gain = GAIN_MIN;
      }
      playersList[volumeMode].setGain(gain);
      break;
    default:
      println("Unsupported keypress: " + key);
  }

}