package game.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.Badge;
   import ddt.events.LivingEvent;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import game.GameManager;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.Player;
   import game.model.TurnedLiving;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.view.RoomPlayerItemPet;
   import vip.VipController;
   
   public class LeftPlayerCartoonView extends Sprite implements Disposeable
   {
      
      public static const SHOW_BITMAP_WIDTH:int = 120;
      
      public static const SHOW_BITMAP_HEIGHT:int = 200;
       
      
      private var _movie:MovieClip;
      
      private var _nickName:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _zoneName:FilterFrameText;
      
      private var _honorName:FilterFrameText;
      
      private var _team:ScaleFrameImage;
      
      private var _info:Living;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _badge:Badge;
      
      private var _recordInfo:Player;
      
      private var _body:DisplayObject;
      
      private var _isClose:Boolean = false;
      
      private var _roomPlayerItemPet:RoomPlayerItemPet;
      
      private var _petHeadFrameBg:Bitmap;
      
      private var _showLightPoint:Point;
      
      public function LeftPlayerCartoonView()
      {
         this._showLightPoint = new Point(0,2);
         super();
         this.initView();
      }
      
      public function set isClose(param1:Boolean) : void
      {
         this._isClose = param1;
      }
      
      private function initView() : void
      {
         this._movie = ClassUtils.CreatInstance("asset.game.LeftPlayerCiteAsset");
         this._movie.x = -6;
         addChild(this._movie);
         this._team = ComponentFactory.Instance.creatComponentByStylename("asset.game.leftPlayerViewTitle");
         this._movie["leftCite"].addChild(this._team);
         this._nickName = ComponentFactory.Instance.creatComponentByStylename("asset.game.leftPlayerViewNKNTxt");
         this._movie["leftCite"].addChild(this._nickName);
         this._zoneName = ComponentFactory.Instance.creatComponentByStylename("asset.game.leftPlayerViewZNTxt");
         this._movie["leftCite"].addChild(this._zoneName);
         this._honorName = ComponentFactory.Instance.creatComponentByStylename("asset.game.leftPlayerViewHNNTxt");
         this._movie["leftCite"].addChild(this._honorName);
         this._vipIcon = ComponentFactory.Instance.creatCustomObject("asset.game.VipIcon");
         this._movie["leftCite"].addChild(this._vipIcon);
         this._badge = new Badge();
         this._movie.gotoAndStop(1);
         var _loc1_:int = RoomManager.getTurnTimeByType(RoomManager.Instance.current.timeType);
         this.update();
         addEventListener(Event.ENTER_FRAME,this.__frameFunctionHandler);
      }
      
      private function addPet() : void
      {
         if(RoomManager.Instance.current.type != 5 && RoomManager.Instance.current.type != RoomInfo.ACTIVITY_DUNGEON_ROOM && this._info && this._info.playerInfo && this._info.playerInfo.currentPet && this._info.playerInfo.currentPet.IsEquip)
         {
            if(!this._roomPlayerItemPet)
            {
               this._petHeadFrameBg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.playerItem.petHeadFrame2");
               PositionUtils.setPos(this._petHeadFrameBg,"assets.leftPlayerCartoonView.roomPlayerItemPetHeadFramePos");
               addChild(this._petHeadFrameBg);
               this._roomPlayerItemPet = new RoomPlayerItemPet(this._petHeadFrameBg.width,this._petHeadFrameBg.height);
               PositionUtils.setPos(this._roomPlayerItemPet,"assets.leftPlayerCartoonView.roomPlayerItemPetPos");
               addChild(this._roomPlayerItemPet);
            }
            this._roomPlayerItemPet.updateView(this._info.playerInfo.currentPet);
         }
         else
         {
            this.removePet();
         }
      }
      
      private function removePet() : void
      {
         if(this._petHeadFrameBg)
         {
            ObjectUtils.disposeObject(this._petHeadFrameBg);
         }
         this._petHeadFrameBg = null;
         if(this._roomPlayerItemPet)
         {
            ObjectUtils.disposeObject(this._roomPlayerItemPet);
         }
         this._roomPlayerItemPet = null;
      }
      
      private function __frameFunctionHandler(param1:Event) : void
      {
         if(this._movie.currentFrame == 7)
         {
            this.frameEasingIn();
         }
         if(this._movie.currentFrame == this._movie.totalFrames - 1)
         {
            this.frameEasingOut();
         }
      }
      
      public function set info(param1:Living) : void
      {
         this.updateTimerState(false,false);
         var _loc2_:Boolean = this._info != null;
         if(this._info != param1)
         {
            if(this._info)
            {
               if(this._info.isSelf)
               {
                  this._info.removeEventListener(LivingEvent.BEGIN_SHOOT,this.__stopCountDown);
                  this._info.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__isAttackingChanged);
               }
            }
            this._info = param1;
            if(this._info)
            {
               if(this._info.isSelf && !this._isClose)
               {
                  this._info.addEventListener(LivingEvent.BEGIN_SHOOT,this.__stopCountDown);
                  this._info.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__isAttackingChanged);
               }
               else if(this._isClose)
               {
                  this._info.addEventListener(LivingEvent.BEGIN_SHOOT,this.__stopCountDown);
                  this._info.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__isAttackingChanged);
               }
            }
         }
         if(_loc2_)
         {
            this.easingOut();
         }
         else
         {
            this.easingIn();
         }
      }
      
      public function get info() : Living
      {
         return this._info;
      }
      
      protected function update() : void
      {
         if(this._info)
         {
            this._honorName.text = "";
            if(this._info.isSelf)
            {
               (this._info as LocalPlayer).shootTime = 0;
            }
            if(this._info.isPlayer())
            {
               if(this._info.playerInfo)
               {
                  if(RoomManager.Instance.current.isCrossZone && this._info.team != GameManager.Instance.Current.selfGamePlayer.team)
                  {
                     this._nickName.text = "";
                     this._nickName.text = this._info.playerInfo.NickName;
                     this._zoneName.text = "<" + (this._info as Player).zoneName + ">";
                  }
                  else
                  {
                     this._nickName.text = this._info.playerInfo.NickName;
                     this._zoneName.text = "";
                  }
                  if(this._info.playerInfo.showDesignation)
                  {
                     this._honorName.text = this._info.playerInfo.showDesignation;
                     this._nickName.x = this._honorName.x + this._honorName.width;
                  }
                  else
                  {
                     this._nickName.x = this._honorName.x;
                  }
                  if(this._info.playerInfo.IsVIP)
                  {
                     ObjectUtils.disposeObject(this._vipName);
                     this._vipName = VipController.instance.getVipNameTxt(133,this._info.playerInfo.typeVIP);
                     this._vipName.x = this._nickName.x;
                     this._vipName.y = this._nickName.y;
                     this._vipName.text = this._nickName.text;
                     this._vipIcon.setInfo(this._info.playerInfo,false);
                     this._movie["leftCite"].addChild(this._vipName);
                     this._movie["leftCite"].addChild(this._vipIcon);
                     DisplayUtils.removeDisplay(this._nickName);
                     PositionUtils.setPos(this._badge,"leftPlayerCartoon.BadgePos");
                  }
                  else
                  {
                     this._movie["leftCite"].addChild(this._nickName);
                     DisplayUtils.removeDisplay(this._vipName,this._vipIcon);
                     PositionUtils.setPos(this._badge,this._vipIcon);
                  }
                  if(this._roomPlayerItemPet)
                  {
                     this._roomPlayerItemPet.visible = true;
                  }
                  if(this._petHeadFrameBg)
                  {
                     this._petHeadFrameBg.visible = true;
                  }
               }
               this.addPet();
               if(this._info.playerInfo.badgeID > 0)
               {
                  this._badge.badgeID = this._info.playerInfo.badgeID;
                  this._movie["leftCite"].addChild(this._badge);
               }
               else if(this._badge.parent)
               {
                  this._badge.parent.removeChild(this._badge);
               }
               this._info.character.showGun = false;
               this._info.character.setShowLight(true,this._showLightPoint);
               this.setBodyBitmap(this._info.character.getShowBitmapBig(),true);
            }
            else
            {
               this._nickName.x = this._honorName.x;
               this._nickName.y = this._honorName.y;
               this._nickName.text = this._info.name;
               this._movie["leftCite"].addChild(this._nickName);
               this.setBodyBitmap(this._info.actionMovieBitmap);
               DisplayUtils.removeDisplay(this._vipIcon,this._vipName,this._badge);
               if(this._roomPlayerItemPet)
               {
                  this._roomPlayerItemPet.visible = false;
               }
               if(this._petHeadFrameBg)
               {
                  this._petHeadFrameBg.visible = false;
               }
            }
            this._team.setFrame(this._info.team);
         }
         else
         {
            this.setBodyBitmap(null);
            this._nickName.text = "";
            DisplayUtils.removeDisplay(this._vipIcon,this._vipName,this._badge);
         }
      }
      
      private function showHonorName() : void
      {
         if(this._info.playerInfo.honor == "" || !this._info.playerInfo.honor)
         {
            this._honorName.text = "";
            this._nickName.x = this._vipName.x = this._honorName.x;
            this._nickName.y = this._vipName.y = this._honorName.y;
         }
         else
         {
            this._honorName.text = this._info.playerInfo.honor;
            this._nickName.x = this._vipName.x = this._honorName.x + this._honorName.width;
         }
      }
      
      private function setBodyBitmap(param1:DisplayObject, param2:Boolean = false) : void
      {
         if(this._body != param1)
         {
            if(this._body && this._body.parent)
            {
               this._movie["leftCite"].removeChild(this._body);
            }
            this._body = param1;
            if(this._body)
            {
               if(param2)
               {
                  this._body.scaleX = -1;
                  if(this._info.playerInfo.getShowSuits() && this._info.playerInfo.getSuitsType() == 1)
                  {
                     this._body.y = -18;
                  }
                  else
                  {
                     this._body.y = -3;
                  }
                  this._body.x = this._body.width * 0.5 + 65;
               }
               else if(this._body.height > 120)
               {
                  this._body.x = 10;
                  this._body.y = 35 - this._body.height + 112;
               }
               else
               {
                  this._body.x = 80 - this._body.width * 0.5;
                  this._body.y = 85 - this._body.height * 0.5;
               }
               this._movie["leftCite"].addChildAt(this._body,1);
            }
         }
      }
      
      private function easingIn() : void
      {
         this.update();
         this._movie.gotoAndPlay(1);
      }
      
      private function easingOut() : void
      {
         this._movie.gotoAndPlay(8);
      }
      
      private function frameEasingIn() : void
      {
         this._movie.stop();
      }
      
      private function frameEasingOut() : void
      {
         if(this._info)
         {
            this.easingIn();
         }
         else
         {
            this._movie.stop();
         }
      }
      
      public function updateTimerState(param1:Boolean, param2:Boolean) : void
      {
         if(param1)
         {
            if(this._info && this._info.isSelf)
            {
            }
            if(!param2)
            {
            }
         }
      }
      
      private function __isAttackingChanged(param1:LivingEvent) : void
      {
         if((this._info as TurnedLiving).isAttacking)
         {
            this.updateTimerState(true,true);
            if(this._info.isSelf)
            {
            }
         }
         else
         {
            this.updateTimerState(true,false);
         }
      }
      
      private function __stopCountDown(param1:LivingEvent) : void
      {
      }
      
      private function __skip(param1:Event = null) : void
      {
         if(this._info && this._info.isSelf)
         {
            SoundManager.instance.play("008");
            this.skip();
         }
      }
      
      public function skip() : void
      {
         this.updateTimerState(true,false);
         (this._info as LocalPlayer).skip();
      }
      
      public function gameOver() : void
      {
         this.info = null;
      }
      
      public function dispose() : void
      {
         if(this._info)
         {
            this._info.removeEventListener(LivingEvent.BEGIN_SHOOT,this.__stopCountDown);
            this._info.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__isAttackingChanged);
         }
         this._info = null;
         if(this._badge)
         {
            this._badge.dispose();
         }
         this._badge = null;
         if(this._vipIcon)
         {
            this._vipIcon.dispose();
         }
         this._vipIcon = null;
         this._movie["leftCite"].gotoAndStop(1);
         removeChild(this._movie);
         this._movie = null;
         this._showLightPoint = null;
         this._team.dispose();
         this._team = null;
         this._nickName.dispose();
         this._nickName = null;
         if(this._vipName)
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         this._zoneName.dispose();
         this._zoneName = null;
         this._honorName.dispose();
         this._honorName = null;
         removeEventListener(Event.ENTER_FRAME,this.__frameFunctionHandler);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
