package cardSystem.model
{
   import cardSystem.CardEvent;
   import cardSystem.data.CardInfo;
   import cardSystem.data.SetsInfo;
   import cardSystem.data.SetsUpgradeRuleInfo;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   
   public class CardModel extends EventDispatcher
   {
      
      public static const OPEN_FOUR_NEEDS_TWOSTAR:int = 1;
      
      public static const OPEN_FIVE_NEEDS_THREESTAR:int = 2;
      
      public static const OPEN_FIVE_NEEDS_THREESTARTWO:int = 3;
      
      public static const MONSTER_CARDS:int = 0;
      
      public static const WEQPON_CARDS:int = 1;
      
      public static const PVE_CARDS:int = 2;
      
      public static const CELLS_SUM:int = 15;
      
      public static const EQUIP_CELLS_SUM:int = 5;
       
      
      private var _setsList:DictionaryData;
      
      private var _setsSortRuleVector:Vector.<SetsInfo>;
      
      public var upgradeRuleVec:Vector.<SetsUpgradeRuleInfo>;
      
      public var propIncreaseDic:DictionaryData;
      
      public function CardModel()
      {
         super();
      }
      
      public function get setsSortRuleVector() : Vector.<SetsInfo>
      {
         return this._setsSortRuleVector;
      }
      
      public function set setsSortRuleVector(param1:Vector.<SetsInfo>) : void
      {
         this._setsSortRuleVector = param1;
         dispatchEvent(new CardEvent(CardEvent.SETSSORTRULE_INIT_COMPLETE,this.setsSortRuleVector));
      }
      
      public function get setsList() : DictionaryData
      {
         return this._setsList;
      }
      
      public function set setsList(param1:DictionaryData) : void
      {
         this._setsList = param1;
         dispatchEvent(new CardEvent(CardEvent.SETSPROP_INIT_COMPLETE,this.setsList));
      }
      
      public function fourIsOpen() : Boolean
      {
         var _loc2_:CardInfo = null;
         var _loc1_:int = 0;
         for each(_loc2_ in PlayerManager.Instance.Self.cardBagDic)
         {
            if(_loc2_.Level >= 20)
            {
               _loc1_++;
            }
         }
         return _loc1_ >= OPEN_FOUR_NEEDS_TWOSTAR;
      }
      
      public function fiveIsOpen() : Boolean
      {
         var _loc2_:CardInfo = null;
         var _loc1_:int = 0;
         for each(_loc2_ in PlayerManager.Instance.Self.cardBagDic)
         {
            if(_loc2_.Level == 30)
            {
               _loc1_++;
            }
         }
         return _loc1_ >= OPEN_FOUR_NEEDS_TWOSTAR;
      }
      
      public function fiveIsOpen2() : Boolean
      {
         var _loc2_:CardInfo = null;
         var _loc1_:int = 0;
         for each(_loc2_ in PlayerManager.Instance.Self.cardBagDic)
         {
            if(_loc2_.Level >= 20)
            {
               _loc1_++;
            }
         }
         return _loc1_ >= OPEN_FIVE_NEEDS_THREESTARTWO;
      }
      
      public function get Pages() : int
      {
         return Math.ceil(PlayerManager.Instance.Self.cardBagDic.length / CELLS_SUM);
      }
      
      public function getDataByPage(param1:int) : DictionaryData
      {
         var _loc6_:CardInfo = null;
         var _loc2_:DictionaryData = new DictionaryData();
         var _loc3_:DictionaryData = PlayerManager.Instance.Self.cardBagDic;
         var _loc4_:int = (param1 - 1) * CELLS_SUM + EQUIP_CELLS_SUM;
         var _loc5_:int = _loc4_ + CELLS_SUM;
         for each(_loc6_ in _loc3_)
         {
            if(_loc6_.Place >= _loc4_ && _loc6_.Place < _loc5_)
            {
               _loc2_[_loc6_.Place] = _loc6_;
            }
         }
         return _loc2_;
      }
      
      public function getBagListData() : Array
      {
         var _loc4_:CardInfo = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:Array = new Array();
         var _loc2_:DictionaryData = PlayerManager.Instance.Self.cardBagDic;
         var _loc3_:int = 0;
         for each(_loc4_ in _loc2_)
         {
            _loc6_ = _loc4_.Place % 4 == 0 ? int(int(_loc4_.Place / 4 - 2)) : int(int(_loc4_.Place / 4 - 1));
            if(_loc1_[_loc6_] == null)
            {
               _loc1_[_loc6_] = new Array();
            }
            _loc7_ = _loc4_.Place % 4 == 0 ? int(int(4)) : int(int(_loc4_.Place % 4));
            _loc1_[_loc6_][0] = _loc6_ + 1;
            _loc1_[_loc6_][_loc7_] = _loc4_;
            if(_loc6_ + 1 > _loc3_)
            {
               _loc3_ = _loc6_ + 1;
            }
         }
         if(_loc3_ < 3)
         {
            _loc3_ = 3;
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            if(_loc1_[_loc5_] == null)
            {
               _loc1_[_loc5_] = new Array();
               _loc1_[_loc5_][0] = _loc5_ + 1;
            }
            _loc5_++;
         }
         return _loc1_;
      }
      
      public function getSetsCardFromCardBag(param1:String) : Vector.<CardInfo>
      {
         var _loc4_:CardInfo = null;
         var _loc2_:DictionaryData = PlayerManager.Instance.Self.cardBagDic;
         var _loc3_:Vector.<CardInfo> = new Vector.<CardInfo>();
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_.templateInfo.Property7 == param1)
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
   }
}
