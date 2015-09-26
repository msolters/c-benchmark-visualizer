/*  benchmark.h - Companion Firmware
*   Mark Solters // Driblet Labs
*
*
*/
#include "application.h"  // comment this out if compiling in the cloud

void setup() {
    Serial.begin( 9600 );
    Serial1.begin( 115200 );
}

int t0 = 0;
uint8_t startChar = 0x02;
uint8_t endChar = 0x03;
bool rcvg = false;
String msg = "";
uint8_t msgIdx = 0;

void loop() {
    while ( Serial1.available() ) {
        byte inByte = Serial1.read();

        if ( inByte == startChar ) {
            rcvg = true;
            msg = "";
        } else if ( inByte == endChar ) {
            if (msg == "init") {
                Serial.println("init");
                msgIdx = 0;
            } else {
                Serial.print(msg);
                Serial.print("\t");
                Serial.print( (millis()-t0) );
                Serial.print("\t");
                Serial.println(msgIdx++);
                t0 = millis();
            }
            rcvg = false;
        } else {
            if ( rcvg == true ) {
                msg += char(inByte);
            }
        }
    }
}
