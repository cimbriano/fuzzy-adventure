import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.spi.*; // for AudioRecordingStream
import ddf.minim.ugens.*;
import processing.serial.*;
 
Minim minim;
AudioOutput out;

Gain beatsGain;
Gain synbassGain;
Gain shakerGain;
Gain vinylGain;

FilePlayer beats;
FilePlayer synbass;
FilePlayer shaker;
FilePlayer vinyl;

Summer sum;

BitCrush beatsCrush;
BitCrush synbassCrush;
BitCrush vinylCrush;

// FFT fft;
// AudioPlayer beatsForFFT;


float gain = 0.5;
float GAIN_MAX = 10.f;
float GAIN_MIN = -80.f;
float SHAKER_GAIN = -10.f;
float gain_step_size = 1;

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

  beatsCrush = new BitCrush(16.f, 44100.f);
  synbassCrush = new BitCrush(16.f, 44100.f);
  vinylCrush = new BitCrush(16.f, 44100.f);

  AudioRecordingStream beatsFile = minim.loadFileStream("beats.mp3", 1024, true);
  AudioRecordingStream synbassFile = minim.loadFileStream("SynBass.mp3",  1024, true);
  AudioRecordingStream shakerFile = minim.loadFileStream("Shaker.mp3", 1024, true);
  AudioRecordingStream vinylFile = minim.loadFileStream("Vinyl.mp3", 1024, true);

  beats = new FilePlayer(beatsFile);
  synbass = new FilePlayer(synbassFile);
  shaker = new FilePlayer(shakerFile);
  vinyl = new FilePlayer(vinylFile);

  shakerGain = new Gain(GAIN_MIN);
  shakerGain.setValue(SHAKER_GAIN);

  beatsGain = new Gain(GAIN_MIN);
  synbassGain = new Gain(GAIN_MIN);
  vinylGain = new Gain(GAIN_MIN);

  beats.loop(1);
  synbass.loop(1);
  shaker.loop(1);
  vinyl.loop(1);

  shaker.patch(shakerGain).patch(out);

  beats.patch(beatsGain).patch(beatsCrush).patch(out);
  synbass.patch(synbassGain).patch(synbassCrush).patch(out);  
  vinyl.patch(vinylGain).patch(vinylCrush).patch(out);


  // an FFT needs to know how 
  // long the audio buffers it will be analyzing are
  // and also needs to know 
  // the sample rate of the audio it is analyzing
  // beatsForFFT = minim.loadFile("beats.mp3", 512);
  // fft = new FFT(beatsForFFT.bufferSize(), beatsForFFT.sampleRate());
}
 
void draw() {
  background(0);
  // first perform a forward fft on one of song's buffers
  // I'm using the mix buffer
  //  but you can use any one you like
  // fft.forward(beatsForFFT.mix);
 
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
  // for(int i = 0; i < beatsForFFT.left.size() - 1; i++)
  // {
  //   line(i, 50 + beatsForFFT.left.get(i)*50, i+1, 50 + beatsForFFT.left.get(i+1)*50);
  //   line(i, 150 + beatsForFFT.right.get(i)*50, i+1, 150 + beatsForFFT.right.get(i+1)*50);
  // }

  getParameterLevelsFromSerialRead();
}

void getParameterLevelsFromSerialRead(){

  if(myPort.available() > 0){
    serialMsg = myPort.readStringUntil('\n');

    if(serialMsg != null) {
      println("Recvd = " + serialMsg);
      stringValues = serialMsg.trim().split(",");

      // Bail if there are not 5 elements in this array
      if(stringValues.length != 7) return;
      

      if(stringValues[6].equals("1")) {

        shakerGain.setValue(SHAKER_GAIN);

        beatsGain.setValue(mapGainLevelFromString(stringValues[0]));
        beatsCrush.setBitRes(mapCrushLevelFromString(stringValues[4]));

        synbassGain.setValue(mapGainLevelFromString(stringValues[1]));
        synbassCrush.setBitRes(mapCrushLevelFromString(stringValues[5]));

        vinylGain.setValue(mapGainLevelFromString(stringValues[3]));
        vinylCrush.setBitRes(mapCrushLevelFromString(stringValues[2]));
        

      } else {

        beatsGain.setValue(GAIN_MIN);
        synbassGain.setValue(GAIN_MIN);
        shakerGain.setValue(GAIN_MIN);
        vinylGain.setValue(GAIN_MIN);

      }

      

    }
  }
}

float mapCrushLevelFromString(String val) {
  float f = new Float(val);
  return map(f, 30, 1010, 16, 5);
}

float mapGainLevelFromString(String val){
  float f = new Float(val);
  return map(f, 0, 900, GAIN_MIN, GAIN_MAX);
}

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
