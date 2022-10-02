package com.hurlant.crypto.prng
{
   import flash.utils.ByteArray;
   
   public interface IPRNG
   {
       
      
      function init(param1:ByteArray) : void;
      
      function next() : uint;
      
      function dispose() : void;
      
      function getPoolSize() : uint;
      
      function toString() : String;
   }
}
