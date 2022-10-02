package com.pickgliss.toplevel
{
   import flash.display.Stage;
   import flash.events.Event;
   
   public final class StageReferance
   {
      
      public static var stageHeight:int;
      
      public static var stageWidth:int;
      
      private static var _stage:Stage;
       
      
      public function StageReferance()
      {
         super();
      }
      
      public static function setup(param1:Stage) : void
      {
         if(_stage != null)
         {
            return;
         }
         _stage = param1;
         _stage.addEventListener(Event.EXIT_FRAME,__onNextFrame);
         _stage.addEventListener(Event.RESIZE,__onResize);
         _stage.stageFocusRect = false;
      }
      
      private static function __onNextFrame(param1:Event) : void
      {
         if(_stage.stageWidth > 0)
         {
            _stage.removeEventListener(Event.EXIT_FRAME,__onNextFrame);
            stageWidth = _stage.stageWidth;
            stageHeight = _stage.stageHeight;
         }
      }
      
      private static function __onResize(param1:Event) : void
      {
         stageWidth = _stage.stageWidth;
         stageHeight = _stage.stageHeight;
      }
      
      public static function get stage() : Stage
      {
         return _stage;
      }
   }
}
