package com.hurlant.crypto.symmetric
{
   import flash.utils.ByteArray;
   
   public interface ICipher
   {
       
      
      function encrypt(param1:ByteArray) : void;
      
      function dispose() : void;
      
      function getBlockSize() : uint;
      
      function toString() : String;
      
      function decrypt(param1:ByteArray) : void;
   }
}
