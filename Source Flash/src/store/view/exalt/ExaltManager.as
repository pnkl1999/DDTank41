package store.view.exalt
{
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class ExaltManager extends EventDispatcher
   {
      
      public static const EQUIP_MOVE:String = "exalt_equip_move";
      
      public static const EQUIP_MOVE2:String = "exalt_equip_move2";
      
      public static const ITEM_MOVE:String = "exalt_item_move";
      
      public static const ITEM_MOVE2:String = "exalt_item_move2";
      
      private static var _instance:ExaltManager;
       
      
      public function ExaltManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : ExaltManager
      {
         if(_instance == null)
         {
            _instance = new ExaltManager();
         }
         return _instance;
      }
      
      public function getCanWishBeadData() : BagInfo
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:InventoryItemInfo = null;
         var _loc1_:DictionaryData = PlayerManager.Instance.Self.Bag.items;
         var _loc2_:BagInfo = new BagInfo(BagInfo.EQUIPBAG,21);
         var _loc3_:Array = new Array();
         for each(_loc4_ in _loc1_)
         {
            if(_loc4_.StrengthenLevel >= 12 && (_loc4_.CategoryID == EquipType.ARM || _loc4_.CategoryID == EquipType.CLOTH || _loc4_.CategoryID == EquipType.HEAD))
            {
               if(_loc4_.Place < 17)
               {
                  _loc2_.addItem(_loc4_);
               }
               else
               {
                  _loc3_.push(_loc4_);
               }
            }
         }
         for each(_loc5_ in _loc3_)
         {
            _loc2_.addItem(_loc5_);
         }
         return _loc2_;
      }
      
      public function getWishBeadItemData() : BagInfo
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc1_:DictionaryData = PlayerManager.Instance.Self.PropBag.items;
         var _loc2_:BagInfo = new BagInfo(BagInfo.PROPBAG,21);
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.TemplateID == EquipType.WISHBEAD_ATTACK || _loc3_.TemplateID == EquipType.WISHBEAD_DEFENSE || _loc3_.TemplateID == EquipType.WISHBEAD_AGILE)
            {
               _loc2_.addItem(_loc3_);
            }
         }
         return _loc2_;
      }
   }
}
