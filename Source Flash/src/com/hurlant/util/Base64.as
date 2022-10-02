package com.hurlant.util
{
   import flash.utils.ByteArray;
   
   public class Base64
   {
      
      public static const version:String = "1.0.0";
      
      private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
       
      
      public function Base64()
      {
         super();
         throw new Error("Base64 class is static container only");
      }
      
      public static function encode(data:String) : String
      {
         var bytes:ByteArray = null;
         bytes = new ByteArray();
         bytes.writeUTFBytes(data);
         return encodeByteArray(bytes);
      }
      
      public static function encodeByteArray(data:ByteArray) : String
      {
         var output:String = null;
         var dataBuffer:Array = null;
         var outputBuffer:Array = null;
         var i:uint = 0;
         var j:uint = 0;
         var k:uint = 0;
         output = "";
         outputBuffer = new Array(4);
         data.position = 0;
         while(data.bytesAvailable > 0)
         {
            dataBuffer = new Array();
            i = 0;
            while(i < 3 && data.bytesAvailable > 0)
            {
               dataBuffer[i] = data.readUnsignedByte();
               i++;
            }
            outputBuffer[0] = (dataBuffer[0] & 252) >> 2;
            outputBuffer[1] = (dataBuffer[0] & 3) << 4 | dataBuffer[1] >> 4;
            outputBuffer[2] = (dataBuffer[1] & 15) << 2 | dataBuffer[2] >> 6;
            outputBuffer[3] = dataBuffer[2] & 63;
            for(j = dataBuffer.length; j < 3; j++)
            {
               outputBuffer[j + 1] = 64;
            }
            for(k = 0; k < outputBuffer.length; k++)
            {
               output += BASE64_CHARS.charAt(outputBuffer[k]);
            }
         }
         return output;
      }
      
      public static function decode(data:String) : String
      {
         var bytes:ByteArray = null;
         bytes = decodeToByteArray(data);
         return bytes.readUTFBytes(bytes.length);
      }
      
      public static function decodeToByteArray(data:String) : ByteArray
      {
         var output:ByteArray = null;
         var dataBuffer:Array = null;
         var outputBuffer:Array = null;
         var i:uint = 0;
         var j:uint = 0;
         var k:uint = 0;
         output = new ByteArray();
         dataBuffer = new Array(4);
         outputBuffer = new Array(3);
         for(i = 0; i < data.length; i += 4)
         {
            j = 0;
            while(j < 4 && i + j < data.length)
            {
               dataBuffer[j] = BASE64_CHARS.indexOf(data.charAt(i + j));
               j++;
            }
            outputBuffer[0] = (dataBuffer[0] << 2) + ((dataBuffer[1] & 48) >> 4);
            outputBuffer[1] = ((dataBuffer[1] & 15) << 4) + ((dataBuffer[2] & 60) >> 2);
            outputBuffer[2] = ((dataBuffer[2] & 3) << 6) + dataBuffer[3];
            for(k = 0; k < outputBuffer.length; k++)
            {
               if(dataBuffer[k + 1] == 64)
               {
                  break;
               }
               output.writeByte(outputBuffer[k]);
            }
         }
         output.position = 0;
         return output;
      }
   }
}
