/* realtimeControlExample<br/>
   is an example of doing realtime control with an instrument
   <p>
   For more information about Minim and additional features, visit http://code.compartmental.net/minim/
   <p>   
   author: Anderson Mills<br/>
   Anderson Mills's work was supported by numediart (www.numediart.org)
*/

// import everything necessary to make sound.
import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

// create all of the variables that will need to be accessed in
// more than one methods (setup(), draw(), stop()).
Minim minim;
AudioOutput out;
DelayInstrument myDelay;

// setup is run once at the beginning
void setup()
{
  // initialize the drawing window
  size( 500, 500, P2D );

  // initialize the minim and out objects
  minim = new Minim( this );
  out = minim.getLineOut( Minim.MONO, 512 );
  // need to initialize the myNoise object   
  myDelay = new DelayInstrument( 1.0, out );
  
  // play the note for 100.0 seconds
  out.playNote( 0, 5.0, myDelay );
}

// draw is run many times
void draw()
{
  // erase the window to black
  background( 0 );
  // draw using a white stroke
  stroke( 255 );
  // draw the waveforms
  for( int i = 0; i < out.bufferSize() - 1; i++ )
  {
    // find the x position of each buffer value
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0, out.bufferSize(), 0, width );
    // draw a line from one buffer position to the next for both channels
    line( x1, 50 + out.left.get(i)*50, x2, 50 + out.left.get(i+1)*50);
    line( x1, 150 + out.right.get(i)*50, x2, 150 + out.right.get(i+1)*50);
  }  
}

// this is run whenever the mouse is moved
void mouseMoved()
{

   // set the delay time by the horizontal location
  float delayTime = map( mouseX, 0, width, 0.0001, 0.5 );
  float feedbackFactor = map( mouseY, 0, height, 0.99, 0.0 );
  
  myDelay.setDelTime( delayTime );
  myDelay.setDelAmp( feedbackFactor );
}
