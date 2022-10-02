package store.forge.wishBead
{
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.analyze.WishInfoAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class WishBeadManager extends EventDispatcher
   {
      
      public static const EQUIP_MOVE:String = "wishBead_equip_move";
      
      public static const EQUIP_MOVE2:String = "wishBead_equip_move2";
      
      public static const ITEM_MOVE:String = "wishBead_item_move";
      
      public static const ITEM_MOVE2:String = "wishBead_item_move2";
      
      private static var _instance:WishBeadManager;
       
      
      public var wishInfoList:Vector.<WishChangeInfo>;
      
      public function WishBeadManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : WishBeadManager
      {
         if(_instance == null)
         {
            _instance = new WishBeadManager();
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
      
      public function getIsEquipMatchWishBead(param1:int, param2:int, param3:Boolean) : Boolean
      {
         switch(param1)
         {
            case EquipType.WISHBEAD_ATTACK:
               if(param2 == EquipType.ARM)
               {
                  return true;
               }
               if(param3)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBeadMainView.noMatchTipTxt"));
               }
               return false;
               break;
            case EquipType.WISHBEAD_DEFENSE:
               if(param2 == EquipType.CLOTH)
               {
                  return true;
               }
               if(param3)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBeadMainView.noMatchTipTxt2"));
               }
               return false;
               break;
            case EquipType.WISHBEAD_AGILE:
               if(param2 == EquipType.HEAD)
               {
                  return true;
               }
               if(param3)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBeadMainView.noMatchTipTxt3"));
               }
               return false;
               break;
            default:
               return false;
         }
      }
      
      public function getwishInfo(param1:WishInfoAnalyzer) : void
      {
         this.wishInfoList = param1._wishChangeInfo;
      }
      
      public function getWishInfoByTemplateID(param1:int, param2:int) : WishChangeInfo
      {
         var _loc4_:WishChangeInfo = null;
         var _loc3_:WishChangeInfo = null;
         for each(_loc4_ in this.wishInfoList)
         {
            if(_loc4_.OldTemplateId == param1)
            {
               return _loc4_;
            }
            if(_loc4_.OldTemplateId == -1 && _loc4_.CategoryID == param2)
            {
               _loc3_ = _loc4_;
            }
         }
         return _loc3_;
      }
   }
}
