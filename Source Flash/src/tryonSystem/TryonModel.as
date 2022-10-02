package tryonSystem
{
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   
   public class TryonModel extends EventDispatcher
   {
       
      
      private var _playerInfo:PlayerInfo;
      
      private var _selectedItem:InventoryItemInfo;
      
      private var _items:Array;
      
      private var _bagItems:DictionaryData;
      
      public function TryonModel(param1:Array)
      {
         var _loc3_:InventoryItemInfo = null;
         super();
         this._items = param1;
         var _loc2_:PlayerInfo = PlayerManager.Instance.Self;
         this._playerInfo = new PlayerInfo();
         this._playerInfo.updateStyle(_loc2_.Sex,_loc2_.Hide,_loc2_.getPrivateStyle(),_loc2_.Colors,_loc2_.getSkinColor());
         this._bagItems = new DictionaryData();
         for each(_loc3_ in _loc2_.Bag.items)
         {
            if(_loc3_.Place <= 30)
            {
               this._bagItems.add(_loc3_.Place,_loc3_);
            }
         }
      }
      
      public function set selectedItem(param1:InventoryItemInfo) : void
      {
         if(param1 == this._selectedItem)
         {
            return;
         }
         this._selectedItem = param1;
         if(EquipType.isAvatar(param1.CategoryID))
         {
            this._playerInfo.setPartStyle(param1.CategoryID,param1.NeedSex,param1.TemplateID);
            if(param1.CategoryID == EquipType.FACE)
            {
               this._playerInfo.setSkinColor(param1.Skin);
            }
            this._bagItems.add(EquipType.CategeryIdToPlace(this._selectedItem.CategoryID)[0],this._selectedItem);
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get bagItems() : DictionaryData
      {
         return this._bagItems;
      }
      
      public function get items() : Array
      {
         return this._items;
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._playerInfo;
      }
      
      public function get selectedItem() : InventoryItemInfo
      {
         return this._selectedItem;
      }
      
      public function dispose() : void
      {
         this._selectedItem = null;
         this._items = null;
         this._playerInfo = null;
         this._bagItems = null;
      }
   }
}
