package com.pickgliss.loader
{
   import flash.net.URLVariables;
   
   public class CompressRequestLoader extends CompressTextLoader
   {
       
      
      public function CompressRequestLoader(param1:int, param2:String, param3:URLVariables = null, param4:String = "GET")
      {
         super(param1,param2,param3,param4);
      }
      
      override public function get type() : int
      {
         return BaseLoader.COMPRESS_REQUEST_LOADER;
      }
   }
}
