package com.pickgliss.events
{
   import com.pickgliss.loader.BaseLoader;
   import flash.events.Event;
   
   public class UIModuleEvent extends Event
   {
      
      public static const UI_MODULE_COMPLETE:String = "uiModuleComplete";
      
      public static const UI_MODULE_ERROR:String = "uiModuleError";
      
      public static const UI_MODULE_PROGRESS:String = "uiMoudleProgress";
       
      
      public var module:String;
      
      public var loader:BaseLoader;
      
      public var state:String;
      
      public function UIModuleEvent(param1:String, param2:BaseLoader = null)
      {
         this.loader = param2;
         this.module = param2.loadProgressMessage;
         this.state = param2.loadCompleteMessage;
         super(param1);
      }
   }
}
