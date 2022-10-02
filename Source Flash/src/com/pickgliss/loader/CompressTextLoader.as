package com.pickgliss.loader
{
   import flash.events.Event;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   
   public class CompressTextLoader extends BaseLoader
   {
       
      
      private var _deComressedText:String;
      
      public function CompressTextLoader(param1:int, param2:String, param3:URLVariables = null, param4:String = "GET")
      {
         if(param3 == null)
         {
            param3 = new URLVariables();
         }
         if(param3["rnd"] == null)
         {
            param3["rnd"] = TextLoader.TextLoaderKey;
         }
         super(param1,param2,param3,param4);
      }
      
      override protected function __onDataLoadComplete(param1:Event) : void
      {
         removeEvent();
         _loader.close();
         var _loc2_:ByteArray = _loader.data;
         _loc2_.uncompress();
         _loc2_.position = 0;
         this._deComressedText = _loc2_.readUTFBytes(_loc2_.bytesAvailable);
         if(analyzer)
         {
            analyzer.analyzeCompleteCall = fireCompleteEvent;
            analyzer.analyzeErrorCall = fireErrorEvent;
            analyzer.analyze(this._deComressedText);
         }
         else
         {
            fireCompleteEvent();
         }
      }
      
      override public function get content() : *
      {
         return this._deComressedText;
      }
      
      override public function get type() : int
      {
         return BaseLoader.COMPRESS_TEXT_LOADER;
      }
   }
}
