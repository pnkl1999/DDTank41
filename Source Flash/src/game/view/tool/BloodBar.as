package game.view.tool
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.LivingEvent;
   import ddt.manager.LanguageMgr;
   import ddt.view.tips.ChangeNumToolTipInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import game.GameManager;
   
   public class BloodBar extends Sprite implements Disposeable, ITipedDisplay
   {
       
      
      private var _HPStripBg:Bitmap;
      
      private var _HPStrip:Bitmap;
      
      private var _hpShadow:Bitmap;
      
      private var _HPTxt:FilterFrameText;
      
      private var _mask:Shape;
      
      private var _tipStyle:String;
      
      private var _tipDirctions:String;
      
      private var _tipData:Object;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _maskH:Number;
      
      private var _info:ChangeNumToolTipInfo;
      
      private var _localBlood:int;
      
      private var _blood:int;
      
      private var _lastBlood:int;
      
      private var _maxBlood:int;
      
      private var _tweenTime:Number = 0.6;
      
      public function BloodBar()
      {
         super();
         this._HPStrip = ComponentFactory.Instance.creatBitmap("asset.game.blood.SelfBack");
         addChild(this._HPStrip);
         this._HPTxt = ComponentFactory.Instance.creatComponentByStylename("asset.toolHPStripTxt");
         addChild(this._HPTxt);
         this._mask = new Shape();
         this._mask.graphics.beginFill(0,1);
         this._mask.graphics.drawRect(0,0,10,this._HPStrip.height);
         this._mask.graphics.endFill();
         addChild(this._mask);
         this._HPStrip.mask = this._mask;
         this._maskH = this._mask.height;
         this._localBlood = this._blood = this._maxBlood = this._lastBlood = GameManager.Instance.Current.selfGamePlayer.blood;
         this.__update(null);
         this.initTip();
         GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.BLOOD_CHANGED,this.__update);
         GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.DIE,this.__update);
      }
      
      private function initTip() : void
      {
         this.tipStyle = "ddt.view.tips.ChangeNumToolTip";
         this.tipDirctions = "4";
         this.tipGapV = 5;
         this.tipGapH = 5;
         this._info = new ChangeNumToolTipInfo();
         this._info.currentTxt = ComponentFactory.Instance.creatComponentByStylename("game.BloodString.currentTxt");
         this._info.title = LanguageMgr.GetTranslation("tank.game.BloodStrip.HP") + ":";
         this._info.current = GameManager.Instance.Current.selfGamePlayer.maxBlood;
         this._info.total = GameManager.Instance.Current.selfGamePlayer.maxBlood;
         this._info.content = LanguageMgr.GetTranslation("tank.game.BloodStrip.tip");
         this.tipData = this._info;
         ShowTipManager.Instance.addTip(this);
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.BLOOD_CHANGED,this.__update);
         GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.DIE,this.__update);
         ObjectUtils.disposeObject(this._HPStripBg);
         this._HPStripBg = null;
         ObjectUtils.disposeObject(this._HPStrip);
         this._HPStrip = null;
         ObjectUtils.disposeObject(this._HPTxt);
         this._HPTxt = null;
         ChangeNumToolTipInfo(this._tipData).currentTxt.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function __update(param1:LivingEvent) : void
      {
         var _loc2_:int = 0;
         if(GameManager.Instance.Current.selfGamePlayer.isLiving)
         {
            TweenLite.killTweensOf(this);
            this._localBlood = this._blood = GameManager.Instance.Current.selfGamePlayer.blood > 0 ? int(int(GameManager.Instance.Current.selfGamePlayer.blood)) : int(int(0));
            this.drawBlood();
            this._localBlood = this._lastBlood;
            _loc2_ = Math.abs(this._blood - this._lastBlood);
            if(this._blood < this._lastBlood)
            {
               TweenLite.to(this,this._tweenTime * (_loc2_ / this._maxBlood),{
                  "localBlood":this._blood,
                  "onUpdate":this.drawShodow,
                  "onComplete":this.tweenComplete
               });
            }
            else
            {
               TweenLite.to(this,this._tweenTime * (_loc2_ / this._maxBlood),{
                  "localBlood":this._blood,
                  "onUpdate":this.drawBlood,
                  "onComplete":this.tweenComplete
               });
            }
         }
      }
      
      public function get localBlood() : int
      {
         return this._localBlood;
      }
      
      public function set localBlood(param1:int) : void
      {
         this._lastBlood = this._localBlood = param1;
      }
      
      private function drawShodow() : void
      {
      }
      
      private function drawBlood() : void
      {
         this._HPTxt.text = this._localBlood.toString();
      }
      
      private function tweenComplete() : void
      {
      }
      
      private function update(param1:int, param2:int) : void
      {
         if(this._info)
         {
            if(this._info.current > param1)
            {
            }
            this._info.current = param1 < 0 ? int(int(0)) : int(int(param1));
            this.tipData = this._info;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > param2)
         {
            param1 = param2;
         }
         this._mask.width = this._HPStrip.width * (param1 / param2);
         this._mask.x = this._HPStrip.width - this._mask.width;
         this._HPTxt.text = String(param1);
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirctions = param1;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
