import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.spi.*; // for AudioRecordingStream
import ddf.minim.ugens.*;
import processing.serial.*;

 
Minim minim;
AudioOutput out;

AudioRecordingStream beatsFile;
AudioRecordingStream synbassFile;
AudioRecordingStream shakerFile;
AudioRecordingStream vinylFile;

FilePlayer beats;
FilePlayer synbass;
FilePlayer shaker;
FilePlayer vinyl;

Summer sum;

BitCrush myCrush;
Delay myDelay;
Flanger myFlange;
MoogFilter myMoog;

// AudioPlayer[] playersList;

// FFT fft;

// int volumeMode = 1;

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
  out = minim.getLineOut(Minim.MONO, 512);
  sum = new Summer();

  myDelay = new Delay();
  myCrush = new BitCrush(5.f, 44100.f);
  myFlange = new Flanger(
                        1000,     // delay length in milliseconds ( clamped to [0,100] )
                        0.2f,   // lfo rate in Hz ( clamped at low end to 0.001 )
                        1000,     // delay depth in milliseconds ( minimum of 0 )
                        0.5f,   // amount of feedback ( clamped to [0,1] )
                        0.5f,   // amount of dry signal ( clamped to [0,1] )
                        0.5f    // amount of wet signal ( clamped to [0,1] )
                        );
  myMoog = new MoogFilter(1200, 0.5);


  beatsFile = minim.loadFileStream("beats.mp3", 1024, true);
  synbassFile = minim.loadFileStream("SynBass.mp3",  1024, true);
  shakerFile = minim.loadFileStream("Shaker.mp3", 1024, true);
  vinylFile = minim.loadFileStream("Vinyl.mp3", 1024, true);

  beats = new FilePlayer(beatsFile);
  synbass = new FilePlayer(synbassFile);
  shaker = new FilePlayer(shakerFile);
  vinyl = new FilePlayer(vinylFile);

  beats.loop(1);
  synbass.loop(1);
  shaker.loop(1);
  vinyl.loop(1);

  sum.patch(beats);
  // beats.patch(out);
  synbass.patch(myMoog).patch(out);
  // shaker.patch(out);
  // vinyl.patch(myCrush).patch(out);

  // specify 512 for the length of the sample buffers
  // the default buffer size is 1024
  // beats = minim.loadFile("beats.mp3", 512);
  // synbass = minim.loadFile("SynBass.mp3", 512);
  // shaker = minim.loadFile("Shaker.mp3", 512);
  // vinyl = minim.loadFile("Vinyl.mp3", 512);

  // playersList = new AudioPlayer[4];
  // playersList[0] = beats;
  // playersList[1] = synbass;
  // playersList[2] = shaker;
  // playersList[3] = vinyl;



  // for(int i =0; i < playersList.length; i++) {
  //   playersList[i].setGain(-80);
  // }

  // gainLevels = new float[playersList.length];

  // an FFT needs to know how 
  // long the audio buffers it will be analyzing are
  // and also needs to know 
  // the sample rate of the audio it is analyzing
  // fft = new FFT(beats.bufferSize(), beats.sampleRate());
}
 
void draw() {
  background(0);
  // first perform a forward fft on one of song's buffers
  // I'm using the mix buffer
  //  but you can use any one you like
  // fft.forward(beats.mix);
 
  stroke(255, 0, 0, 128);
  // draw the spectrum as a series of vertical lines
  // I multiple the value of getBand by 4 
  // so that we can see the lines better
  // for(int i = 0; i < fft.specSize(); i++)
  // {
  //   line(i, height, i, height - fft.getBand(i)*4);
  // }
 
  stroke(255);
  // I draw the waveform by connecting 
  // neighbor values with a line. I multiply 
  // each of the values by 50 
  // because the values in the buffers are normalized
  // this means that they have values between -1 and 1. 
  // If we don't scale them up our waveform 
  // will look more or less like a straight line.
  // for(int i = 0; i < beats.left.size() - 1; i++)
  // {
  //   line(i, 50 + beats.left.get(i)*50, i+1, 50 + beats.left.get(i+1)*50);
  //   line(i, 150 + beats.right.get(i)*50, i+1, 150 + beats.right.get(i+1)*50);
  // }

  // setGainLevels();
}

// void setGainLevels(){
//   setGainStringValuesFromSerialRead();


//   for(int i = 0; i < stringValues.length; i++) {
//     float f = new Float(stringValues[i]);
//     float mappedLevel = map(f, 0, 900, -60, 8);
//     playersList[i].setGain(mappedLevel);
//   }
// }

// void setGainStringValuesFromSerialRead(){

//   if(myPort.available() > 0){
//     serialMsg = myPort.readStringUntil('\n');

//     if(serialMsg != null) {
//       println("Recvd = " + serialMsg);
//       stringValues = serialMsg.split(",");
//     }
//   }

// }

// void keyPressed() {
//   print(key);
//   println(" was pressed");

//   switch(key) {
//     case '0':
//       volumeMode = 0;
//       break;
//     case '1':
//       volumeMode = 1;
//       break;
//     case '2':
//       volumeMode = 2;
//       break;
//     case '3':
//       volumeMode = 3;
//       break;
      
//     case 'q':
//       // Volume Up
//       if(gain <= GAIN_MAX) {
//         gain += gain_step_size ;
//       } else {
//         gain = GAIN_MAX;
//       }
//       playersList[volumeMode].setGain(gain);
//       break;

//     case 'a':
//       // Volume Down
//       if (gain >= GAIN_MIN) {
//         gain -= gain_step_size;
//       } else {
//         gain = GAIN_MIN;
//       }
//       playersList[volumeMode].setGain(gain);
//       break;

//     case 'p':
//       snap.rewind();
//       snap.play();
//       break;
//     case 'r':
//       snap.rewind();
//       break;

//     default:
//       println("Unsupported keypress: " + key);
//   }

// }

void mouseMoved(){
  float freq = constrain( map( mouseX, 0, width, 200, 12000 ), 200, 12000 );
  float rez  = constrain( map( mouseY, height, 0, 0, 1 ), 0, 1 );
  
  myMoog.frequency.setLastValue( freq );
  myMoog.resonance.setLastValue( rez  );
}