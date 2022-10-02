package game.view.tool
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
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
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import game.GameManager;
   
   public class BloodStrip extends Sprite implements Disposeable, ITipedDisplay
   {
       
      
      private var _HPStripBg:Bitmap;
      
      private var _HPStrip:Bitmap;
      
      private var _hpShadow:Bitmap;
      
      private var _HPTxt:FilterFrameText;
      
      private var _mask:Shape;
      
      private var _hurtedMask:MovieClip;
      
      private var _tipStyle:String;
      
      private var _tipDirctions:String;
      
      private var _tipData:Object;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _maskH:Number;
      
      private var _info:ChangeNumToolTipInfo;
      
      public function BloodStrip()
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
         this._hurtedMask = ComponentFactory.Instance.creatCustomObject("asset.game.OnHurtedFrame");
         LayerManager.Instance.addToLayer(this._hurtedMask,LayerManager.GAME_TOP_LAYER);
         this._hurtedMask.gotoAndStop(1);
         this.__update(null);
         this.initTip();
         GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.BLOOD_CHANGED,this.__update);
         GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.MAX_HP_CHANGED,this.__update);
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
         GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.MAX_HP_CHANGED,this.__update);
         GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.DIE,this.__update);
         ObjectUtils.disposeObject(this._HPStripBg);
         this._HPStripBg = null;
         ObjectUtils.disposeObject(this._HPStrip);
         this._HPStrip = null;
         ObjectUtils.disposeObject(this._HPTxt);
         this._HPTxt = null;
         ChangeNumToolTipInfo(this._tipData).currentTxt.dispose();
         if(this._hurtedMask.parent)
         {
            this._hurtedMask.parent.removeChild(this._hurtedMask);
         }
         this._hurtedMask = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function __update(param1:LivingEvent) : void
      {
         if(GameManager.Instance.Current.selfGamePlayer.isLiving)
         {
            this.update(GameManager.Instance.Current.selfGamePlayer.blood,GameManager.Instance.Current.selfGamePlayer.maxBlood);
            if(param1 && param1.paras[0] == 2)
            {
               this._hurtedMask.gotoAndPlay(2);
            }
         }
         else
         {
            this.update(0,GameManager.Instance.Current.selfGamePlayer.maxBlood);
         }
      }
      
      private function update(param1:int, param2:int) : void
      {
         if(this._info)
         {
            if(this._info.current > param1)
            {
            }
            this._info.current = param1 < 0 ? int(int(0)) : int(int(param1));
            this._info.total = param2;
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
