package ddt.events
{
   import flash.events.Event;
   
   public class ItemEvent extends Event
   {
      
      public static const ITEM_SELECT:String = "itemSelect";
      
      public static const ITEM_CLICK:String = "itemClick";
      
      public static const ITEM_OVER:String = "itemOver";
      
      public static const ITEM_OUT:String = "itemOut";
      
      public static const ITEM_MOVE:String = "itemMove";
       
      
      private var _item:Object;
      
      private var _index:uint;
      
      public function ItemEvent(param1:String, param2:Object, param3:uint)
      {
         super(param1);
         this._item = param2;
         this._index = param3;
      }
      
      public function get item() : Object
      {
         return this._item;
      }
      
      public function get index() : uint
      {
         return this._index;
      }
   }
}
