package times.data
{
   import flash.events.Event;
   
   public class TimesEvent extends Event
   {
      
      public static const PURCHASE:String = "purchase";
      
      public static const PLAY_SOUND:String = "playSound";
      
      public static const GOTO_HOME_PAGE:String = "gotoHomepage";
      
      public static const GOTO_CONTENT:String = "gotoContent";
      
      public static const GOTO_PRE_CONTENT:String = "gotoPreContent";
      
      public static const GOTO_NEXT_CONTENT:String = "gotoNextContent";
      
      public static const PUSH_TIP_ITEMS:String = "pushTipItems";
      
      public static const PUSH_TIP_CELLS:String = "pushTipCells";
      
      public static const THUMBNAIL_LOAD_COMPLETE:String = "thumbnailLoadComplete";
      
      public static const CLOSE_VIEW:String = "closeView";
      
      public static const GOT_EGG:String = "gotEgg";
       
      
      public var info:TimesPicInfo;
      
      public var params:Array;
      
      public function TimesEvent(param1:String, param2:TimesPicInfo = null, param3:Array = null, param4:Boolean = false, param5:Boolean = false)
      {
         this.info = param2;
         this.params = param3;
         super(param1,param4,param5);
      }
   }
}
