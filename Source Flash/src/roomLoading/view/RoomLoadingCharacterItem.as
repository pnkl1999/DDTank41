package roomLoading.view
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.Badge;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.academyCommon.academyIcon.AcademyIcon;
   import ddt.view.common.DailyLeagueLevel;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.MarriedIcon;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import room.RoomManager;
   import room.events.RoomPlayerEvent;
   import room.model.RoomPlayer;
   import vip.VipController;
   
   public class RoomLoadingCharacterItem extends Sprite implements Disposeable
   {
       
      
      private var _info:RoomPlayer;
      
      private var _bg:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _loadingTxt:FilterFrameText;
      
      private var _perecentageTxt:FilterFrameText;
      
      private var _okTxt:Bitmap;
      
      private var _levelIcon:LevelIcon;
      
      private var _legaueLevel:DailyLeagueLevel;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _marriedIcon:MarriedIcon;
      
      private var _academyIcon:AcademyIcon;
      
      private var _badge:Badge;
      
      private var _iconContainer:VBox;
      
      private var _iconPos:Point;
      
      private var _loadingArr:Array;
      
      private var _frameSet:int;
      
      protected var _displayMc:MovieClip;
      
      protected var _weapon:DisplayObject;
      
      protected var _index:int = 1;
      
      protected var _animationFinish:Boolean = false;
      
      public function RoomLoadingCharacterItem(param1:RoomPlayer)
      {
         super();
         this._info = param1;
         this.init();
      }
      
      private function init() : void
      {
         if(this._info.team == RoomPlayer.BLUE_TEAM)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.roomLoading.CharacterBg_Blue");
            this._loadingTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemLoadingBlueTxt");
            this._perecentageTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemPercentageBlueTxt");
         }
         else
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.roomLoading.CharacterBg_Red");
            this._loadingTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemLoadingRedTxt");
            this._perecentageTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemPercentageRedTxt");
         }
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemNameTxt");
         this._frameSet = 0;
         this._nameTxt.text = this._info.playerInfo.NickName;
         this._loadingArr = ["loading.","loading..","loading..."];
         this._loadingTxt.text = this._loadingArr[0];
         this._perecentageTxt.text = "0%";
         addEventListener(Event.ENTER_FRAME,this.__runLoading);
         this._info.addEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onProgress);
         this._displayMc = ComponentFactory.Instance.creat("asset.roomloading.displayMC");
         this._displayMc.addEventListener("appeared",this.__onAppeared);
         addChild(this._displayMc);
         this._displayMc.scaleX = this._info.team == RoomPlayer.BLUE_TEAM ? Number(Number(1)) : Number(Number(-1));
         this._displayMc["character"].addChild(this._info.character);
         addChild(this._bg);
         addChild(this._info.character);
         this._info.character.stopAnimation();
         addChild(this._loadingTxt);
         addChild(this._perecentageTxt);
         if(this._info.playerInfo.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(this._nameTxt.width,this._info.playerInfo.typeVIP);
            this._vipName.x = this._nameTxt.x;
            this._vipName.y = this._nameTxt.y;
            this._vipName.text = this._nameTxt.text;
            addChild(this._vipName);
         }
         else
         {
            addChild(this._nameTxt);
         }
         this._iconContainer = ComponentFactory.Instance.creatComponentByStylename("asset.roomLoadingPlayerItem.iconContainer");
         addChild(this._iconContainer);
         this.initIcons();
      }
      
      private function __runLoading(param1:Event) : void
      {
         ++this._frameSet;
         // if(this._frameSet % 30 == 0)
         // {
         //    this._loadingArr = this._loadingArr.concat(["loading.","loading..","loading..."]);
         // }
         // if(this._frameSet % 10 == 0)
         // {
         //    this._loadingTxt.text = this._loadingArr[int(this._frameSet / 10)];
         // }

         if(this._frameSet % 10 == 0)
         {
            this._loadingTxt.text = this._loadingArr[int(this._frameSet / 10 % 3)];
         }
         this._perecentageTxt.text = String(int(this._info.progress)) + "%";
      }
      
      public function get displayMc() : DisplayObject
      {
         return this._displayMc;
      }
      
      public function appear(param1:String) : void
      {
         this._displayMc.gotoAndPlay("appear" + param1);
      }
      
      public function disappear(param1:String) : void
      {
         this._displayMc.gotoAndPlay("disappear" + param1);
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
      
      private function __onProgress(param1:RoomPlayerEvent) : void
      {
         var _loc2_:Point = null;
         this._perecentageTxt.text = String(int(this._info.progress)) + "%";
         if(this._info.progress > 99)
         {
            this._okTxt = ComponentFactory.Instance.creatBitmap("asset.roomLoading.LoadingOK");
            _loc2_ = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.LoadingOKStartPos");
            TweenMax.from(this._okTxt,0.5,{
               "alpha":0,
               "scaleX":2,
               "scaleY":2,
               "x":_loc2_.x,
               "y":_loc2_.y,
               "ease":Quint.easeIn,
               "onStart":this.finishTxt
            });
            addChild(this._okTxt);
            removeEventListener(Event.ENTER_FRAME,this.__runLoading);
            this._info.removeEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onProgress);
         }
      }
      
      private function finishTxt() : void
      {
         this._perecentageTxt.text = "100%";
         this.removeTxt();
      }
      
      private function removeTxt() : void
      {
         if(this._perecentageTxt)
         {
            this._perecentageTxt.parent.removeChild(this._perecentageTxt);
         }
         if(this._loadingTxt.parent)
         {
            this._loadingTxt.parent.removeChild(this._loadingTxt);
         }
      }
      
      private function initIcons() : void
      {
         this._iconPos = ComponentFactory.Instance.creatCustomObject("roomLoading.CharacterItemIconStartPos");
         this._levelIcon = new LevelIcon();
         this._levelIcon.setInfo(this._info.playerInfo.Grade,this._info.playerInfo.Repute,this._info.playerInfo.WinCount,this._info.playerInfo.TotalCount,this._info.playerInfo.FightPower,this._info.playerInfo.Offer,true,true,this._info.team);
         PositionUtils.setPos(this._levelIcon,this._iconPos);
         addChild(this._levelIcon);
         if(RoomManager.Instance.current.isLeagueRoom)
         {
            this._legaueLevel = new DailyLeagueLevel();
            this._legaueLevel.size = DailyLeagueLevel.SIZE_SMALL;
            this._legaueLevel.leagueFirst = this._info.playerInfo.DailyLeagueFirst;
            this._legaueLevel.score = this._info.playerInfo.DailyLeagueLastScore;
            this._legaueLevel.tipData = this._levelIcon.tipData;
            this._legaueLevel.tipDirctions = this._levelIcon.tipDirctions;
            this._legaueLevel.tipGapH = this._levelIcon.tipGapH;
            this._legaueLevel.tipGapV = this._levelIcon.tipGapV;
            this._legaueLevel.tipStyle = this._levelIcon.tipStyle;
            PositionUtils.setPos(this._legaueLevel,this._iconPos);
            addChild(this._legaueLevel);
            this._legaueLevel.x -= 3;
            ShowTipManager.Instance.addTip(this._legaueLevel);
            ObjectUtils.disposeObject(this._levelIcon);
         }
         this._iconPos.y += 30;
         this._iconPos.x += 3;
         this._vipIcon = new VipLevelIcon();
         if(this._info.playerInfo.ID == PlayerManager.Instance.Self.ID || this._info.playerInfo.IsVIP)
         {
            this._vipIcon = new VipLevelIcon();
            this._vipIcon.setInfo(this._info.playerInfo);
            this._vipIcon.filters = !this._info.playerInfo.IsVIP ? ComponentFactory.Instance.creatFilters("grayFilter") : null;
            this._iconContainer.addChild(this._vipIcon);
         }
         this._marriedIcon = new MarriedIcon();
         if(this._info.playerInfo.SpouseID > 0)
         {
            this._marriedIcon = ComponentFactory.Instance.creatCustomObject("roomLoading.CharacterMarriedIcon");
            this._marriedIcon.tipData = {
               "nickName":this._info.playerInfo.SpouseName,
               "gender":this._info.playerInfo.Sex
            };
            this._iconContainer.addChild(this._marriedIcon);
            this._iconPos.y += 30;
         }
         if(this._info.playerInfo.shouldShowAcademyIcon())
         {
            this._academyIcon = ComponentFactory.Instance.creatCustomObject("roomLoading.CharacterAcademyIcon");
            this._academyIcon.tipData = this._info.playerInfo;
            this._iconContainer.addChild(this._academyIcon);
         }
         if(this._info.playerInfo.ConsortiaID > 0 && this._info.playerInfo.badgeID > 0)
         {
            this._badge = new Badge();
            this._badge.badgeID = this._info.playerInfo.badgeID;
            this._badge.showTip = true;
            this._badge.tipData = this._info.playerInfo.ConsortiaName;
            this._iconContainer.addChild(this._badge);
         }
      }
      
      public function get info() : RoomPlayer
      {
         return this._info;
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      protected function __onAppeared(param1:Event) : void
      {
         this._animationFinish = true;
      }
      
      public function get isAnimationFinished() : Boolean
      {
         return this._animationFinish;
      }
      
      public function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__runLoading);
         this._info.removeEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onProgress);
         if(this._info.character && this._info.character.parent)
         {
            this._info.character.parent.removeChild(this._info.character);
         }
         TweenMax.killTweensOf(this._okTxt);
         if(this._displayMc)
         {
            this._displayMc.removeEventListener("appeared",this.__onAppeared);
         }
         ObjectUtils.disposeObject(this._displayMc);
         this._displayMc = null;
         ObjectUtils.disposeObject(this._bg);
         ObjectUtils.disposeObject(this._nameTxt);
         ObjectUtils.disposeObject(this._vipName);
         ObjectUtils.disposeObject(this._loadingTxt);
         ObjectUtils.disposeObject(this._perecentageTxt);
         ObjectUtils.disposeObject(this._okTxt);
         ObjectUtils.disposeObject(this._levelIcon);
         if(this._legaueLevel)
         {
            ObjectUtils.disposeObject(this._legaueLevel);
            ShowTipManager.Instance.removeTip(this._legaueLevel);
         }
         ObjectUtils.disposeObject(this._vipIcon);
         ObjectUtils.disposeObject(this._marriedIcon);
         ObjectUtils.disposeObject(this._academyIcon);
         ObjectUtils.disposeObject(this._badge);
         ObjectUtils.disposeObject(this._iconContainer);
         this._info = null;
         this._bg = null;
         this._nameTxt = null;
         this._vipName = null;
         this._loadingTxt = null;
         this._perecentageTxt = null;
         this._okTxt = null;
         this._levelIcon = null;
         this._legaueLevel = null;
         this._vipIcon = null;
         this._marriedIcon = null;
         this._academyIcon = null;
         this._iconPos = null;
         this._loadingArr = null;
         this._badge = null;
         this._iconContainer = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
