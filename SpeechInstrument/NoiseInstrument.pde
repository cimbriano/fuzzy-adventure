// Every instrument must implement the Instrument interface so 
// playNote() can call the instrument's methods.

// This noise instrument uses white noise and two bandpass filters
// to make a "whistling wind" sound.  By changing using the methods which
// change the frequency and the bandwidth of the filters, the sound changes.

import ddf.minim.spi.*; // for AudioRecordingStream

class DelayInstrument implements Instrument
{
  // create all variables that must be used throughout the class
  
  Delay myDelay;

  Multiplier multiply;
  AudioOutput out;
  Summer sum; 

  FilePlayer speech;
  
  // constructors for this intsrument
  DelayInstrument( float amplitude, AudioOutput output )
  {
    // equate class variables to constructor variables as necessary 
    out = output;

    AudioRecordingStream myFile = minim.loadFileStream("speech.mp3", 1024, true);
    speech = new FilePlayer( myFile );
    speech.loop(1);
    
    // create new instances of any UGen objects
    myDelay = new Delay();
    multiply = new Multiplier( 0 );
    // filt1 = new BandPass( freq1, bandWidth1, out.sampleRate() );
    // filt2 = new BandPass( freq2(), bandWidth2(), out.sampleRate() );
    sum = new Summer();

    // patch everything (including the out this time)
    speech.patch( myDelay ).patch( sum );
    sum.patch( multiply );
  }
  
  // every instrument must have a noteOn( float ) method
  void noteOn( float dur )
  {
    // set the multiply to 1 to turn on the note
    multiply.setValue( 1 );
    multiply.patch( out );
  }
  
  // every instrument must have a noteOff() method
  void noteOff()
  {
    // set the multiply to 0 to turn off the note 
    multiply.setValue( 0 );
    multiply.unpatch( out );
  }

  void setDelTime(float delayTime){
    myDelay.setDelTime(delayTime);
  }

  void setDelAmp(float feedBackFactor){
    myDelay.setDelTime(feedBackFactor);
  }
}
