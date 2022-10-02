package ddt.view.caddyII
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.view.caddyII.reader.AwardsInfo;
   import ddt.view.caddyII.reader.CaddyUpdate;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   
   public class CaddyModel extends EventDispatcher
   {
      
      public static var _instance:CaddyModel;
      
      public static const Gold_Caddy:int = 4;
      
      public static const Silver_Caddy:int = 5;
      
      public static const CADDY_TYPE:int = 1;
      
      public static const BEAD_TYPE:int = 2;
      
      public static const OFFER_PACKET:int = 3;
      
      public static const CARD_TYPE:int = 6;
      
      public static const MYSTICAL_CARDBOX:int = 8;
      
      public static const MY_CARDBOX:int = 9;
      
      public static const CARD_CARTON:int = 7;
      
      public static const AWARDS_NUMBER:int = 10;
      
      public static const BEADTYPE_CHANGE:String = "beadType_change";
      
      public static const AWARDS_CHANGE:String = "awards_change";
      
      public static const Bead_Attack:int = 0;
      
      public static const Bead_Defense:int = 1;
      
      public static const Bead_Attribute:int = 2;
      
      public static const PACK_I:int = 0;
      
      public static const PACK_II:int = 1;
      
      public static const PACK_III:int = 2;
      
      public static const PACK_IV:int = 3;
      
      public static const PACK_V:int = 4;
       
      
      private var _type:int;
      
      private var _bagInfo:BagInfo;
      
      private var _beadType:int;
      
      private var _offerType:int;
      
      private var _boxName:Array;
      
      private var _caddyTempId:Array;
      
      public var _caddyBoxList:Vector.<InventoryItemInfo>;
      
      public var _attackList:Vector.<InventoryItemInfo>;
      
      public var _defenseList:Vector.<InventoryItemInfo>;
      
      public var _attributeList:Vector.<InventoryItemInfo>;
      
      public var awardsList:Vector.<AwardsInfo>;
      
      public var exploitList:Array;
      
      public function CaddyModel()
      {
         this._boxName = [LanguageMgr.GetTranslation("tank.view.caddy.boxNameCaddy"),LanguageMgr.GetTranslation("tank.view.caddy.boxNameBead"),LanguageMgr.GetTranslation("tank.view.caddy.boxNameGift")];
         super();
         this.init();
      }
      
      public static function get instance() : CaddyModel
      {
         if(_instance == null)
         {
            _instance = new CaddyModel();
         }
         return _instance;
      }
      
      private function init() : void
      {
         this.awardsList = new Vector.<AwardsInfo>();
         this._caddyBoxList = new Vector.<InventoryItemInfo>();
         this._attackList = new Vector.<InventoryItemInfo>();
         this._defenseList = new Vector.<InventoryItemInfo>();
         this._attributeList = new Vector.<InventoryItemInfo>();
         this.initExploitList();
         this.createData();
      }
      
      private function initExploitList() : void
      {
         this.exploitList = new Array();
         this.exploitList.push(new Vector.<InventoryItemInfo>());
         this.exploitList.push(new Vector.<InventoryItemInfo>());
         this.exploitList.push(new Vector.<InventoryItemInfo>());
         this.exploitList.push(new Vector.<InventoryItemInfo>());
         this.exploitList.push(new Vector.<InventoryItemInfo>());
      }
      
      public function setup(param1:int) : void
      {
         this._type = param1;
      }
      
      private function createData() : void
      {
         this.createBeadData(BossBoxManager.instance.beadTempInfoList[EquipType.BEAD_ATTACK],this._attackList);
         this.createBeadData(BossBoxManager.instance.beadTempInfoList[EquipType.BEAD_DEFENSE],this._defenseList);
         this.createBeadData(BossBoxManager.instance.beadTempInfoList[EquipType.BEAD_ATTRIBUTE],this._attributeList);
         this.createBeadData(BossBoxManager.instance.exploitTemplateIDs[EquipType.OFFER_PACK_I],this.exploitList[0]);
         this.createBeadData(BossBoxManager.instance.exploitTemplateIDs[EquipType.OFFER_PACK_II],this.exploitList[1]);
         this.createBeadData(BossBoxManager.instance.exploitTemplateIDs[EquipType.OFFER_PACK_III],this.exploitList[2]);
         this.createBeadData(BossBoxManager.instance.exploitTemplateIDs[EquipType.OFFER_PACK_IV],this.exploitList[3]);
         this.createBeadData(BossBoxManager.instance.exploitTemplateIDs[EquipType.OFFER_PACK_V],this.exploitList[4]);
         this.sortBeadData();
      }
      
      private function createCaddyBoxData() : void
      {
         var _loc1_:DictionaryData = BossBoxManager.instance.boxTempIDList;
         var _loc2_:Array = CaddyAwardModel.getInstance().getAwards();
         var _loc3_:int = _loc2_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this._caddyBoxList.push(this.createInfo(_loc1_[_loc2_[_loc4_]]));
            _loc4_++;
         }
      }
      
      private function createBeadData(param1:Vector.<BoxGoodsTempInfo>, param2:Vector.<InventoryItemInfo>) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            param2.push(this.createInfo(param1[_loc3_]));
            _loc3_++;
         }
      }
      
      private function createInfo(param1:BoxGoodsTempInfo) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = this.getTemplateInfo(param1.TemplateId) as InventoryItemInfo;
         _loc2_.StrengthenLevel = param1.StrengthenLevel;
         _loc2_.AttackCompose = param1.AttackCompose;
         _loc2_.DefendCompose = param1.DefendCompose;
         _loc2_.LuckCompose = param1.LuckCompose;
         _loc2_.AgilityCompose = param1.AgilityCompose;
         _loc2_.IsBinds = param1.IsBind;
         _loc2_.ValidDate = param1.ItemValid;
         _loc2_.Count = param1.ItemCount;
         _loc2_.IsJudge = true;
         return _loc2_;
      }
      
      private function getTemplateInfo(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         ItemManager.fill(_loc2_);
         return _loc2_;
      }
      
      private function sortBeadData() : void
      {
         this._attackList.sort(this.compareBeadDataFun);
         this._defenseList.sort(this.compareBeadDataFun);
         this._attributeList.sort(this.compareBeadDataFun);
      }
      
      private function compareFun(param1:BoxGoodsTempInfo, param2:BoxGoodsTempInfo) : int
      {
         if(param1.IsTips >= param2.IsTips)
         {
            return -1;
         }
         return 1;
      }
      
      private function compareBeadDataFun(param1:InventoryItemInfo, param2:InventoryItemInfo) : int
      {
         if(param1.TemplateID >= param2.TemplateID)
         {
            return -1;
         }
         return 1;
      }
      
      private function _addAwardsInfo(param1:String, param2:int, param3:Boolean = false, param4:String = "", param5:int = 0) : void
      {
         var _loc6_:AwardsInfo = new AwardsInfo();
         _loc6_.name = param1;
         _loc6_.TemplateId = param2;
         _loc6_.isLong = param3;
         _loc6_.zone = param4;
         _loc6_.zoneID = param5;
         this.awardsList.unshift(_loc6_);
         if(this.awardsList.length > AWARDS_NUMBER)
         {
            this.awardsList.pop();
         }
      }
      
      public function get tempid() : Array
      {
         return this._caddyTempId;
      }
      
      public function set tempid(param1:Array) : void
      {
         this._caddyTempId = param1;
      }
      
      private function fillListFromAward(param1:Array) : Vector.<InventoryItemInfo>
      {
         var _loc2_:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
         var _loc3_:DictionaryData = BossBoxManager.instance.boxTempIDList;
         var _loc4_:int = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_.push(this.createInfo(_loc3_[param1[_loc5_]]));
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function getCaddyTrophy(param1:int) : Vector.<InventoryItemInfo>
      {
         if(param1 == EquipType.Gold_Caddy)
         {
            return this.fillListFromAward(CaddyAwardModel.getInstance().getGoldAwards());
         }
         if(param1 == EquipType.Silver_Caddy)
         {
            return this.fillListFromAward(CaddyAwardModel.getInstance().getSilverAwards());
         }
         return this.fillListFromAward(CaddyAwardModel.getInstance().getAwards());
      }
      
      public function getOfferPacketThrophy(param1:int) : Vector.<InventoryItemInfo>
      {
         switch(param1)
         {
            case EquipType.OFFER_PACK_I:
               return this.exploitList[PACK_I];
            case EquipType.OFFER_PACK_II:
               return this.exploitList[PACK_II];
            case EquipType.OFFER_PACK_III:
               return this.exploitList[PACK_III];
            case EquipType.OFFER_PACK_IV:
               return this.exploitList[PACK_IV];
            case EquipType.OFFER_PACK_V:
               return this.exploitList[PACK_V];
            default:
               return null;
         }
      }
      
      public function getTrophyData() : Vector.<InventoryItemInfo>
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               return this._caddyBoxList;
            case BEAD_TYPE:
               if(this.beadType == 0)
               {
                  return this._attackList;
               }
               if(this.beadType == 1)
               {
                  return this._defenseList;
               }
               return this._attributeList;
               break;
            case OFFER_PACKET:
               return this.exploitList[this._offerType];
            default:
               return this._caddyBoxList;
         }
      }
      
      public function appendAwardsInfo(param1:String, param2:int, param3:Boolean = false, param4:String = "", param5:int = 0, param6:int = 0) : void
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               if(param6 == 3)
               {
                  this._addAwardsInfo(param1,param2,param3,param4,param5);
                  dispatchEvent(new Event(AWARDS_CHANGE));
               }
               break;
            case BEAD_TYPE:
               if(param6 == 4)
               {
                  this._addAwardsInfo(param1,param2,param3,param4,param5);
                  dispatchEvent(new Event(AWARDS_CHANGE));
               }
               break;
            case OFFER_PACKET:
               if(param6 == 5)
               {
                  this._addAwardsInfo(param1,param2,param3,param4,param5);
                  dispatchEvent(new Event(AWARDS_CHANGE));
               }
         }
      }
      
      public function addAwardsInfoByArr(param1:Vector.<AwardsInfo>) : void
      {
         var _loc2_:int = param1.length > AWARDS_NUMBER ? int(int(AWARDS_NUMBER)) : int(int(param1.length));
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._addAwardsInfo(param1[_loc3_].name,param1[_loc3_].TemplateId,param1[_loc3_].isLong,param1[_loc3_].zone,param1[_loc3_].zoneID);
            _loc3_++;
         }
         dispatchEvent(new Event(AWARDS_CHANGE));
      }
      
      public function clearAwardsList() : void
      {
         this.awardsList.splice(0,this.awardsList.length);
         this.awardsList = new Vector.<AwardsInfo>();
      }
      
      public function get bagInfo() : BagInfo
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               return PlayerManager.Instance.Self.CaddyBag;
            case BEAD_TYPE:
               return PlayerManager.Instance.Self.CaddyBag;
            default:
               return PlayerManager.Instance.Self.CaddyBag;
         }
      }
      
      public function get rightView() : RightView
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               return ComponentFactory.Instance.creatCustomObject("caddy.CaddyViewII");
            case BEAD_TYPE:
            case MYSTICAL_CARDBOX:
               return ComponentFactory.Instance.creatCustomObject("bead.BeadViewII");
            case OFFER_PACKET:
               return ComponentFactory.Instance.creatCustomObject("offer.OfferPackViewII");
            case MY_CARDBOX:
               return ComponentFactory.Instance.creatCustomObject("bead.BeadViewII");
            case CARD_CARTON:
               return ComponentFactory.Instance.creatCustomObject("bead.BeadViewII");
            default:
               return ComponentFactory.Instance.creatCustomObject("offer.OfferPackViewII");
         }
      }
      
      public function get readView() : CaddyUpdate
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               return ComponentFactory.Instance.creatCustomObject("caddy.BadLuckView");
            case BEAD_TYPE:
               return ComponentFactory.Instance.creatCustomObject("caddy.ReadAwardsView");
            case OFFER_PACKET:
               return ComponentFactory.Instance.creatCustomObject("caddy.ReadAwardsView");
            default:
               return ComponentFactory.Instance.creatCustomObject("caddy.ReadAwardsView");
         }
      }
      
      public function get moveSprite() : Sprite
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               return ComponentFactory.Instance.creatCustomObject("caddy.moveSprite");
            case BEAD_TYPE:
               return ComponentFactory.Instance.creatCustomObject("bead.moveSprite");
            case OFFER_PACKET:
               return ComponentFactory.Instance.creatCustomObject("bead.moveSprite");
            default:
               return ComponentFactory.Instance.creatCustomObject("caddy.moveSprite");
         }
      }
      
      public function get beadType() : int
      {
         return this._beadType;
      }
      
      public function set beadType(param1:int) : void
      {
         switch(param1)
         {
            case EquipType.BEAD_ATTACK:
               this._beadType = Bead_Attack;
               break;
            case EquipType.BEAD_DEFENSE:
               this._beadType = Bead_Defense;
               break;
            case EquipType.BEAD_ATTRIBUTE:
               this._beadType = Bead_Attribute;
               break;
            default:
               this._beadType = param1;
         }
         dispatchEvent(new Event(BEADTYPE_CHANGE));
      }
      
      public function set offerType(param1:int) : void
      {
         switch(param1)
         {
            case EquipType.OFFER_PACK_I:
               this._offerType = PACK_I;
               break;
            case EquipType.OFFER_PACK_II:
               this._offerType = PACK_II;
               break;
            case EquipType.OFFER_PACK_III:
               this._offerType = PACK_III;
               break;
            case EquipType.OFFER_PACK_IV:
               this._offerType = PACK_IV;
               break;
            case EquipType.OFFER_PACK_V:
               this._offerType = PACK_V;
               break;
            default:
               this._offerType = 0;
         }
      }
      
      public function get offerType() : int
      {
         return this._offerType;
      }
      
      public function get CaddyFrameTitle() : String
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               return LanguageMgr.GetTranslation("tank.view.caddy.title");
            case BEAD_TYPE:
               return LanguageMgr.GetTranslation("tank.view.bead.title");
            case OFFER_PACKET:
               return LanguageMgr.GetTranslation("tank.game.GameView.GiftBattle");
            case MYSTICAL_CARDBOX:
               return LanguageMgr.GetTranslation("tank.game.GameView.cardBoxBattle");
            case CARD_TYPE:
               return LanguageMgr.GetTranslation("tank.view.card.title");
            case MY_CARDBOX:
               return LanguageMgr.GetTranslation("tank.game.GameView.cardBoxBattle1");
            case CARD_CARTON:
               return LanguageMgr.GetTranslation("tank.game.GameView.cardBoxBattle2");
            default:
               return null;
         }
      }
      
      public function get dontClose() : String
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               return LanguageMgr.GetTranslation("tank.view.caddy.dontClose");
            case BEAD_TYPE:
               return LanguageMgr.GetTranslation("tank.view.bead.dontClose");
            case OFFER_PACKET:
               return LanguageMgr.GetTranslation("tank.view.offer.dontClose");
            case MYSTICAL_CARDBOX:
               return LanguageMgr.GetTranslation("tank.view.caddy.cardBoxDontClose");
            case CARD_TYPE:
               return LanguageMgr.GetTranslation("tank.view.card.dontClose");
            case MY_CARDBOX:
               return LanguageMgr.GetTranslation("tank.view.caddy.cardBoxDontClose");
            case CARD_CARTON:
               return LanguageMgr.GetTranslation("tank.view.caddy.cardCartonDontClose");
            default:
               return null;
         }
      }
      
      public function get AwardsBuff() : String
      {
         switch(this._type)
         {
            case CADDY_TYPE:
               return LanguageMgr.GetTranslation("tank.view.caddy.openCaddy");
            case BEAD_TYPE:
            case OFFER_PACKET:
               return LanguageMgr.GetTranslation("tank.view.offer.opendGetAwards");
            case MYSTICAL_CARDBOX:
               return LanguageMgr.GetTranslation("tank.view.caddy.openCardBox");
            case MY_CARDBOX:
               return LanguageMgr.GetTranslation("tank.view.caddy.openCardBox");
            case CARD_CARTON:
               return LanguageMgr.GetTranslation("tank.view.caddy.openCardCarton");
            default:
               LanguageMgr.GetTranslation("tank.view.caddy.openCardBox");
               return null;
         }
      }
      
      public function get type() : int
      {
         return this._type;
      }
   }
}
