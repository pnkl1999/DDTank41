package ddt.events
{
   import flash.events.Event;
   
   public class ShortcutBuyEvent extends Event
   {
      
      public static const SHORTCUT_BUY:String = "shortcutBuy";
      
      public static const SHORTCUT_BUY_MONEY_OK:String = "shortcutBuyMoneyOk";
      
      public static const SHORTCUT_BUY_MONEY_CANCEL:String = "shortcutBuyMoneyCancel";
       
      
      private var _itemID:int;
      
      private var _itemNum:int;
      
      public function ShortcutBuyEvent(param1:int, param2:int, param3:Boolean = false, param4:Boolean = false, param5:String = "shortcutBuy")
      {
         super(param5,param3,param4);
         this._itemID = param1;
         this._itemNum = param2;
      }
      
      public function get ItemID() : int
      {
         return this._itemID;
      }
      
      public function get ItemNum() : int
      {
         return this._itemNum;
      }
   }
}
