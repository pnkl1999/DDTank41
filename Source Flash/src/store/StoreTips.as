package store
{
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.utils.StaticFormula;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class StoreTips extends Sprite implements Disposeable
   {
      
      public static const TRANSFER:int = 0;
      
      public static const EMBED:int = 1;
      
      public static const BEGIN_Y:int = 130;
      
      public static const SPACING:String = " ";
      
      public static const SPACINGII:String = " +";
      
      public static const SPACINGIII:String = " ";
      
      public static const Shield:int = 31;
       
      
      private var _timer:Timer;
      
      private var _successBit:Bitmap;
      
      private var _failBit:Bitmap;
      
      private var _fiveFailBit:Bitmap;
      
      private var _changeTxtI:FilterFrameText;
      
      private var _changeTxtII:FilterFrameText;
      
      private var _moveSprite:Sprite;
      
      public var isDisplayerTip:Boolean = true;
      
      private var _lastTipString:String = "";
      
      public function StoreTips()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._successBit = ComponentFactory.Instance.creatBitmap("store.StoreIISuccessBitAsset");
         this._failBit = ComponentFactory.Instance.creatBitmap("store.StoreIIFailBitAsset");
         this._fiveFailBit = ComponentFactory.Instance.creatBitmap("store.StoreIIFiveFailBitAsset");
         this._changeTxtI = ComponentFactory.Instance.creatComponentByStylename("store.storeTipTxt");
         this._changeTxtII = ComponentFactory.Instance.creatComponentByStylename("store.storeTipTxt");
         this._moveSprite = new Sprite();
         addChild(this._moveSprite);
         this._timer = new Timer(7500,1);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
      }
      
      private function createTween(param1:Function = null, param2:Array = null) : void
      {
         MessageTipManager.getInstance().kill();
         TweenMax.killTweensOf(this._moveSprite);
         TweenMax.from(this._moveSprite,0.4,{
            "y":BEGIN_Y,
            "alpha":0
         });
         TweenMax.to(this._moveSprite,0.4,{
            "delay":1.4,
            "y":BEGIN_Y * -1,
            "alpha":0,
            "onComplete":(param1 == null ? this.removeTips : param1),
            "onCompleteParams":param2
         });
      }
      
      private function showPropertyChange(param1:InventoryItemInfo) : String
      {
         var _loc2_:Number = NaN;
         var _loc3_:String = "";
         var _loc4_:String = "";
         if(EquipType.isArm(param1))
         {
            _loc2_ = StaticFormula.getHertAddition(int(param1.Property7),param1.StrengthenLevel) - StaticFormula.getHertAddition(int(param1.Property7),param1.StrengthenLevel - 1);
            _loc3_ = LanguageMgr.GetTranslation("store.storeTip.hurt",SPACING,SPACINGII,_loc2_);
            _loc4_ = LanguageMgr.GetTranslation("store.storeTip.chatHurt",_loc2_);
         }
         else if(int(param1.Property3) == 32)
         {
            _loc2_ = StaticFormula.getRecoverHPAddition(int(param1.Property7),param1.StrengthenLevel) - StaticFormula.getRecoverHPAddition(int(param1.Property7),param1.StrengthenLevel - 1);
            _loc3_ = LanguageMgr.GetTranslation("store.storeTip.AddHP",SPACING,SPACINGII,_loc2_);
            _loc4_ = LanguageMgr.GetTranslation("store.storeTip.chatAddHP",_loc2_);
         }
         else if(int(param1.Property3) == Shield)
         {
            _loc2_ = StaticFormula.getDefenseAddition(int(param1.Property7),param1.StrengthenLevel) - StaticFormula.getDefenseAddition(int(param1.Property7),param1.StrengthenLevel - 1);
            _loc3_ = LanguageMgr.GetTranslation("store.storeTip.subHurt",SPACING,SPACINGII,_loc2_);
            _loc4_ = LanguageMgr.GetTranslation("store.storeTip.chatSubHurt",_loc2_);
         }
         else if(EquipType.isEquip(param1))
         {
            _loc2_ = StaticFormula.getDefenseAddition(int(param1.Property7),param1.StrengthenLevel) - StaticFormula.getDefenseAddition(int(param1.Property7),param1.StrengthenLevel - 1);
            _loc3_ = LanguageMgr.GetTranslation("store.storeTip.Armor",SPACING,SPACINGII,_loc2_);
            _loc4_ = LanguageMgr.GetTranslation("store.storeTip.chatArmor",_loc2_);
         }
         this._lastTipString += _loc3_;
         return _loc4_;
      }
      
      private function showHoleTip(param1:InventoryItemInfo) : String
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         this._changeTxtII.text = "";
         var _loc2_:String = "";
         var _loc3_:String = LanguageMgr.GetTranslation("store.storeTip.openHole");
         if(param1.CategoryID == EquipType.HEAD || param1.CategoryID == EquipType.CLOTH)
         {
            if(param1.StrengthenLevel == 3 || param1.StrengthenLevel == 9 || param1.StrengthenLevel == 12)
            {
               _loc3_ += SPACINGIII + LanguageMgr.GetTranslation("store.storeTip.weaponOpenProperty");
               _loc2_ = LanguageMgr.GetTranslation("store.storeTip.OpenProperty");
            }
            if(param1.StrengthenLevel == 6)
            {
               _loc3_ += SPACINGIII + LanguageMgr.GetTranslation("store.storeTip.clothOpenDefense");
               _loc2_ = LanguageMgr.GetTranslation("store.storeTip.OpenDefense");
            }
         }
         else if(param1.CategoryID == EquipType.ARM)
         {
            if(param1.StrengthenLevel == 6 || param1.StrengthenLevel == 9 || param1.StrengthenLevel == 12)
            {
               _loc3_ += SPACINGIII + LanguageMgr.GetTranslation("store.storeTip.weaponOpenProperty");
               _loc2_ = LanguageMgr.GetTranslation("store.storeTip.OpenProperty");
            }
            if(param1.StrengthenLevel == 3)
            {
               _loc3_ += SPACINGIII + LanguageMgr.GetTranslation("store.storeTip.weaponOpenAttack");
               _loc2_ = LanguageMgr.GetTranslation("store.storeTip.OpenAttack");
            }
         }
         if((param1.CategoryID == EquipType.HEAD || param1.CategoryID == EquipType.CLOTH || param1.CategoryID == EquipType.ARM) && (param1.StrengthenLevel == 3 || param1.StrengthenLevel == 6 || param1.StrengthenLevel == 9 || param1.StrengthenLevel == 12))
         {
            _loc4_ = param1.Hole.split("|");
            _loc5_ = param1.StrengthenLevel / 3;
            if(_loc4_[_loc5_ - 1].split(",")[1] > 0 && param1["Hole" + _loc5_] >= 0)
            {
               this._lastTipString += "\n" + _loc3_;
               return _loc2_;
            }
         }
         return null;
      }
      
      private function showOpenHoleTip(param1:InventoryItemInfo) : String
      {
         var _loc2_:String = LanguageMgr.GetTranslation("store.storeTip.openHole");
         return _loc2_ + (SPACINGIII + LanguageMgr.GetTranslation("store.storeTip.weaponOpenProperty"));
      }
      
      public function showSuccess(param1:int = -1) : void
      {
         this.removeTips();
         if(this.isDisplayerTip)
         {
            if(!this._moveSprite)
            {
               this._moveSprite = new Sprite();
               addChild(this._moveSprite);
            }
            this._moveSprite.addChild(this._successBit);
            this.createTween();
         }
         SoundManager.instance.pauseMusic();
         SoundManager.instance.play("063",false,false);
         this._timer.start();
         switch(param1)
         {
            case TRANSFER:
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("store.Transfer.Succes.ChatSay"));
               break;
            case EMBED:
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("store.Embed.Succes.ChatSay"));
         }
      }
      
      public function showStrengthSuccess(param1:InventoryItemInfo, param2:Boolean) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         this._lastTipString = "";
         this.removeTips();
         if(this.isDisplayerTip)
         {
            if(!this._moveSprite)
            {
               this._moveSprite = new Sprite();
               addChild(this._moveSprite);
            }
            this._moveSprite.addChild(this._successBit);
            _loc3_ = this.showPropertyChange(param1);
            _loc4_ = !!param2 ? this.showHoleTip(param1) : null;
            if(_loc4_)
            {
               _loc3_ = _loc3_.replace("!",",");
               _loc3_ += _loc4_;
            }
            this.createTween(this.strengthTweenComplete,[_loc3_]);
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("store.Strength.Succes.ChatSay") + _loc3_);
         }
         SoundManager.instance.pauseMusic();
         SoundManager.instance.play("063",false,false);
         this._timer.start();
      }
      
      private function strengthTweenComplete(param1:String) : void
      {
         if(param1)
         {
            MessageTipManager.getInstance().show(param1);
         }
         this.removeTips();
      }
      
      public function showEmbedSuccess(param1:InventoryItemInfo) : void
      {
         var _loc2_:String = null;
         this._lastTipString = "";
         if(this.isDisplayerTip)
         {
            if(!this._moveSprite)
            {
               this._moveSprite = new Sprite();
               addChild(this._moveSprite);
            }
            this._moveSprite.addChild(this._successBit);
            _loc2_ = this.showOpenHoleTip(param1);
            this.createTween(this.embedTweenComplete);
            this._lastTipString = _loc2_;
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("store.Strength.Succes.ChatSay") + this._lastTipString);
         }
         SoundManager.instance.pauseMusic();
         SoundManager.instance.play("063",false,false);
         this._timer.start();
      }
      
      private function embedTweenComplete() : void
      {
         MessageTipManager.getInstance().show(this._lastTipString);
         this.removeTips();
      }
      
      public function showFail() : void
      {
         this.removeTips();
         if(this.isDisplayerTip)
         {
            if(!this._moveSprite)
            {
               this._moveSprite = new Sprite();
               addChild(this._moveSprite);
            }
            this._moveSprite.addChild(this._failBit);
            this.createTween();
         }
         SoundManager.instance.pauseMusic();
         SoundManager.instance.play("064",false,false);
         this._timer.start();
      }
      
      public function showFiveFail() : void
      {
         this.removeTips();
         if(this.isDisplayerTip)
         {
            if(!this._moveSprite)
            {
               this._moveSprite = new Sprite();
               addChild(this._moveSprite);
            }
            this._moveSprite.addChild(this._failBit);
            this.createTween();
         }
         SoundManager.instance.pauseMusic();
         SoundManager.instance.play("064",false,false);
         this._timer.start();
      }
      
      private function __timerComplete(param1:TimerEvent) : void
      {
         this._timer.reset();
         SoundManager.instance.resumeMusic();
         SoundManager.instance.stop("063");
         SoundManager.instance.stop("064");
      }
      
      private function removeTips() : void
      {
         if(this._moveSprite && this._moveSprite.parent)
         {
            while(this._moveSprite.numChildren)
            {
               this._moveSprite.removeChildAt(0);
            }
            TweenMax.killTweensOf(this._moveSprite);
            this._moveSprite.parent.removeChild(this._moveSprite);
            this._moveSprite = null;
         }
      }
      
      public function dispose() : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this._timer.stop();
         this._timer = null;
         TweenMax.killTweensOf(this._moveSprite);
         SoundManager.instance.resumeMusic();
         SoundManager.instance.stop("063");
         SoundManager.instance.stop("064");
         this.removeTips();
         if(this._successBit)
         {
            ObjectUtils.disposeObject(this._successBit);
         }
         this._successBit = null;
         if(this._failBit)
         {
            ObjectUtils.disposeObject(this._failBit);
         }
         this._failBit = null;
         if(this._fiveFailBit)
         {
            ObjectUtils.disposeObject(this._fiveFailBit);
         }
         this._fiveFailBit = null;
         if(this._moveSprite)
         {
            ObjectUtils.disposeObject(this._moveSprite);
         }
         this._moveSprite = null;
         if(this._changeTxtI)
         {
            ObjectUtils.disposeObject(this._changeTxtI);
         }
         this._changeTxtI = null;
         if(this._changeTxtII)
         {
            ObjectUtils.disposeObject(this._changeTxtII);
         }
         this._changeTxtII = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
