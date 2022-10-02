package ddt.events
{
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class BagEvent extends Event
   {
      
      public static const UPDATE:String = "update";
      
      public static const PSDPRO:String = "password protection";
      
      public static const BACK_STEP:String = "backStep";
      
      public static const CHANGEPSW:String = "changePassword";
      
      public static const DELPSW:String = "deletePassword";
      
      public static const AFTERDEL:String = "afterDel";
      
      public static const NEEDPRO:String = "needprotection";
      
      public static const UPDATE_SUCCESS:String = "updateSuccess";
      
      public static const CLEAR:String = "clearSuccess";
      
      public static const PSW_CLOSE:String = "passwordClose";
      
      public static const UPDATE_Exalt:String = "update_exalt";
	  
	  public static const GEMSTONE_BUG_COUNT:String = "gemstone_buy_count";
       
      
      private var _flag:Boolean;
      
      private var _needSecond:Boolean;
      
      private var _changedSlot:Dictionary;
      
      private var _passwordArray:Array;
      
      public function BagEvent(param1:String, param2:Dictionary)
      {
         this._changedSlot = param2;
         super(param1);
      }
      
      public function get changedSlots() : Dictionary
      {
         return this._changedSlot;
      }
      
      public function get passwordArray() : Array
      {
         return this._passwordArray;
      }
      
      public function set passwordArray(param1:Array) : void
      {
         this._passwordArray = param1;
      }
      
      public function get flag() : Boolean
      {
         return this._flag;
      }
      
      public function set flag(param1:Boolean) : void
      {
         this._flag = param1;
      }
      
      public function get needSecond() : Boolean
      {
         return this._needSecond;
      }
      
      public function set needSecond(param1:Boolean) : void
      {
         this._needSecond = param1;
      }
   }
}
