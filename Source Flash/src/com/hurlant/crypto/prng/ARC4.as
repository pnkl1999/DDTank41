package com.hurlant.crypto.prng
{
   import com.hurlant.crypto.symmetric.IStreamCipher;
   import com.hurlant.util.Memory;
   import flash.utils.ByteArray;
   
   public class ARC4 implements IPRNG, IStreamCipher
   {
       
      
      private var S:ByteArray;
      
      private var i:int = 0;
      
      private var j:int = 0;
      
      private const psize:uint = 256;
      
      public function ARC4(key:ByteArray = null)
      {
         this.i = 0;
         this.j = 0;
         super();
         this.S = new ByteArray();
         if(key)
         {
            this.init(key);
         }
      }
      
      public function decrypt(block:ByteArray) : void
      {
         this.encrypt(block);
      }
      
      public function init(key:ByteArray) : void
      {
         var i:int = 0;
         var j:int = 0;
         var t:int = 0;
         for(i = 0; i < 256; i++)
         {
            this.S[i] = i;
         }
         j = 0;
         for(i = 0; i < 256; i++)
         {
            j = j + this.S[i] + key[i % key.length] & 255;
            t = this.S[i];
            this.S[i] = this.S[j];
            this.S[j] = t;
         }
         this.i = 0;
         this.j = 0;
      }
      
      public function dispose() : void
      {
         var i:uint = 0;
         i = 0;
         if(this.S != null)
         {
            for(i = 0; i < this.S.length; i++)
            {
               this.S[i] = Math.random() * 256;
            }
            this.S.length = 0;
            this.S = null;
         }
         this.i = 0;
         this.j = 0;
         Memory.gc();
      }
      
      public function encrypt(block:ByteArray) : void
      {
         var i:uint = 0;
         i = 0;
         while(i < block.length)
         {
            var _loc3_:* = i++;
            block[_loc3_] = block[i++] ^ this.next();
         }
      }
      
      public function next() : uint
      {
         var t:int = 0;
         this.i = this.i + 1 & 255;
         this.j = this.j + this.S[this.i] & 255;
         t = this.S[this.i];
         this.S[this.i] = this.S[this.j];
         this.S[this.j] = t;
         return this.S[t + this.S[this.i] & 255];
      }
      
      public function getBlockSize() : uint
      {
         return 1;
      }
      
      public function getPoolSize() : uint
      {
         return this.psize;
      }
      
      public function toString() : String
      {
         return "rc4";
      }
   }
}
