package texpSystem.controller
{
   import ddt.data.analyze.TexpExpAnalyze;
   import ddt.data.player.SelfInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import texpSystem.TexpEvent;
   import texpSystem.data.TexpExp;
   import texpSystem.data.TexpInfo;
   import texpSystem.data.TexpType;
   
   public class TexpManager extends EventDispatcher
   {
      
      private static const MAX_LV:int = 55;
      
      private static var _instance:TexpManager;
       
      
      private var _texpExp:Dictionary;
      
      public function TexpManager(param1:TexpManagerEnforcer)
      {
         super();
      }
      
      public static function get Instance() : TexpManager
      {
         if(!_instance)
         {
            _instance = new TexpManager(new TexpManagerEnforcer());
         }
         return _instance;
      }
      
      public function setup(param1:TexpExpAnalyze) : void
      {
         this._texpExp = param1.list;
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onChange);
      }
      
      public function getLv(param1:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:TexpExp = null;
         var _loc2_:int = 1;
         while(_loc2_ <= MAX_LV)
         {
            _loc4_ = this._texpExp[_loc2_];
            if(param1 < _loc4_.GP)
            {
               break;
            }
            _loc3_ = _loc2_;
            _loc2_++;
         }
         return _loc3_;
      }
      
      public function getInfo(param1:int, param2:int) : TexpInfo
      {
         var _loc3_:TexpInfo = new TexpInfo();
         var _loc4_:int = this.getLv(param2);
         _loc3_.type = param1;
         _loc3_.lv = _loc4_;
         if(_loc4_ == 0)
         {
            _loc3_.currExp = param2;
            _loc3_.currEffect = 0;
            _loc3_.upExp = this._texpExp[1].GP;
            _loc3_.upEffect = this.getEffect(param1,this._texpExp[_loc4_ + 1]);
         }
         else if(_loc4_ == MAX_LV)
         {
            _loc3_.currExp = 0;
            _loc3_.currEffect = this.getEffect(param1,this._texpExp[_loc4_]);
            _loc3_.upExp = 0;
            _loc3_.upEffect = 0;
         }
         else
         {
            _loc3_.currExp = param2 - this._texpExp[_loc4_].GP;
            _loc3_.currEffect = this.getEffect(param1,this._texpExp[_loc4_]);
            _loc3_.upExp = this._texpExp[_loc4_ + 1].GP - this._texpExp[_loc4_].GP;
            _loc3_.upEffect = this.getEffect(param1,this._texpExp[_loc4_ + 1]);
         }
         return _loc3_;
      }
      
      public function getName(param1:int) : String
      {
         switch(param1)
         {
            case TexpType.HP:
               return LanguageMgr.GetTranslation("texpSystem.view.TexpView.hp");
            case TexpType.ATT:
               return LanguageMgr.GetTranslation("texpSystem.view.TexpView.att");
            case TexpType.DEF:
               return LanguageMgr.GetTranslation("texpSystem.view.TexpView.def");
            case TexpType.SPD:
               return LanguageMgr.GetTranslation("texpSystem.view.TexpView.spd");
            case TexpType.LUK:
               return LanguageMgr.GetTranslation("texpSystem.view.TexpView.luk");
            default:
               return "";
         }
      }
      
      public function getExp(param1:int) : int
      {
         var _loc2_:SelfInfo = PlayerManager.Instance.Self;
         switch(param1)
         {
            case TexpType.HP:
               return _loc2_.hpTexpExp;
            case TexpType.ATT:
               return _loc2_.attTexpExp;
            case TexpType.DEF:
               return _loc2_.defTexpExp;
            case TexpType.SPD:
               return _loc2_.spdTexpExp;
            case TexpType.LUK:
               return _loc2_.lukTexpExp;
            default:
               return 0;
         }
      }
      
      private function getEffect(param1:int, param2:TexpExp) : int
      {
         switch(param1)
         {
            case TexpType.HP:
               return param2.ExerciseH;
            case TexpType.ATT:
               return param2.ExerciseA;
            case TexpType.DEF:
               return param2.ExerciseD;
            case TexpType.SPD:
               return param2.ExerciseAG;
            case TexpType.LUK:
               return param2.ExerciseL;
            default:
               return 0;
         }
      }
      
      private function isUp(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = this.getExp(param1);
         if(this.getLv(_loc3_) > this.getLv(param2))
         {
            return true;
         }
         return false;
      }
      
      private function __onChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["hpTexpExp"])
         {
            dispatchEvent(new TexpEvent(TexpEvent.TEXP_HP));
            if(this.isUp(TexpType.HP,param1.lastValue["hpTexpExp"]))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpView.up",this.getName(TexpType.HP)));
            }
         }
         if(param1.changedProperties["attTexpExp"])
         {
            dispatchEvent(new TexpEvent(TexpEvent.TEXP_ATT));
            if(this.isUp(TexpType.ATT,param1.lastValue["attTexpExp"]))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpView.up",this.getName(TexpType.ATT)));
            }
         }
         if(param1.changedProperties["defTexpExp"])
         {
            dispatchEvent(new TexpEvent(TexpEvent.TEXP_DEF));
            if(this.isUp(TexpType.DEF,param1.lastValue["defTexpExp"]))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpView.up",this.getName(TexpType.DEF)));
            }
         }
         if(param1.changedProperties["spdTexpExp"])
         {
            dispatchEvent(new TexpEvent(TexpEvent.TEXP_SPD));
            if(this.isUp(TexpType.SPD,param1.lastValue["spdTexpExp"]))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpView.up",this.getName(TexpType.SPD)));
            }
         }
         if(param1.changedProperties["lukTexpExp"])
         {
            dispatchEvent(new TexpEvent(TexpEvent.TEXP_LUK));
            if(this.isUp(TexpType.LUK,param1.lastValue["lukTexpExp"]))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpView.up",this.getName(TexpType.LUK)));
            }
         }
      }
   }
}

class TexpManagerEnforcer
{
    
   
   function TexpManagerEnforcer()
   {
      super();
   }
}
