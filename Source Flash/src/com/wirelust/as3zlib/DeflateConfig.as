package com.wirelust.as3zlib
{
   public class DeflateConfig
   {
       
      
      public var good_length:int;
      
      public var max_lazy:int;
      
      public var nice_length:int;
      
      public var max_chain:int;
      
      public var func:int;
      
      public function DeflateConfig(param1:int, param2:int, param3:int, param4:int, param5:int)
      {
         super();
         this.good_length = param1;
         this.max_lazy = param2;
         this.nice_length = param3;
         this.max_chain = param4;
         this.func = param5;
      }
   }
}
