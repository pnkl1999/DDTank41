package game.view.playerThumbnail
{
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.BasePlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.events.LivingEvent;
   import ddt.manager.BitmapManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.LevelTipInfo;
   import ddt.view.tips.MarriedTip;
   import ddt.view.tips.PetTip;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilter;
   import flash.filters.ColorMatrixFilter;
   import game.model.Player;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   
   [Event(name="playerThumbnailEvent",type="flash.events.Event")]
   public class PlayerThumbnail extends Sprite implements Disposeable, ITipedDisplay
   {
       
      
      private var _info:Player;
      
      private var _headFigure:HeadFigure;
      
      private var _blood:BloodItem;
      
      private var _bg:Bitmap;
      
      private var _fore:Bitmap;
      
      private var _shiner:IEffect;
      
      private var lightingFilter:BitmapFilter;
      
      private var _marryTip:MarriedTip;
      
      private var _dirct:int;
      
      private var _vip:DisplayObject;
      
      private var _bitmapMgr:BitmapManager;
      
      private var _petTip:PetTip;
      
      private var _isShowTip:Boolean;
      
      private var _levelTipInfo:LevelTipInfo;
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      public function PlayerThumbnail(param1:Player, param2:int, param3:Boolean = true)
      {
         super();
         this._info = param1;
         this._dirct = param2;
         this._isShowTip = param3;
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.back");
         addChild(this._bg);
         this._headFigure = new HeadFigure(36,36,this._info);
         this._headFigure.y = 3;
         addChild(this._headFigure);
         this._blood = new BloodItem(this._info.maxBlood);
         this._blood.y = 43;
         addChild(this._blood);
         this._fore = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.fore");
         this._fore.y = 1;
         this._fore.x = 1;
         addChild(this._fore);
         if(this._info.playerInfo.typeVIP == BasePlayer.SENIOR_VIP)
         {
            this._bitmapMgr = BitmapManager.getBitmapMgr(BitmapManager.GameView);
            this._vip = this._bitmapMgr.creatBitmapShape("asset.game.smallplayer.seniorVIP");
            addChild(this._vip);
         }
         else if(this._info.playerInfo.typeVIP == BasePlayer.JUNIOR_VIP)
         {
            this._bitmapMgr = BitmapManager.getBitmapMgr(BitmapManager.GameView);
            this._vip = this._bitmapMgr.creatBitmapShape("asset.game.smallplayer.vip");
            addChild(this._vip);
         }
         if(this._dirct == -1)
         {
            this._headFigure.scaleX = -this._headFigure.scaleX;
            this._headFigure.x = 42;
            if(this._vip)
            {
               PositionUtils.setPos(this._vip,"asset.game.smallplayer.vipPos1");
            }
         }
         else
         {
            this._headFigure.x = 4;
            if(this._vip)
            {
               PositionUtils.setPos(this._vip,"asset.game.smallplayer.vipPos2");
            }
         }
         this._shiner = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this,"asset.gameII.thumbnailShineAsset");
         if(this._info.playerInfo.SpouseName)
         {
            this._marryTip = new MarriedTip();
            this._marryTip.tipData = {
               "nickName":this._info.playerInfo.SpouseName,
               "gender":this._info.playerInfo.Sex
            };
         }
         var _loc1_:PetInfo = this._info.playerInfo.currentPet;
         if(_loc1_)
         {
            this._petTip = ComponentFactory.Instance.creatComponentByStylename("core.PetTip");
            this._petTip.tipData = {
               "petName":_loc1_.Name,
               "petLevel":_loc1_.Level,
               "petIconUrl":PetBagController.instance().getPicStrByLv(_loc1_)
            };
         }
         this.createLevelTip();
         buttonMode = true;
         this.setUpLintingFilter();
      }
      
      public function get info() : PlayerInfo
      {
         return this._info.playerInfo;
      }
      
      override public function get width() : Number
      {
         return this._bg.width;
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      private function createLevelTip() : void
      {
         if(this._isShowTip)
         {
            this.tipStyle = "core.SmallPlayerTips";
            this.tipDirctions = "7";
            this.tipGapV = 10;
            this.tipGapH = 10;
         }
         var _loc1_:LevelTipInfo = new LevelTipInfo();
         _loc1_.enableTip = true;
         _loc1_.Battle = this._info.playerInfo.FightPower;
         _loc1_.Level = this._info.playerInfo.Grade;
         _loc1_.Repute = this._info.playerInfo.Repute;
         _loc1_.Total = this._info.playerInfo.TotalCount;
         _loc1_.Win = this._info.playerInfo.WinCount;
         _loc1_.exploit = this._info.playerInfo.Offer;
         _loc1_.team = this._info.team;
         _loc1_.nickName = this._info.playerInfo.NickName;
         this.tipData = _loc1_;
         ShowTipManager.Instance.addTip(this);
      }
      
      protected function overHandler(param1:MouseEvent) : void
      {
         var _loc2_:ITip = null;
         var _loc3_:ITip = null;
         this.filters = [this.lightingFilter];
         if(this._marryTip && this._isShowTip)
         {
            this._marryTip.visible = true;
            LayerManager.Instance.addToLayer(this._marryTip,LayerManager.GAME_DYNAMIC_LAYER);
            _loc2_ = ShowTipManager.Instance.getTipInstanceByStylename(this.tipStyle);
            this._marryTip.x = _loc2_.x;
            this._marryTip.y = _loc2_.y + _loc2_.height;
         }
         if(this._petTip && this._isShowTip)
         {
            this._petTip.visible = true;
            LayerManager.Instance.addToLayer(this._petTip,LayerManager.GAME_DYNAMIC_LAYER);
            _loc3_ = ShowTipManager.Instance.getTipInstanceByStylename(this.tipStyle);
            this._petTip.x = _loc3_.x + _loc3_.width;
            this._petTip.y = _loc3_.y;
         }
      }
      
      protected function outHandler(param1:MouseEvent) : void
      {
         this.filters = null;
         if(this._marryTip && this._isShowTip)
         {
            this._marryTip.visible = false;
         }
         if(this._petTip && this._isShowTip)
         {
            this._petTip.visible = false;
         }
      }
      
      protected function clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.removeTipTemp();
         dispatchEvent(new Event("playerThumbnailEvent"));
      }
      
      private function removeTipTemp() : void
      {
         if(this._marryTip)
         {
            this._marryTip.visible = false;
         }
         if(this._petTip)
         {
            this._petTip.visible = false;
         }
         ShowTipManager.Instance.removeTip(this);
         removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
      }
      
      public function recoverTip() : void
      {
         SoundManager.instance.play("008");
         ShowTipManager.Instance.addTip(this);
         addEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.outHandler);
      }
      
      private function initEvents() : void
      {
         this._info.addEventListener(LivingEvent.BLOOD_CHANGED,this.__updateBlood);
         this._info.addEventListener(LivingEvent.DIE,this.__die);
         this._info.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__shineChange);
         addEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         addEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      private function setUpLintingFilter() : void
      {
         var _loc1_:Array = new Array();
         _loc1_ = _loc1_.concat([1,0,0,0,25]);
         _loc1_ = _loc1_.concat([0,1,0,0,25]);
         _loc1_ = _loc1_.concat([0,0,1,0,25]);
         _loc1_ = _loc1_.concat([0,0,0,1,0]);
         this.lightingFilter = new ColorMatrixFilter(_loc1_);
      }
      
      private function __shineChange(param1:LivingEvent) : void
      {
         if(this._info && this._info.isAttacking)
         {
            this._shiner.play();
         }
         else
         {
            this._shiner.stop();
         }
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
         this.__shineChange(null);
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
         this.__shineChange(null);
      }
      
      private function __die(param1:LivingEvent) : void
      {
         if(this._headFigure)
         {
            this._headFigure.gray();
         }
         if(this._blood && this._blood.parent)
         {
            this._blood.parent.removeChild(this._blood);
         }
      }
      
      private function removeEvents() : void
      {
         if(this._info)
         {
            this._info.removeEventListener(LivingEvent.BLOOD_CHANGED,this.__updateBlood);
            this._info.removeEventListener(LivingEvent.DIE,this.__die);
            this._info.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__shineChange);
         }
         removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         removeEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      private function __updateBlood(param1:LivingEvent) : void
      {
         this._blood.setProgress(this._info.blood,this._info.maxBlood);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ShowTipManager.Instance.removeTip(this);
         if(this._marryTip && this._marryTip.parent)
         {
            this._marryTip.parent.removeChild(this._marryTip);
         }
         this._marryTip = null;
         ObjectUtils.disposeObject(this._petTip);
         this._petTip = null;
         EffectManager.Instance.removeEffect(this._shiner);
         this._shiner = null;
         if(this._headFigure)
         {
            this._headFigure.dispose();
         }
         this._headFigure = null;
         if(this._blood)
         {
            this._blood.dispose();
         }
         this._blood = null;
         ObjectUtils.disposeObject(this._vip);
         this._vip = null;
         ObjectUtils.disposeObject(this._bitmapMgr);
         this._bitmapMgr = null;
         removeChild(this._bg);
         this._bg.bitmapData.dispose();
         this._bg = null;
         if(this._fore)
         {
            ObjectUtils.disposeObject(this._fore);
            this._fore = null;
         }
         this._info = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get tipData() : Object
      {
         return this._levelTipInfo;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._levelTipInfo = param1 as LevelTipInfo;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirctions = param1;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
