package com.pickgliss.loader
{
   import flash.events.Event;
   
   public class LoaderEvent extends Event
   {
      
      public static const COMPLETE:String = "complete";
      
      public static const LOAD_ERROR:String = "loadError";
      
      public static const PROGRESS:String = "progress";
       
      
      public var loader:BaseLoader;
      
      public function LoaderEvent(param1:String, param2:BaseLoader)
      {
         this.loader = param2;
         super(param1);
      }
   }
}
