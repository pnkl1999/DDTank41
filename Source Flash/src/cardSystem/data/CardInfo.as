package cardSystem.data
{
   import cardSystem.CardControl;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class CardInfo extends EventDispatcher
   {
      
      public static const WEAPON_CARDS:int = 1;
      
      public static const MONSTER_CARDS:int = 2;
      
      public static const cardsType:Array = [LanguageMgr.GetTranslation("BrowseLeftMenuView.equipCard"),LanguageMgr.GetTranslation("BrowseLeftMenuView.freakCard")];
      
      public static const cardsMain:Array = [LanguageMgr.GetTranslation("ddt.cardSystem.CardsTipPanel.vice"),LanguageMgr.GetTranslation("ddt.cardSystem.CardsTipPanel.main")];
      
      public static const MAX_EQUIP_CARDS:int = 4;
       
      
      public var CardID:int;
      
      public var UserID:int;
      
      public var TemplateID:int;
      
      public var Place:int;
      
      public var Count:int;
      
      public var Attack:int;
      
      public var Defence:int;
      
      public var Agility:int;
      
      public var Luck:int;
      
      public var Guard:int;
      
      public var Damage:int;
      
      public var Level:int;
      
      public var CardGP:int;
      
      public var isFirstGet:Boolean = true;
      
      public function CardInfo(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function get templateInfo() : ItemTemplateInfo
      {
         return ItemManager.Instance.getTemplateById(this.TemplateID);
      }
      
      public function get realAttack() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.Level != 0)
         {
            _loc1_ = 0;
            _loc2_ = 1;
            while(_loc2_ <= this.Level)
            {
               _loc1_ += CardControl.Instance.model.propIncreaseDic[this.TemplateID][_loc2_].Attack;
               _loc2_++;
            }
            return this.templateInfo.Attack + _loc1_;
         }
         return this.templateInfo.Attack;
      }
      
      public function get realDefence() : int
      {
         var _loc1_:int = 0;
         var _loc2_:DictionaryData = null;
         var _loc3_:int = 0;
         if(this.Level != 0)
         {
            _loc1_ = 0;
            _loc2_ = CardControl.Instance.model.propIncreaseDic[this.TemplateID];
            _loc3_ = 1;
            while(_loc3_ <= this.Level)
            {
               _loc1_ += _loc2_[_loc3_].Defend;
               _loc3_++;
            }
            return this.templateInfo.Defence + _loc1_;
         }
         return this.templateInfo.Defence;
      }
      
      public function get realAgility() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.Level != 0)
         {
            _loc1_ = 0;
            _loc2_ = 1;
            while(_loc2_ <= this.Level)
            {
               _loc1_ += CardControl.Instance.model.propIncreaseDic[this.TemplateID][_loc2_].Agility;
               _loc2_++;
            }
            return this.templateInfo.Agility + _loc1_;
         }
         return this.templateInfo.Agility;
      }
      
      public function get realLuck() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.Level != 0)
         {
            _loc1_ = 0;
            _loc2_ = 1;
            while(_loc2_ <= this.Level)
            {
               _loc1_ += CardControl.Instance.model.propIncreaseDic[this.TemplateID][_loc2_].Lucky;
               _loc2_++;
            }
            return this.templateInfo.Luck + _loc1_;
         }
         return this.templateInfo.Luck;
      }
      
      public function get realDamage() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.Level != 0)
         {
            _loc1_ = 0;
            _loc2_ = 1;
            while(_loc2_ <= this.Level)
            {
               _loc1_ += CardControl.Instance.model.propIncreaseDic[this.TemplateID][_loc2_].Damage;
               _loc2_++;
            }
            return int(this.templateInfo.Property4) + _loc1_;
         }
         return int(this.templateInfo.Property4);
      }
      
      public function get realGuard() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.Level != 0)
         {
            _loc1_ = 0;
            _loc2_ = 1;
            while(_loc2_ <= this.Level)
            {
               _loc1_ += CardControl.Instance.model.propIncreaseDic[this.TemplateID][_loc2_].Guard;
               _loc2_++;
            }
            return int(this.templateInfo.Property5) + _loc1_;
         }
         return int(this.templateInfo.Property5);
      }
   }
}
