package totem
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.Experience;
   import ddt.data.UIModuleTypes;
   import ddt.manager.PlayerManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   import totem.data.TotemAddInfo;
   import totem.data.TotemDataAnalyz;
   import totem.data.TotemDataVo;
   
   public class TotemManager extends EventDispatcher
   {
      
      private static var _instance:TotemManager;
       
      
      public var isBindInNoPrompt:Boolean;
      
      public var isDonotPromptActPro:Boolean;
      
      public var isSelectedActPro:Boolean;
      
      private var _dataList:Object;
      
      private var _dataList2:Object;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      public function TotemManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : TotemManager
      {
         if(_instance == null)
         {
            _instance = new TotemManager();
         }
         return _instance;
      }
      
      public function loadTotemModule(param1:Function = null, param2:Array = null) : void
      {
         this._func = param1;
         this._funcParams = param2;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.TOTEM);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.TOTEM)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.TOTEM)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
      
      public function setup(param1:TotemDataAnalyz) : void
      {
         this._dataList = param1.dataList;
         this._dataList2 = param1.dataList2;
      }
      
      public function getCurInfoByLevel(param1:int) : TotemDataVo
      {
         return this._dataList2[param1];
      }
      
      public function getCurInfoById(param1:int) : TotemDataVo
      {
         if(param1 == 0)
         {
            return new TotemDataVo();
         }
         return this._dataList[param1];
      }
      
      public function getNextInfoByLevel(param1:int) : TotemDataVo
      {
         return this._dataList2[param1 + 1];
      }
      
      public function getNextInfoById(param1:int) : TotemDataVo
      {
         var _loc2_:int = 0;
         if(param1 == 0)
         {
            _loc2_ = 0;
         }
         else
         {
            _loc2_ = this._dataList[param1].Point;
         }
         return this._dataList2[_loc2_ + 1];
      }
      
      public function getAddInfo(param1:int, param2:int = 1) : TotemAddInfo
      {
         var _loc3_:TotemDataVo = null;
         var _loc4_:TotemAddInfo = new TotemAddInfo();
         for each(_loc3_ in this._dataList)
         {
            if(_loc3_.Point <= param1 && _loc3_.Point >= param2)
            {
               _loc4_.Agility += _loc3_.AddAgility;
               _loc4_.Attack += _loc3_.AddAttack;
               _loc4_.Blood += _loc3_.AddBlood;
               _loc4_.Damage += _loc3_.AddDamage;
               _loc4_.Defence += _loc3_.AddDefence;
               _loc4_.Guard += _loc3_.AddGuard;
               _loc4_.Luck += _loc3_.AddLuck;
            }
         }
         return _loc4_;
      }
      
      public function getTotemPointLevel(param1:int) : int
      {
         if(param1 == 0)
         {
            return 0;
         }
         return this._dataList[param1].Point;
      }
      
      public function get usableGP() : int
      {
         return PlayerManager.Instance.Self.GP - Experience.expericence[PlayerManager.Instance.Self.Grade - 1];
      }
      
      public function getCurrentLv(param1:int) : int
      {
         return int(param1 / 7);
      }
      
      public function updatePropertyAddtion(param1:int, param2:DictionaryData) : void
      {
         if(!param2["Attack"])
         {
            return;
         }
         var _loc3_:TotemAddInfo = this.getAddInfo(this.getCurInfoById(param1).Point);
         param2["Attack"]["Totem"] = _loc3_.Attack;
         param2["Defence"]["Totem"] = _loc3_.Defence;
         param2["Agility"]["Totem"] = _loc3_.Agility;
         param2["Luck"]["Totem"] = _loc3_.Luck;
         param2["HP"]["Totem"] = _loc3_.Blood;
         param2["Damage"]["Totem"] = _loc3_.Damage;
         param2["Armor"]["Totem"] = _loc3_.Guard;
      }
      
      public function getSamePageLocationList(param1:int, param2:int) : Array
      {
         var _loc3_:TotemDataVo = null;
         var _loc4_:Array = [];
         for each(_loc3_ in this._dataList)
         {
            if(_loc3_.Page == param1 && _loc3_.Location == param2)
            {
               _loc4_.push(_loc3_);
            }
         }
         _loc4_.sortOn("Layers",Array.NUMERIC);
         return _loc4_;
      }
   }
}
