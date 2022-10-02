package com.pickgliss.loader
{
   import flash.net.URLVariables;
   
   public class RequestLoader extends TextLoader
   {
       
      
      public function RequestLoader(param1:int, param2:String, param3:URLVariables = null, param4:String = "GET")
      {
         super(param1,param2,param3,param4);
      }
      
      override public function get type() : int
      {
         return BaseLoader.REQUEST_LOADER;
      }
   }
}
