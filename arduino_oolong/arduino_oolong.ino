#include <SPI.h>
#include <Ethernet.h>
#include <Time.h>

//Mac Address Static
byte mac[] = {0x90,0xA2,0xDA,0x0F,0x8B,0xA2};
//byte server[] = { 192, 168, 11, 2 };
char server[] = "www.google.com";

EthernetClient client;


void setup()
{
  // Open serial communications and wait for port to open:
  Serial.begin(9600);

  // start the Ethernet connection:
  if (Ethernet.begin(mac) == 0) {
    Serial.println("Failed to configure Ethernet using DHCP");
    // no point in carrying on, so do nothing forevermore:
    for(;;)
      ;
      
  }
  // print your local IP address:
  Serial.print("My IP address: ");
  for (byte thisByte = 0; thisByte < 4; thisByte++) {
    // print the value of each byte of the IP address:
    Serial.print(Ethernet.localIP()[thisByte], DEC);
    Serial.print("."); 
  }
  Serial.println();
  
  delay(1000);
  
  // Connetc Server
  if(client.connect(server, 80)){
    Serial.println("server connectd."); 
  }else{
    Serial.println("server disconnectd."); 
  }
  
}

void loop()
{
  if(client.available()){
    
    client.println("GET /hb/10?h=12.3&t=21.4 HTTP/1.1") ;
    Serial.println("success");
  
  }else{
    Serial.println("false");
  }
  
  delay(5000);
}
