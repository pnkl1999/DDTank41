package store.equipGhost
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CEvent;
   import ddt.events.PkgEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.StaticFormula;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   import road7th.comm.PackageIn;
   import store.equipGhost.data.EquipGhostData;
   import store.equipGhost.data.GhostData;
   import store.equipGhost.data.GhostDataAnalyzer;
   import store.equipGhost.data.GhostModel;
   import store.equipGhost.data.GhostPropertyData;
   
   public class EquipGhostManager extends EventDispatcher
   {
      
      private static const _TIME:uint = 1;
      
      private static const _WAIT_TIME:Number = 1000;
      
      private static var _instance:EquipGhostManager;
       
      
      private var _model:GhostModel;
      
      private var _equip:InventoryItemInfo;
      
      private var _luckyMaterial:InventoryItemInfo;
      
      private var _stoneMaterial:InventoryItemInfo;
      
      private var _protectedID:uint;
      
      private var _lastTime:Number = 0;
      
      public function EquipGhostManager(param1:SingleTon)
      {
         super();
         if(!param1)
         {
            throw new Error("this is a single instance");
         }
         this.init();
      }
      
      public static function getInstance() : EquipGhostManager
      {
         _instance = _instance || new EquipGhostManager(new SingleTon());
         return _instance;
      }
      
      private function init() : void
      {
         this.initData();
         this.initEvent();
      }
      
      private function initData() : void
      {
         this._model = new GhostModel();
      }
      
      public function initEvent() : void
      {
         SocketManager.Instance.addEventListener(PkgEvent.format(391),this.__equipGhost);
         SocketManager.Instance.addEventListener(PkgEvent.format(392),this.__syncEquipGhost);
      }
      
      public function analyzerCompleteHandler(param1:GhostDataAnalyzer) : void
      {
         this._model.initModel(param1.data);
      }
      
      public function get model() : GhostModel
      {
         return this._model;
      }
      
      public function chooseEquip(param1:InventoryItemInfo) : void
      {
         this._equip = param1;
         if(this._equip != null)
         {
            this.calulateRatio();
         }
      }
      
      public function clearEquip() : void
      {
         this._equip = null;
      }
      
      public function isGhostEquip(param1:Number) : Boolean
      {
         if(this._equip != null && this._equip.ItemID == param1)
         {
            return true;
         }
         return false;
      }
      
      public function isEquipGhosting() : Boolean
      {
         return this._equip != null;
      }
      
      public function getGhostEquipPlace() : int
      {
         var _loc1_:* = null;
         if(this._equip != null)
         {
            _loc1_ = this.model.getGhostData(this._equip.CategoryID,1);
            if(_loc1_ == null)
            {
               return -1;
            }
            return _loc1_.place;
         }
         return -1;
      }
      
      public function chooseLuckyMaterial(param1:InventoryItemInfo) : void
      {
         this._luckyMaterial = param1;
         this.calulateRatio();
      }
      
      public function chooseStoneMaterial(param1:InventoryItemInfo) : void
      {
         this._stoneMaterial = param1;
         this.calulateRatio();
      }
      
      private function calulateRatio() : void
      {
         var _loc1_:* = null;
         var _loc2_:Number = NaN;
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         if(this._stoneMaterial && this._equip)
         {
            _loc4_ = (_loc1_ = PlayerManager.Instance.Self.getGhostDataByCategoryID(this._equip.CategoryID)) == null ? int(0) : int(_loc1_.level);
            _loc2_ = this._luckyMaterial == null ? Number(1) : Number(Number(1 + parseFloat(this._luckyMaterial.Property2) / 100));
            _loc3_ = Number(5 * Math.pow(2,Math.pow(2,this._stoneMaterial.Level - 1) + 2 - _loc4_) * _loc2_);
         }
         _loc3_ = Number(Math.min(100,_loc3_));
         dispatchEvent(new CEvent("equip_ghost_ratio",uint(_loc3_)));
      }
      
      public function checkEquipGhost() : Boolean
      {
         if(this._equip == null)
         {
            return false;
         }
         var _loc1_:EquipGhostData = PlayerManager.Instance.Self.getGhostDataByCategoryID(this._equip.CategoryID);
         if(!_loc1_)
         {
            return this._stoneMaterial != null;
         }
         if(_loc1_.level < this._model.topLvDic[this._equip.CategoryID])
         {
            return true;
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("equipGhost.upLevel"));
         return false;
      }
      
      public function getPorpertyData(param1:InventoryItemInfo, param2:PlayerInfo = null) : GhostPropertyData
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = NaN;
         var _loc6_:* = null;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc11_:* = null;
         if(param1 == null)
         {
            return null;
         }
         param2 = param2 || PlayerManager.Instance.Self;
         var _loc12_:EquipGhostData = param2.getGhostDataByCategoryID(param1.CategoryID);
         var _loc13_:* = 0;
         if(param1.StrengthenLevel > 0)
         {
            _loc3_ = uint(!!param1.isGold ? param1.StrengthenLevel + 1 : param1.StrengthenLevel);
            _loc13_ = Number(StaticFormula.getHertAddition(int(param1.Property7),_loc3_));
         }
         var _loc14_:uint = parseInt(param1.Property7) + _loc13_;
         var _loc15_:uint = 0;
         if(_loc12_)
         {
            _loc4_ = uint(param1.Property7);
            _loc5_ = 0;
            if(param1.CategoryID == 7)
            {
               _loc5_ = Number(_loc4_ / 200 * Math.pow(_loc12_.level,1.2) / 100);
            }
            else if(param1.CategoryID == 1 || param1.CategoryID == 5)
            {
               _loc5_ = Number(_loc4_ / 60 * Math.pow(_loc12_.level,1.2) / 100);
            }
            _loc15_ = _loc5_ * _loc14_;
            _loc6_ = this.model.getGhostData(_loc12_.categoryID,_loc12_.level);
            _loc7_ = uint(0);
            _loc8_ = uint(0);
            _loc9_ = uint(0);
            _loc10_ = uint(0);
            if(_loc6_)
            {
               _loc11_ = ItemManager.Instance.getTemplateById(param1.TemplateID);
               _loc7_ = uint(_loc11_.Attack * _loc6_.attackAdd / 1000);
               _loc8_ = uint(_loc11_.Luck * _loc6_.luckAdd / 1000);
               _loc9_ = uint(_loc11_.Defence * _loc6_.defendAdd / 1000);
               _loc10_ = uint(_loc11_.Agility * _loc6_.agilityAdd / 1000);
            }
            return new GhostPropertyData(_loc15_,_loc7_,_loc8_,_loc9_,_loc10_);
         }
         return null;
      }
      
      public function getPropertyDataByLv(param1:InventoryItemInfo, param2:int) : GhostPropertyData
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         if(param1 == null || param2 < 0)
         {
            return null;
         }
         if(param2 == 0)
         {
            return new GhostPropertyData(0,0,0,0,0);
         }
         var _loc5_:* = 0;
         if(param1.StrengthenLevel > 0)
         {
            _loc3_ = uint(!!param1.isGold ? param1.StrengthenLevel + 1 : param1.StrengthenLevel);
            _loc5_ = Number(StaticFormula.getHertAddition(int(param1.Property7),_loc3_));
         }
         var _loc6_:uint = parseInt(param1.Property7) + _loc5_;
         var _loc7_:uint = 0;
         var _loc8_:uint = parseInt(param1.Property7);
         var _loc9_:* = 0;
         if(param1.CategoryID == 7)
         {
            _loc9_ = Number(_loc8_ / 200 * Math.pow(param2,1.2) / 100);
         }
         else if(param1.CategoryID == 1 || param1.CategoryID == 5)
         {
            _loc9_ = Number(_loc8_ / 60 * Math.pow(param2,1.2) / 100);
         }
         _loc7_ = _loc9_ * _loc6_;
         var _loc10_:GhostData = this.model.getGhostData(param1.CategoryID,param2);
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         if(_loc10_)
         {
            _loc4_ = ItemManager.Instance.getTemplateById(param1.TemplateID);
            _loc11_ = _loc4_.Attack * _loc10_.attackAdd / 1000;
            _loc12_ = _loc4_.Luck * _loc10_.luckAdd / 1000;
            _loc13_ = _loc4_.Defence * _loc10_.defendAdd / 1000;
            _loc14_ = _loc4_.Agility * _loc10_.agilityAdd / 1000;
         }
         return new GhostPropertyData(_loc7_,_loc11_,_loc12_,_loc13_,_loc14_);
      }
      
      public function requestEquipGhost() : void
      {
         if(getTimer() - this._lastTime < 1000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
         }
         else if(this.checkEquipGhost())
         {
            SocketManager.Instance.out.sendEquipGhost();
            this._lastTime = getTimer();
         }
      }
      
      private function __equipGhost(param1:PkgEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         dispatchEvent(new CEvent("equip_ghost_result",_loc2_));
         if(this._equip != null)
         {
            this.calulateRatio();
         }
      }
      
      private function __syncEquipGhost(param1:PkgEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:EquipGhostData = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc6_ = _loc3_.readInt();
            _loc7_ = _loc3_.readInt();
            (_loc5_ = new EquipGhostData(_loc6_,_loc7_)).level = _loc3_.readInt();
            _loc5_.totalGhost = _loc3_.readInt();
            PlayerManager.Instance.Self.addGhostData(_loc5_);
            _loc2_++;
         }
      }
   }
}

class SingleTon
{
    
   
   function SingleTon()
   {
      super();
   }
}
