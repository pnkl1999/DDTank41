package com.pickgliss.loader
{
   import flash.events.Event;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLVariables;
   
   public class TextLoader extends BaseLoader
   {
      
      public static var TextLoaderKey:String;
       
      
      public function TextLoader(param1:int, param2:String, param3:URLVariables = null, param4:String = "GET")
      {
         super(param1,param2,param3,param4);
      }
      
      override public function get content() : *
      {
         return _loader.data;
      }
      
      override protected function __onDataLoadComplete(param1:Event) : void
      {
         removeEvent();
         _loader.close();
         if(analyzer)
         {
            analyzer.analyzeCompleteCall = fireCompleteEvent;
            analyzer.analyzeErrorCall = fireErrorEvent;
            analyzer.analyze(_loader.data);
         }
         else
         {
            fireCompleteEvent();
         }
      }
      
      override protected function getLoadDataFormat() : String
      {
         return URLLoaderDataFormat.TEXT;
      }
      
      override public function get type() : int
      {
         return BaseLoader.TEXT_LOADER;
      }
   }
}
