package ddt.view.academyCommon.recommend
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.Badge;
   import ddt.data.player.AcademyPlayerInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.AcademyFrameManager;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.MarriedIcon;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import im.IMController;
   
   public class RecommendPlayerCellView extends Sprite implements Disposeable, ITipedDisplay
   {
       
      
      protected var _cellBg:Bitmap;
      
      protected var _nameTxt:GradientText;
      
      protected var _guildTxt:FilterFrameText;
      
      protected var _masterHonor:ScaleFrameImage;
      
      protected var _masterHonorText:GradientText;
      
      protected var _levelIcon:LevelIcon;
      
      protected var _vipIcon:VipLevelIcon;
      
      protected var _marriedIcon:MarriedIcon;
      
      protected var _badge:Badge;
      
      protected var _player:RoomCharacter;
      
      protected var _characteContainer:Sprite;
      
      protected var _iconContainer:VBox;
      
      protected var _recommendBtn:BaseButton;
      
      protected var _info:AcademyPlayerInfo;
      
      protected var _overLight:Bitmap;
      
      protected var _tweenBigLight:IEffect;
      
      protected var _btnLight:IEffect;
      
      protected var _isSelect:Boolean;
      
      protected var _tipStyle:String;
      
      protected var _tipDirctions:String;
      
      protected var _tipData:Object;
      
      protected var _tipGapH:int;
      
      protected var _tipGapV:int;
      
      protected var _chat:BaseButton;
      
      public function RecommendPlayerCellView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._cellBg = ComponentFactory.Instance.creatBitmap("academyCommon.RecommendPlayerCellView.RecommendPlayerCellBg");
         addChild(this._cellBg);
         this._characteContainer = new Sprite();
         addChild(this._characteContainer);
         this._masterHonor = ComponentFactory.Instance.creatComponentByStylename("academyCommon.RecommendPlayerCellView.masterHonor");
         this._masterHonor.visible = false;
         addChild(this._masterHonor);
         this._guildTxt = ComponentFactory.Instance.creatComponentByStylename("academyCommon.RecommendPlayerCellView.guildTxt");
         addChild(this._guildTxt);
         this._iconContainer = ComponentFactory.Instance.creatComponentByStylename("asset.RecommendPlayerCellView.iconContainer");
         addChild(this._iconContainer);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("academy.RecommendPlayerCellView.levelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_BIG);
         addChild(this._levelIcon);
         this._overLight = ComponentFactory.Instance.creatBitmap("academyCommon.RecommendPlayerCellView.recommendOverLight");
         addChild(this._overLight);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("academyCommon.RecommendPlayerCellView.nameTxt");
         addChild(this._nameTxt);
         this._tweenBigLight = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._cellBg,"asset.academy.tweenBigLight",PositionUtils.creatPoint("ddt.view.academyCommon.recommend.lightPint"));
         this._tweenBigLight.stop();
         this._chat = ComponentFactory.Instance.creatComponentByStylename("academyCommon.RecommendPlayerCellView.masterChat");
         addChild(this._chat);
         this._tipStyle = "ddt.view.tips.OneLineTip";
         this._tipDirctions = "0,4,5";
         this._tipGapV = 5;
         this._tipGapH = 5;
         this._tipData = LanguageMgr.GetTranslation("ddt.view.academyCommon.recommend.RecommendPlayerCellView.tips");
         ShowTipManager.Instance.addTip(this);
         this.initRecommendBtn();
      }
      
      protected function initRecommendBtn() : void
      {
         this._recommendBtn = ComponentFactory.Instance.creatComponentByStylename("academyCommon.RecommendPlayerCellView.master");
         addChild(this._recommendBtn);
         this._btnLight = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._recommendBtn,"asset.academy.BtnLight",PositionUtils.creatPoint("ddt.view.academyCommon.recommend.BtnlightPint"));
         this._btnLight.stop();
      }
      
      protected function initEvent() : void
      {
         this._recommendBtn.addEventListener(MouseEvent.CLICK,this.__recommendBtn);
         this._chat.addEventListener(MouseEvent.CLICK,this.__chatHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.__onOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onOut);
         this._characteContainer.addEventListener(MouseEvent.CLICK,this.__onClick);
      }
      
      protected function __chatHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         IMController.Instance.alertPrivateFrame(this._info.info.ID);
      }
      
      private function __onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PlayerInfoViewControl.viewByID(this.info.info.ID,PlayerManager.Instance.Self.ZoneID);
      }
      
      private function __onOut(param1:MouseEvent) : void
      {
         if(!this._isSelect)
         {
            this._overLight.visible = false;
         }
      }
      
      private function __onOver(param1:MouseEvent) : void
      {
         if(!this._isSelect)
         {
            this._overLight.visible = true;
         }
      }
      
      public function set isSelect(param1:Boolean) : void
      {
         this._isSelect = param1;
         if(this._isSelect)
         {
            this._tweenBigLight.play();
            this._btnLight.play();
         }
         else
         {
            this._overLight.visible = false;
            this._tweenBigLight.stop();
            this._btnLight.stop();
         }
      }
      
      public function get isSelect() : Boolean
      {
         return this._isSelect;
      }
      
      private function createCharacter() : void
      {
         this._player = CharactoryFactory.createCharacter(this._info.info,"room") as RoomCharacter;
         this._player.showGun = true;
         this._player.show(true,-1);
         PositionUtils.setPos(this._player,"academy.RecommendPlayerCellView.playerPos");
         this._characteContainer.addChild(this._player as DisplayObject);
      }
      
      protected function __recommendBtn(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!AcademyManager.Instance.compareState(this._info.info,PlayerManager.Instance.Self))
         {
            return;
         }
         if(AcademyManager.Instance.isFreezes(true))
         {
            AcademyFrameManager.Instance.showAcademyRequestMasterFrame(this._info.info);
         }
      }
      
      private function __characterComplete(param1:Event) : void
      {
         this._player.removeEventListener(Event.COMPLETE,this.__characterComplete);
         PositionUtils.setPos(this._player,"academy.RecommendPlayerCellView.playerPos");
         this._characteContainer.addChild(this._player as DisplayObject);
      }
      
      private function update() : void
      {
         var _loc1_:PlayerInfo = this._info.info;
         this._nameTxt.text = _loc1_.NickName;
         this._guildTxt.text = _loc1_.ConsortiaName;
         var _loc2_:int = AcademyManager.Instance.getMasterHonorLevel(_loc1_.graduatesCount);
         if(_loc2_ != 0)
         {
            this._masterHonor.visible = true;
            this._masterHonor.setFrame(_loc2_);
         }
         else
         {
            this._masterHonor.visible = false;
         }
         this.createCharacter();
         this.updateIcon();
      }
      
      protected function updateIcon() : void
      {
         var _loc1_:PlayerInfo = this._info.info;
         this._levelIcon.setInfo(_loc1_.Grade,_loc1_.Repute,_loc1_.WinCount,_loc1_.TotalCount,_loc1_.FightPower,_loc1_.Offer,true,false);
         if(_loc1_.IsVIP)
         {
            if(this._vipIcon == null)
            {
               this._vipIcon = ComponentFactory.Instance.creatCustomObject("academy.RecommendPlayerCellView.VipIcon");
               this._vipIcon.setInfo(_loc1_);
               this._iconContainer.addChild(this._vipIcon);
            }
         }
         else if(this._vipIcon)
         {
            this._vipIcon.dispose();
            this._vipIcon = null;
         }
         if(_loc1_.SpouseID > 0)
         {
            if(this._marriedIcon == null)
            {
               this._marriedIcon = ComponentFactory.Instance.creatCustomObject("academy.RecommendPlayerCellView.MarriedIcon");
               this._iconContainer.addChild(this._marriedIcon);
            }
            this._marriedIcon.tipData = {
               "nickName":_loc1_.SpouseName,
               "gender":_loc1_.Sex
            };
         }
         else
         {
            if(this._marriedIcon != null)
            {
               this._marriedIcon.dispose();
            }
            this._marriedIcon = null;
         }
         if(_loc1_.badgeID > 0)
         {
            if(this._badge == null)
            {
               this._badge = new Badge();
               this._badge.showTip = true;
               this._badge.badgeID = _loc1_.badgeID;
               this._badge.tipData = _loc1_.ConsortiaName;
               this._iconContainer.addChild(this._badge);
            }
         }
         else
         {
            ObjectUtils.disposeObject(this._badge);
            this._badge = null;
         }
      }
      
      public function set info(param1:AcademyPlayerInfo) : void
      {
         this._info = param1;
         this.update();
      }
      
      public function get info() : AcademyPlayerInfo
      {
         return this._info;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1;
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
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__onOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__onOut);
         EffectManager.Instance.removeEffect(this._btnLight);
         EffectManager.Instance.removeEffect(this._tweenBigLight);
         if(this._cellBg)
         {
            ObjectUtils.disposeObject(this._cellBg);
            this._cellBg = null;
         }
         if(this._recommendBtn)
         {
            this._recommendBtn.removeEventListener(MouseEvent.CLICK,this.__recommendBtn);
            ObjectUtils.disposeObject(this._recommendBtn);
            this._recommendBtn = null;
         }
         if(this._masterHonor)
         {
            ObjectUtils.disposeObject(this._masterHonor);
            this._masterHonor = null;
         }
         if(this._chat)
         {
            this._chat.removeEventListener(MouseEvent.CLICK,this.__chatHandler);
            ObjectUtils.disposeObject(this._chat);
            this._chat = null;
         }
         if(this._nameTxt)
         {
            this._nameTxt.dispose();
            this._nameTxt = null;
         }
         if(this._guildTxt)
         {
            this._guildTxt.dispose();
            this._guildTxt = null;
         }
         if(this._levelIcon)
         {
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
         if(this._player)
         {
            this._player.dispose();
            this._player = null;
         }
         if(this._characteContainer && this._characteContainer.parent)
         {
            this._characteContainer.removeEventListener(MouseEvent.CLICK,this.__onClick);
            this._characteContainer.parent.removeChild(this._characteContainer);
            this._characteContainer = null;
         }
         if(this._overLight)
         {
            ObjectUtils.disposeObject(this._overLight);
            this._overLight = null;
         }
         if(this._levelIcon)
         {
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
         if(this._vipIcon)
         {
            this._vipIcon.dispose();
            this._vipIcon = null;
         }
         if(this._marriedIcon)
         {
            ObjectUtils.disposeObject(this._marriedIcon);
         }
         this._marriedIcon = null;
         ObjectUtils.disposeObject(this._badge);
         this._badge = null;
         ObjectUtils.disposeObject(this._iconContainer);
         this._iconContainer = null;
         ShowTipManager.Instance.removeTip(this);
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
