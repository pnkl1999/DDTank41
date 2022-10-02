package com.hurlant.util
{
   import flash.utils.ByteArray;
   
   public class Hex
   {
       
      
      public function Hex()
      {
         super();
      }
      
      public static function fromString(str:String, colons:Boolean = false) : String
      {
         var a:ByteArray = null;
         a = new ByteArray();
         a.writeUTFBytes(str);
         return fromArray(a,colons);
      }
      
      public static function toString(hex:String) : String
      {
         var a:ByteArray = null;
         a = toArray(hex);
         return a.readUTFBytes(a.length);
      }
      
      public static function toArray(hex:String) : ByteArray
      {
         var a:ByteArray = null;
         var i:uint = 0;
         hex = hex.replace(/\s|:/gm,"");
         a = new ByteArray();
         if(hex.length & 1 == 1)
         {
            hex = "0" + hex;
         }
         for(i = 0; i < hex.length; i += 2)
         {
            a[i / 2] = parseInt(hex.substr(i,2),16);
         }
         return a;
      }
      
      public static function fromArray(array:ByteArray, colons:Boolean = false) : String
      {
         var s:String = null;
         var i:uint = 0;
         s = "";
         for(i = 0; i < array.length; i++)
         {
            s += ("0" + array[i].toString(16)).substr(-2,2);
            if(colons)
            {
               if(i < array.length - 1)
               {
                  s += ":";
               }
            }
         }
         return s;
      }
   }
}
