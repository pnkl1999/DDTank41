package ddt.data.player
{
   import flash.events.Event;
   import flash.utils.Dictionary;
   import ddt.data.BagInfo;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.WebSpeedEvent;
   import ddt.manager.AcademyManager;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import gemstone.info.GemstonInitInfo;
   import giftSystem.data.MyGiftCellInfo;
   import pet.date.PetInfo;
   import road7th.data.DictionaryData;
   import store.equipGhost.data.EquipGhostData;
   import store.data.StoreEquipExperience;
   import store.equipGhost.data.EquipGhostData;
   
   import trainer.controller.NewHandGuideManager;
   
   public class PlayerInfo extends BasePlayer
   {
      
      public static const SEX:String = "Sex";
      
      public static const STYLE:String = "Style";
      
      public static const HIDE:String = "Hide";
      
      public static const SKIN:String = "Skin";
      
      public static const COLORS:String = "Colors";
      
      public static const NIMBUS:String = "Nimbus";
      
      public static const GOLD:String = "Gold";
      
      public static const MONEY:String = "Money";
      
      public static const GIFT:String = "Gift";
      
      public static const PETSCORE:String = "PetScore";
      
      public static const MEDAL:String = "medal";
      
      public static const ARM:String = "WeaponID";
      
      public static const UPDATE_SHOP_FINALLY_TIME:String = "shopFinallyGottenTime";
      
      public static const CHARM_LEVEL_NEED_EXP:Array = [0,10,50,120,210,320,450,600,770,960,1170,1410,1680,1980,2310,2670,3060,3480,3930,4410,4920,5470,6060,6690,7360,8070,8820,9610,10440,11310,12220,13190,14220,15310,16460,17670,18940,20270,21660,23110,25110,27660,30760,34410,38610,43360,48660,54510,60910,67860,75360,83460,92160,101460,111360,121860,132960,144660,156960,169860,183360,197460,212160,227460,243360,259860,276960,294660,312960,331860,351360,371460,392160,413460,435360,457860,480960,504660,528960,553860,579360,605460,632160,659460,687360,715860,744960,774660,804960,835860,867360,899460,932160,965460,999360,1033860,1068960,1104660,1140960,1177860];
      
      public static const CHARM_LEVEL_ALL_EXP:Array = [0,10,60,180,390,710,1160,1760,2530,3490,4660,6070,7750,9730,12040,14710,17770,21250,25180,29590,34510,39980,46040,52730,60090,68160,76980,86590,97030,108340,120560,133750,147970,163280,179740,197410,216350,236620,258280,281390,306500,334160,364920,399330,437940,481300,529960,584470,645380,713240,788600,872060,964220,1065680,1177040,1298900,1431860,1576520,1733480,1903340,2086700,2284160,2496320,2723780,2967140,3227000,3503960,3798620,4111580,4443440,4794800,5166260,5558420,5971880,6407240,6865100,7346060,7850720,8379680,8933540,9512900,10118360,10750520,11409980,12097340,12813200,13558160,14332820,15137780,15973640,16841000,17740460,18672620,19638080,20637440,21671300,22740260,23844920,24985880,26163740];
      
      public static const MAX_CHARM_LEVEL:int = 100;
       
      
      private var _hardCurrency:int;
      
      private var _lastLuckNum:int;
      
      private var _luckyNum:int;
      
      private var _lastLuckyNumDate:Date;
      
      private var _attachtype:int = -1;
      
      private var _attachvalue:int;
      
      private var _hide:int;
      
      private var _hidehat:Boolean;
      
      private var _hideGlass:Boolean = false;
      
      private var _suitesHide:Boolean = false;
      
      private var _showSuits:Boolean = true;
      
      private var _wingHide:Boolean = false;
      
      public var _IsShowTitle:Boolean = true;
      
      private var _nimbus:int;
      
      private var _modifyStyle:String;
      
      private var _style:String;
      
      private var _tutorialProgress:int;
      
      private var _colors:String = "|,|,,,,||,,,,";
      
      private var _intuitionalColor:String;
      
      private var _skin:String;
      
      private var _paopaoType:int = 0;
      
      public var SuperAttack:int;
      
      public var Delay:int;
      
      private var _attack:int;
      
      private var _answerSite:int;
      
      private var _defence:int;
      
      private var _luck:int;
      
      private var _hp:int;
      
      public var increaHP:int;
      
      private var _agility:int;
      
      private var _dungeonFlag:Object;
      
      private var _bag:BagInfo;
      
      private var _deputyWeaponID:int = 0;
      
      private var _webSpeed:int;
      
      private var _weaponID:int;
      
      protected var _buffInfo:DictionaryData;
      
      private var _pvePermission:String;
      
      public var _isDupSimpleTip:Boolean = false;
      
      private var _fightLibMission:String;
      
      private var _lastSpaDate:Object;
      
      private var _masterOrApprentices:DictionaryData;
      
      private var _masterID:int;
      
      private var _graduatesCount:int;
      
      private var _honourOfMaster:String = "";
      
      public var _freezesDate:Date;
      
      private var _myGiftData:Vector.<MyGiftCellInfo>;
      
      private var _charmLevel:int;
      
      private var _charmGP:int;
      
      private var _cardEquipDic:DictionaryData;
      
      private var _cardBagDic:DictionaryData;
      
      public var OptionOnOff:int;
      
      private var _shopFinallyGottenTime:Date;
      
      private var _lastDate:Date;
      
      private var _isSameCity:Boolean;
      
      public var _IsShowConsortia:Boolean;
      
      private var _badLuckNumber:int;
      
      protected var _isSelf:Boolean = false;
      
      protected var _pets:DictionaryData;
      
      private var _accumulativeLoginDays:int;
      
      private var _accumulativeAwardDays:int;
      
      private var _evolutionGrade:int;
      
      public var DungeonExpTotalNum:int;
      
      public var DungeonExpReceiveNum:int;
      
      private var _evolutionExp:int;
	  
	  private var _gemstoneList:Vector.<GemstonInitInfo>;
	  
	  private var _totemId:int;
	  
	  private var _necklaceExp:int;
	  
	  private var _necklaceLevel:int;
	  
	  private var _necklaceExpAdd:int;
	  
	  private var _ghostDic:Dictionary = null;
	  
	  private var _fineSuitExp:int;
      
      public function PlayerInfo()
      {
         this._buffInfo = new DictionaryData();
         super();
      }
      
      public function set IsShowNewTitle(param1:Boolean) : void
      {
         this._IsShowTitle = param1;
      }
      
      public function get IsShowNewTitle() : Boolean
      {
         return this._IsShowTitle;
      }
      
      public function get hardCurrency() : int
      {
         return this._hardCurrency;
      }
      
      public function set hardCurrency(param1:int) : void
      {
         if(this._hardCurrency == param1)
         {
            return;
         }
         this._hardCurrency = param1;
         onPropertiesChanged("hardCurrency");
      }
      
      override public function updateProperties() : void
      {
         if(_changedPropeties[ARM] || _changedPropeties[SEX] || _changedPropeties[STYLE] || _changedPropeties[HIDE] || _changedPropeties[SKIN] || _changedPropeties[COLORS] || _changedPropeties[NIMBUS])
         {
            this.parseHide();
            this.parseStyle();
            this.parseColos();
            this._showSuits = this._modifyStyle.split(",")[7].split("|")[0] != "13101" && this._modifyStyle.split(",")[7].split("|")[0] != "13201";
            _changedPropeties[PlayerInfo.STYLE] = true;
         }
         super.updateProperties();
      }
      
      private function parseHide() : void
      {
         this._hidehat = String(this._hide).charAt(8) == "2";
         this._hideGlass = String(this._hide).charAt(7) == "2";
         this._suitesHide = String(this._hide).charAt(6) == "2";
         this._wingHide = String(this._hide).charAt(5) == "2";
      }
      
      private function parseStyle() : void
      {
         var _loc3_:String = null;
         if(this._style == "")
         {
            this._style = ",,,,,,,,,";
         }
         var _loc1_:Array = this._style.split(",");
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = this.getTID(_loc1_[_loc2_]);
            if((_loc3_ == "" || _loc3_ == "0" || _loc3_ == "-1") && _loc2_ + 1 != EquipType.ARM && _loc2_ < 7)
            {
               _loc1_[_loc2_] = this.replaceTID(_loc1_[_loc2_],String(_loc2_ + 1) + (!!Sex ? "1" : "2") + "01");
            }
            else if((_loc3_ == "" || _loc3_ == "0" || _loc3_ == "-1") && _loc2_ + 1 == EquipType.ARM)
            {
               _loc1_[_loc2_] = this.replaceTID(_loc1_[_loc2_],"700" + (!!Sex ? "1" : "2"),false);
            }
            if((_loc3_ == "" || _loc3_ == "0" || _loc3_ == "-1") && _loc2_ == 7)
            {
               _loc1_[_loc2_] = this.replaceTID(_loc1_[_loc2_],"13" + (!!Sex ? "1" : "2") + "01");
            }
            if((_loc3_ == "" || _loc3_ == "0" || _loc3_ == "-1") && _loc2_ == 8)
            {
               _loc1_[_loc2_] = this.replaceTID(_loc1_[_loc2_],"15001");
            }
            if((_loc3_ == "" || _loc3_ == "0" || _loc3_ == "-1") && _loc2_ == 9)
            {
               _loc1_[_loc2_] = this.replaceTID(_loc1_[_loc2_],"16000");
            }
            _loc2_++;
         }
         if(this._hidehat || this._hideGlass || this._suitesHide)
         {
            if(this._hidehat)
            {
               _loc1_[0] = this.replaceTID(_loc1_[0],"1" + (!!Sex ? "1" : "2") + "01");
            }
            if(this._hideGlass)
            {
               _loc1_[1] = this.replaceTID(_loc1_[1],"2" + (!!Sex ? "1" : "2") + "01");
            }
            if(this._suitesHide)
            {
               _loc1_[7] = this.replaceTID(_loc1_[7],"13" + (!!Sex ? "1" : "2") + "01");
            }
         }
         this._modifyStyle = _loc1_.join(",");
      }
      
      public function get lastLuckNum() : int
      {
         return this._lastLuckNum;
      }
      
      public function set lastLuckNum(param1:int) : void
      {
         if(this._lastLuckNum == param1)
         {
            return;
         }
         this._lastLuckNum = param1;
         onPropertiesChanged(PlayerPropertyType.LastLuckyNum);
      }
      
      public function get luckyNum() : int
      {
         return this._luckyNum;
      }
      
      public function set luckyNum(param1:int) : void
      {
         if(this._luckyNum == param1)
         {
            return;
         }
         this._luckyNum = param1;
      }
      
      public function get lastLuckyNumDate() : Date
      {
         return this._lastLuckyNumDate;
      }
      
      public function set lastLuckyNumDate(param1:Date) : void
      {
         if(this._lastLuckyNumDate == param1)
         {
            return;
         }
         this._lastLuckyNumDate = param1;
      }
      
      public function get attachtype() : int
      {
         return this._attachtype;
      }
      
      public function get attachvalue() : int
      {
         return this._attachvalue;
      }
      
      private function parseColos() : void
      {
         var _loc1_:Array = this._colors.split(",");
         var _loc2_:Array = _loc1_[EquipType.CategeryIdToPlace(EquipType.FACE)[0]].split("|");
         _loc1_[EquipType.CategeryIdToPlace(EquipType.FACE)[0]] = _loc2_[0] + "|" + this._skin + "|" + (_loc2_[2] == undefined ? "" : _loc2_[2]);
         _loc2_ = _loc1_[EquipType.CategeryIdToPlace(EquipType.CLOTH)[0]].split("|");
         _loc1_[EquipType.CategeryIdToPlace(EquipType.CLOTH)[0]] = _loc2_[0] + "|" + this._skin + "|" + (_loc2_[2] == undefined ? "" : _loc2_[2]);
         this._colors = _loc1_.join(",");
      }
      
      public function get Hide() : int
      {
         return this._hide;
      }
      
      public function set Hide(param1:int) : void
      {
         if(this._hide == param1)
         {
            return;
         }
         this._hide = param1;
         onPropertiesChanged("Hide");
      }
      
      public function getHatHide() : Boolean
      {
         return this._hidehat;
      }
      
      public function setHatHide(param1:Boolean) : void
      {
         this.Hide = int(String(this._hide).slice(0,8) + (!!param1 ? "2" : "1") + String(this._hide).slice(9));
      }
      
      public function getGlassHide() : Boolean
      {
         return this._hideGlass;
      }
      
      public function setGlassHide(param1:Boolean) : void
      {
         this.Hide = int(String(this._hide).slice(0,7) + (!!param1 ? "2" : "1") + String(this._hide).slice(8,9));
      }
      
      public function getSuitesHide() : Boolean
      {
         return this._suitesHide;
      }
      
      public function setSuiteHide(param1:Boolean) : void
      {
         this.Hide = int(String(this._hide).slice(0,6) + (!!param1 ? "2" : "1") + String(this._hide).slice(7,9));
      }
      
      public function getShowSuits() : Boolean
      {
         return this._showSuits;
      }
      
      public function get wingHide() : Boolean
      {
         return this._wingHide;
      }
      
      public function set wingHide(param1:Boolean) : void
      {
         this.Hide = int(String(this._hide).slice(0,5) + (!!param1 ? "2" : "1") + String(this._hide).slice(6,9));
      }
      
      public function set Nimbus(param1:int) : void
      {
         if(this._nimbus == param1)
         {
            return;
         }
         this._nimbus = param1;
         onPropertiesChanged("Nimbus");
      }
      
      public function get Nimbus() : int
      {
         return this._nimbus;
      }
      
      public function getHaveLight() : Boolean
      {
         if(this.Nimbus < 100)
         {
            return false;
         }
         if(this.Nimbus > 999)
         {
            return String(this.Nimbus).charAt(0) != "0" || String(this.Nimbus).charAt(1) != "0";
         }
         return String(this.Nimbus).charAt(0) != "0";
      }
      
      public function getHaveCircle() : Boolean
      {
         if(this.Nimbus == 0)
         {
            return false;
         }
         if(this.Nimbus > 999)
         {
            return String(this.Nimbus).charAt(2) != "0" || String(this.Nimbus).charAt(3) != "0";
         }
         if(this.Nimbus > 99)
         {
            return String(this.Nimbus).charAt(1) != "0" || String(this.Nimbus).charAt(2) != "0";
         }
         return String(this.Nimbus).charAt(0) != "0";
      }
      
      public function get Style() : String
      {
         if(this._style == null)
         {
            return null;
         }
         return this._modifyStyle;
      }
      
      public function set Style(param1:String) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this._style == param1)
         {
            return;
         }
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Array = param1.split(",");
         if(_loc2_.length < 10)
         {
            _loc4_ = 10 - _loc2_.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc2_.push("|");
               _loc5_++;
            }
            param1 = _loc2_.join(",");
         }
         var _loc3_:int = 0;
         while(_loc3_ < 10)
         {
            _loc3_++;
         }
         this._style = param1;
         onPropertiesChanged("Style");
      }
      
      public function getHairType() : int
      {
         return int(ItemManager.Instance.getTemplateById(this._modifyStyle.split(",")[EquipType.CategeryIdToPlace(EquipType.HEAD)[0]].split("|")[0]).Property1);
      }
      
      public function getSuitsType() : int
      {
         var _loc1_:int = int(ItemManager.Instance.getTemplateById(this._modifyStyle.split(",")[7].split("|")[0]).Property1);
         if(_loc1_)
         {
            return _loc1_;
         }
         return 2;
      }
      
      public function getPrivateStyle() : String
      {
         return this._style;
      }
      
      public function get TutorialProgress() : int
      {
         return this._tutorialProgress;
      }
      
      public function set TutorialProgress(param1:int) : void
      {
         if(this._tutorialProgress == param1)
         {
            return;
         }
         this._tutorialProgress = param1;
         onPropertiesChanged("TutorialProgress");
      }
      
      public function setPartStyle(param1:int, param2:int, param3:int = -1, param4:String = "", param5:Boolean = true) : void
      {
         if(this.Style == null)
         {
            return;
         }
         var _loc6_:Array = this._style.split(",");
         if(param1 == EquipType.ARM)
         {
            _loc6_[EquipType.CategeryIdToPlace(param1)[0]] = this.replaceTID(_loc6_[EquipType.CategeryIdToPlace(param1)[0]],param3 == -1 || param3 == 0 ? "700" + String(!!PlayerManager.Instance.Self.Sex ? "1" : "2") : String(param3),false);
         }
         else if(param1 == EquipType.SUITS)
         {
            _loc6_[7] = this.replaceTID(_loc6_[7],param3 == -1 || param3 == 0 ? String(param1) + "101" : String(param3));
         }
         else if(param1 == EquipType.WING)
         {
            _loc6_[8] = this.replaceTID(_loc6_[8],param3 == -1 || param3 == 0 ? "15001" : String(param3));
         }
         else
         {
            _loc6_[EquipType.CategeryIdToPlace(param1)[0]] = this.replaceTID(_loc6_[EquipType.CategeryIdToPlace(param1)[0]],param3 == -1 || param3 == 0 ? String(param1) + String(param2) + "01" : String(param3));
         }
         this._style = _loc6_.join(",");
         onPropertiesChanged("Style");
         this.setPartColor(param1,param4);
      }
      
      private function jionPic(param1:String, param2:String) : String
      {
         return param1 + "|" + param2;
      }
      
      private function getTID(param1:String) : String
      {
         return param1.split("|")[0];
      }
      
      private function replaceTID(param1:String, param2:String, param3:Boolean = true) : String
      {
         return param2 + "|" + (!!param3 ? ItemManager.Instance.getTemplateById(int(param2)).Pic : param1.split("|")[1]);
      }
      
      public function getPartStyle(param1:int) : int
      {
         return int(this.Style.split(",")[param1 - 1].split("|")[0]);
      }
      
      public function get Colors() : String
      {
         return this._colors;
      }
      
      public function set Colors(param1:String) : void
      {
         if(this._intuitionalColor == param1)
         {
            return;
         }
         this._intuitionalColor = param1;
         if(this.colorEqual(this._colors,param1))
         {
            return;
         }
         this._colors = param1;
         onPropertiesChanged("Colors");
      }
      
      private function colorEqual(param1:String, param2:String) : Boolean
      {
         if(param1 == param2)
         {
            return true;
         }
         var _loc3_:Array = param1.split(",");
         var _loc4_:Array = param2.split(",");
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(_loc5_ == 4)
            {
               if(_loc3_[_loc5_].split("|").length > 2)
               {
                  _loc3_[_loc5_] = _loc3_[_loc5_].split("|")[0] + "||" + _loc3_[_loc5_].split("|")[2];
               }
            }
            if(_loc3_[_loc5_] != _loc4_[_loc5_])
            {
               if(!((_loc3_[_loc5_] == "|" || _loc3_[_loc5_] == "||" || _loc3_[_loc5_] == "") && (_loc4_[_loc5_] == "|" || _loc4_[_loc5_] == "||" || _loc4_[_loc5_] == "")))
               {
                  return false;
               }
            }
            _loc5_++;
         }
         return true;
      }
      
      public function setPartColor(param1:int, param2:String) : void
      {
         var _loc3_:Array = this._colors.split(",");
         if(param1 != EquipType.SUITS)
         {
            _loc3_[EquipType.CategeryIdToPlace(param1)[0]] = param2;
         }
         this.Colors = _loc3_.join(",");
         onPropertiesChanged(PlayerInfo.COLORS);
      }
      
      public function getPartColor(param1:int) : String
      {
         var _loc2_:Array = this.Colors.split(",");
         return _loc2_[param1 - 1];
      }
      
      public function setSkinColor(param1:String) : void
      {
         this.Skin = param1;
      }
      
      public function set Skin(param1:String) : void
      {
         if(this._skin == param1)
         {
            return;
         }
         this._skin = param1;
         onPropertiesChanged("Colors");
      }
      
      public function get Skin() : String
      {
         return this.getSkinColor();
      }
      
      public function getSkinColor() : String
      {
         var _loc1_:Array = this.Colors.split(",");
         if(_loc1_[EquipType.CategeryIdToPlace(EquipType.FACE)[0]] == undefined)
         {
            return "";
         }
         var _loc2_:String = _loc1_[EquipType.CategeryIdToPlace(EquipType.FACE)[0]].split("|")[1];
         return _loc2_ == null ? "" : _loc2_;
      }
      
      public function clearColors() : void
      {
         this.Colors = ",,,,,,,,";
      }
      
      public function updateStyle(param1:Boolean, param2:int, param3:String, param4:String, param5:String) : void
      {
         beginChanges();
         Sex = param1;
         this.Hide = param2;
         this.Style = param3;
         this.Colors = param4;
         this.Skin = param5;
         commitChanges();
      }
      
      public function get paopaoType() : int
      {
         var _loc1_:String = this._style.split(",")[9].split("|")[0];
         _loc1_.slice(4);
         if(_loc1_ == null || _loc1_ == "" || _loc1_ == "0" || _loc1_ == "-1")
         {
            return 0;
         }
         return int(_loc1_.slice(3));
      }
      
      public function get Attack() : int
      {
         return this._attack;
      }
      
      public function set Attack(param1:int) : void
      {
         if(this._attack == param1)
         {
            return;
         }
         this._attack = param1;
         onPropertiesChanged("Attack");
      }
      
      public function set userGuildProgress(param1:int) : void
      {
         this._answerSite = param1;
         this.TutorialProgress = param1;
         NewHandGuideManager.Instance.progress = param1;
      }
      
      public function get userGuildProgress() : int
      {
         return this._answerSite;
      }
      
      public function get Defence() : int
      {
         return this._defence;
      }
      
      public function set Defence(param1:int) : void
      {
         if(this._defence == param1)
         {
            return;
         }
         this._defence = param1;
         onPropertiesChanged("Defence");
      }
      
      public function get Luck() : int
      {
         return this._luck;
      }
      
      public function set Luck(param1:int) : void
      {
         if(this._luck == param1)
         {
            return;
         }
         this._luck = param1;
         onPropertiesChanged("Luck");
      }
      
      public function get hp() : int
      {
         return this._hp;
      }
      
      public function set hp(param1:int) : void
      {
         if(this._hp != param1)
         {
            this.increaHP = param1 - this._hp;
         }
         this._hp = param1;
      }
      
      public function get Agility() : int
      {
         return this._agility;
      }
      
      public function set Agility(param1:int) : void
      {
         if(this._agility == param1)
         {
            return;
         }
         this._agility = param1;
         onPropertiesChanged("Agility");
      }
      
      public function setAttackDefenseValues(param1:int, param2:int, param3:int, param4:int) : void
      {
         this.Attack = param1;
         this.Defence = param2;
         this.Agility = param3;
         this.Luck = param4;
         onPropertiesChanged("setAttackDefenseValues");
      }
      
      public function get dungeonFlag() : Object
      {
         if(this._dungeonFlag == null)
         {
            this._dungeonFlag = new Object();
         }
         return this._dungeonFlag;
      }
      
      public function set dungeonFlag(param1:Object) : void
      {
         if(this._dungeonFlag == param1)
         {
            return;
         }
         this._dungeonFlag = param1;
      }
      
      public function get Bag() : BagInfo
      {
         if(this._bag == null)
         {
            this._bag = new BagInfo(BagInfo.EQUIPBAG,46);
         }
         return this._bag;
      }
      
      public function get DeputyWeapon() : InventoryItemInfo
      {
         var _loc1_:Array = this.Bag.findBodyThingByCategory(EquipType.OFFHAND).concat(this.Bag.findBodyThingByCategory(EquipType.TEMP_OFFHAND));
         if(_loc1_.length > 0)
         {
            return _loc1_[0] as InventoryItemInfo;
         }
         return null;
      }
      
      public function set DeputyWeaponID(param1:int) : void
      {
         if(this._deputyWeaponID == param1)
         {
            return;
         }
         this._deputyWeaponID = param1;
         onPropertiesChanged("DeputyWeaponID");
      }
      
      public function get DeputyWeaponID() : int
      {
         return this._deputyWeaponID;
      }
      
      public function get webSpeed() : int
      {
         return this._webSpeed;
      }
      
      public function set webSpeed(param1:int) : void
      {
         this._webSpeed = param1;
         dispatchEvent(new WebSpeedEvent(WebSpeedEvent.STATE_CHANE));
      }
      
      public function get WeaponID() : int
      {
         return this._weaponID;
      }
      
      public function set WeaponID(param1:int) : void
      {
         if(this._weaponID == param1)
         {
            return;
         }
         this._weaponID = param1;
         onPropertiesChanged("WeaponID");
      }
      
      public function set paopaoType(param1:int) : void
      {
         this._paopaoType = param1;
         onPropertiesChanged("paopaoType");
      }
      
      public function get buffInfo() : DictionaryData
      {
         return this._buffInfo;
      }
      
      protected function set buffInfo(param1:DictionaryData) : void
      {
         this._buffInfo = param1;
         onPropertiesChanged("buffInfo");
      }
      
      public function addBuff(param1:BuffInfo) : void
      {
         this._buffInfo.add(param1.Type,param1);
      }
      
      public function clearBuff() : void
      {
         this._buffInfo.clear();
      }
      
      public function hasBuff(param1:int) : Boolean
      {
         if(param1 == BuffInfo.FREE)
         {
            return true;
         }
         var _loc2_:BuffInfo = this.getBuff(param1);
         return _loc2_ != null && _loc2_.IsExist;
      }
      
      public function getBuff(param1:int) : BuffInfo
      {
         return this._buffInfo[param1];
      }
      
      public function get PvePermission() : String
      {
         return this._pvePermission;
      }
      
      public function set PvePermission(param1:String) : void
      {
         if(this._pvePermission == param1)
         {
            return;
         }
         if(param1 == "")
         {
            this._pvePermission = "11111111111111111111111111111111111111111111111111";
         }
         else
         {
            if(this._pvePermission != null)
            {
               if(this._pvePermission.substr(0,1) == "1" && param1.substr(0,1) == "3")
               {
                  this._isDupSimpleTip = true;
               }
            }
            this._pvePermission = param1;
         }
         onPropertiesChanged("PvePermission");
      }
      
      public function get fightLibMission() : String
      {
         return this._fightLibMission == null || this._fightLibMission == "" ? "0000000000" : this._fightLibMission;
      }
      
      public function set fightLibMission(param1:String) : void
      {
         this._fightLibMission = param1;
         onPropertiesChanged("fightLibMission");
      }
      
      public function get LastSpaDate() : Object
      {
         return this._lastSpaDate;
      }
      
      public function set LastSpaDate(param1:Object) : void
      {
         this._lastSpaDate = param1;
      }
      
      public function setMasterOrApprentices(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         if(!this._masterOrApprentices)
         {
            this._masterOrApprentices = new DictionaryData();
         }
         this._masterOrApprentices.clear();
         if(param1 != "")
         {
            _loc2_ = param1.split(",");
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_].split("|");
               this._masterOrApprentices.add(int(_loc4_[0]),_loc4_[1]);
               _loc3_++;
            }
         }
         onPropertiesChanged("masterOrApprentices");
      }
      
      public function getMasterOrApprentices() : DictionaryData
      {
         if(!this._masterOrApprentices)
         {
            this._masterOrApprentices = new DictionaryData();
         }
         return this._masterOrApprentices;
      }
      
      public function set masterID(param1:int) : void
      {
         this._masterID = param1;
      }
      
      public function get masterID() : int
      {
         return this._masterID;
      }
      
      public function isMyMaster(param1:int) : Boolean
      {
         return param1 == this._masterID;
      }
      
      public function isMyApprent(param1:int) : Boolean
      {
         return this._masterOrApprentices[param1];
      }
      
      public function set graduatesCount(param1:int) : void
      {
         this._graduatesCount = param1;
      }
      
      public function get graduatesCount() : int
      {
         return this._graduatesCount;
      }
      
      public function set honourOfMaster(param1:String) : void
      {
         this._honourOfMaster = param1;
      }
      
      public function get honourOfMaster() : String
      {
         return this._honourOfMaster;
      }
      
      public function set freezesDate(param1:Date) : void
      {
         this._freezesDate = param1;
      }
      
      public function get freezesDate() : Date
      {
         return this._freezesDate;
      }
      
      public function set myGiftData(param1:Vector.<MyGiftCellInfo>) : void
      {
         this._myGiftData = param1;
         onPropertiesChanged("myGiftData");
      }
      
      public function get myGiftData() : Vector.<MyGiftCellInfo>
      {
         if(this._myGiftData == null)
         {
            this._myGiftData = new Vector.<MyGiftCellInfo>();
         }
         return this._myGiftData;
      }
      
      public function get giftSum() : int
      {
         var _loc2_:MyGiftCellInfo = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.myGiftData)
         {
            _loc1_ += _loc2_.amount;
         }
         return _loc1_;
      }
      
      public function set charmLevel(param1:int) : void
      {
         this._charmLevel = param1;
         onPropertiesChanged("GiftLevel");
      }
      
      public function get charmLevel() : int
      {
         if(this.charmGP <= 0)
         {
            return 1;
         }
         return this._charmLevel;
      }
      
      public function set charmGP(param1:int) : void
      {
         this._charmGP = param1;
         this.charmLevel = this.getCharLevel(param1);
         onPropertiesChanged("GiftGp");
      }
      
      private function getCharLevel(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < CHARM_LEVEL_ALL_EXP.length)
         {
            if(param1 >= CHARM_LEVEL_ALL_EXP[MAX_CHARM_LEVEL - 1])
            {
               _loc2_ = MAX_CHARM_LEVEL;
               break;
            }
            if(param1 < CHARM_LEVEL_ALL_EXP[_loc3_])
            {
               _loc2_ = _loc3_;
               break;
            }
            if(param1 <= 0)
            {
               _loc2_ = 1;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get charmGP() : int
      {
         return this._charmGP;
      }
      
      public function get cardEquipDic() : DictionaryData
      {
         if(this._cardEquipDic == null)
         {
            this._cardEquipDic = new DictionaryData();
         }
         return this._cardEquipDic;
      }
      
      public function set cardEquipDic(param1:DictionaryData) : void
      {
         if(this._cardEquipDic == param1)
         {
            return;
         }
         this._cardEquipDic = param1;
         onPropertiesChanged("cardEquipDic");
      }
      
      public function get cardBagDic() : DictionaryData
      {
         if(this._cardBagDic == null)
         {
            this._cardBagDic = new DictionaryData();
         }
         return this._cardBagDic;
      }
      
      public function set cardBagDic(param1:DictionaryData) : void
      {
         if(this._cardBagDic == param1)
         {
            return;
         }
         this._cardBagDic = param1;
         onPropertiesChanged("cardBagDic");
      }
      
      public function getOptionState(param1:int) : Boolean
      {
         return (this.OptionOnOff & param1) == param1;
      }
      
      public function get shopFinallyGottenTime() : Date
      {
         return this._shopFinallyGottenTime;
      }
      
      public function set shopFinallyGottenTime(param1:Date) : void
      {
         if(this._shopFinallyGottenTime == param1)
         {
            return;
         }
         this._shopFinallyGottenTime = param1;
         dispatchEvent(new Event(UPDATE_SHOP_FINALLY_TIME));
      }
      
      public function getLastDate() : int
      {
         var _loc1_:int = 0;
         var _loc2_:Date = TimeManager.Instance.Now();
         var _loc3_:int = (_loc2_.valueOf() - this._lastDate.valueOf()) / 3600000;
         return int(_loc3_ < 1 ? int(int(1)) : int(int(_loc3_)));
      }
      
      public function set lastDate(param1:Date) : void
      {
         this._lastDate = param1;
      }
      
      public function get lastDate() : Date
      {
         return this._lastDate;
      }
      
      public function get isSameCity() : Boolean
      {
         return this._isSameCity;
      }
      
      public function set isSameCity(param1:Boolean) : void
      {
         this._isSameCity = param1;
      }
      
      public function set IsShowConsortia(param1:Boolean) : void
      {
         this._IsShowConsortia = param1;
      }
      
      public function get IsShowConsortia() : Boolean
      {
         return this._IsShowConsortia;
      }
      
      public function get showDesignation() : String
      {
         var _loc1_:String = !!this.IsShowConsortia ? ConsortiaName : honor;
         if(!_loc1_)
         {
            _loc1_ = ConsortiaName;
         }
         if(!_loc1_)
         {
            _loc1_ = honor;
         }
         return _loc1_;
      }
      
      public function get badLuckNumber() : int
      {
         return this._badLuckNumber;
      }
      
      public function set badLuckNumber(param1:int) : void
      {
         if(this._badLuckNumber != param1)
         {
            this._badLuckNumber = param1;
            onPropertiesChanged("BadLuckNumber");
         }
      }
	  
	  private var _damageScores:int = 0;
	  
	  public function set damageScores(param1:int) : void
	  {
		  this._damageScores = param1;
	  }
	  
	  public function get damageScores() : int
	  {
		  return this._damageScores;
	  }
      
      public function shouldShowAcademyIcon() : Boolean
      {
         if(apprenticeshipState == AcademyManager.NONE_STATE && (Grade < AcademyManager.TARGET_PLAYER_MIN_LEVEL || AcademyManager.Instance.isOpenSpace(this)))
         {
            return false;
         }
         return true;
      }
      
      public function get isSelf() : Boolean
      {
         return this._isSelf;
      }
      
      public function get pets() : DictionaryData
      {
         if(this._pets == null)
         {
            this._pets = new DictionaryData();
         }
         return this._pets;
      }
      
      public function get currentPet() : PetInfo
      {
         var _loc2_:PetInfo = null;
         var _loc1_:PetInfo = null;
         for each(_loc2_ in this._pets)
         {
            if(_loc2_.IsEquip)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function get evolutionGrade() : int
      {
         return this._evolutionGrade;
      }
      
      public function set evolutionGrade(param1:int) : void
      {
         this._evolutionGrade = param1;
      }
      
      public function get accumulativeLoginDays() : int
      {
         return this._accumulativeLoginDays;
      }
      
      public function set accumulativeLoginDays(param1:int) : void
      {
         this._accumulativeLoginDays = param1;
      }
      
      public function get accumulativeAwardDays() : int
      {
         return this._accumulativeAwardDays;
      }
      
      public function set accumulativeAwardDays(param1:int) : void
      {
         this._accumulativeAwardDays = param1;
      }
      
      public function get evolutionExp() : int
      {
         return this._evolutionExp;
      }
      
      public function set evolutionExp(param1:int) : void
      {
         this._evolutionExp = param1;
      }
	  
	  public function set gemstoneList(param1:Vector.<GemstonInitInfo>) : void
	  {
		  this._gemstoneList = param1;
	  }
	  
	  public function get gemstoneList() : Vector.<GemstonInitInfo>
	  {
		  return this._gemstoneList;
	  }
	  
	  public function get totemId() : int
	  {
		  return this._totemId;
	  }
	  
	  public function set totemId(param1:int) : void
	  {
		  this._totemId = param1;
	  }
	  
	  public function get necklaceExp() : int
	  {
		  return this._necklaceExp;
	  }
	  
	  public function set necklaceExp(param1:int) : void
	  {
		  this._necklaceExp = param1;
		  this.necklaceLevel = StoreEquipExperience.getNecklaceLevelByGP(this._necklaceExp);
		  onPropertiesChanged("necklaceExp");
	  }
	  
	  public function get necklaceLevel() : int
	  {
		  return this._necklaceLevel;
	  }
	  
	  public function set necklaceLevel(param1:int) : void
	  {
		  this._necklaceLevel = param1;
		  onPropertiesChanged("necklaceLevel");
	  }
	  
	  public function get necklaceExpAdd() : int
	  {
		  return this._necklaceExpAdd;
	  }
	  
	  public function set necklaceExpAdd(param1:int) : void
	  {
		  this._necklaceExpAdd = param1;
		  onPropertiesChanged("necklaceExpAdd");
	  }
	  
	  public function addGhostData(param1:EquipGhostData) : void
	  {
		  if(this._ghostDic == null)
		  {
			  this._ghostDic = new Dictionary(true);
		  }
		  this._ghostDic[param1.categoryID] = param1;
	  }
	  
	  public function getGhostData(param1:int, param2:int) : EquipGhostData
	  {
		  var _loc3_:int = BagInfo.parseCategoryID(param1,param2);
		  return this.getGhostDataByCategoryID(_loc3_);
	  }
	  
	  public function getGhostDataByCategoryID(param1:int) : EquipGhostData
	  {
		  if(this._ghostDic == null)
		  {
			  return null;
		  }
		  if(param1 == 27)
		  {
			  param1 = 7;
		  }
		  return this._ghostDic[param1];
	  }
	  
	  public function get fineSuitExp() : int
	  {
		  return this._fineSuitExp;
	  }
	  
	  public function set fineSuitExp(param1:int) : void
	  {
		  if(this._fineSuitExp == param1)
		  {
			  return;
		  }
		  this._fineSuitExp = param1;
	  }
   }
}
