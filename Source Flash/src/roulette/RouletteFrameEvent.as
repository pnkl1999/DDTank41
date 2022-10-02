package roulette
{
   import flash.events.Event;
   
   public class RouletteFrameEvent extends Event
   {
      
      public static const ROULETTE_RESULT:String = "roulette_result";
      
      public static const GUN_VISIBLE:String = "gun_visible";
      
      public static const ROULETTE_VISIBLE:String = "roulette_visible";
      
      public static const LEFTGUN_ENABLE:String = "leftGun_enable";
      
      public static const BUTTON_CLICK:String = "button_click";
       
      
      private var _reward:String;
      
      private var _arr:Array;
      
      public function RouletteFrameEvent(param1:String, param2:String = null, param3:Array = null, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1);
         this._reward = param2;
         this._arr = param3;
      }
      
      public function get reward() : String
      {
         return this._reward;
      }
      
      public function get arr() : Array
      {
         return this._arr;
      }
   }
}
