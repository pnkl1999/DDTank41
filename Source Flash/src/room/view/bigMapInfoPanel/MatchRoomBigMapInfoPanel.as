package room.view.bigMapInfoPanel
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.RoomEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.MainToolBar;
   import ddt.view.SelectStateButton;
   import eliteGame.EliteGameController;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import room.model.RoomInfo;
   
   public class MatchRoomBigMapInfoPanel extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _info:RoomInfo;
      
      private var _guildModeBtn:SelectStateButton;
      
      private var _freeModeBtn:SelectStateButton;
      
      private var _gameModeIcon:ScaleFrameImage;
      
      private var _matchingPic:Bitmap;
      
      private var _timeTxt:FilterFrameText;
      
      private var _timer:Timer;
      
      private var _eliteGame:Bitmap;
      
      private var _eliteGameTimer:Timer;
      
      private var _eliteTime:int;
      
      public function MatchRoomBigMapInfoPanel()
      {
         super();
         this.initView();
         this._freeModeBtn.addEventListener(MouseEvent.CLICK,this.__freeClickHandler);
         this._guildModeBtn.addEventListener(MouseEvent.CLICK,this.__guildClickHandler);
      }
      
      protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.room.view.bigMapInfoPanel.mathRoomBigMapInfoPanelBgAsset");
         addChild(this._bg);
         this._freeModeBtn = ComponentFactory.Instance.creatCustomObject("asset.room.view.bigMapInfoPanel.freeModeButton");
         this._freeModeBtn.backGround = ComponentFactory.Instance.creatBitmap("asset.room.view.bigMapInfoPanel.freeModeBtnAsset");
         this._freeModeBtn.overBackGround = ComponentFactory.Instance.creatBitmap("asset.room.view.bigMapInfoPanel.freeModeBtnOverAsset");
         addChild(this._freeModeBtn);
         this._guildModeBtn = ComponentFactory.Instance.creatCustomObject("asset.room.view.bigMapInfoPanel.guildModeButton");
         this._guildModeBtn.backGround = ComponentFactory.Instance.creatBitmap("asset.room.view.bigMapInfoPanel.guildModeBtnAsset");
         this._guildModeBtn.overBackGround = ComponentFactory.Instance.creatBitmap("asset.room.view.bigMapInfoPanel.guildModeBtnOverAsset");
         addChild(this._guildModeBtn);
         this._eliteGame = ComponentFactory.Instance.creatBitmap("asset.room.view.bigMapInfoPanel.eliteGameBtnAsset");
         addChild(this._eliteGame);
         this._eliteGame.visible = false;
         this._freeModeBtn.selected = this._freeModeBtn.enable = this._guildModeBtn.selected = this._guildModeBtn.enable = false;
         this._freeModeBtn.gray = this._freeModeBtn.gray = true;
         this._gameModeIcon = ComponentFactory.Instance.creatComponentByStylename("asset.room.view.bigMapInfoPanel.gameModeIcon");
         this._gameModeIcon.setFrame(1);
         addChild(this._gameModeIcon);
         this._gameModeIcon.visible = false;
         this._matchingPic = ComponentFactory.Instance.creatBitmap("asset.room.view.bigMapInfoPanel.matchingTxtAsset");
         this._matchingPic.visible = false;
         addChild(this._matchingPic);
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("room.timeTxt");
         addChild(this._timeTxt);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timer);
      }
      
      public function set info(param1:RoomInfo) : void
      {
         if(this._info)
         {
            this._info.removeEventListener(RoomEvent.GAME_MODE_CHANGE,this.__update);
            this._info.removeEventListener(RoomEvent.STARTED_CHANGED,this.__startedHandler);
            this._info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED,this.__update);
            this._info.removeEventListener(RoomEvent.ADD_PLAYER,this.__update);
            this._info.removeEventListener(RoomEvent.REMOVE_PLAYER,this.__update);
            this._info.removeEventListener(RoomEvent.ROOMPLACE_CHANGED,this.__update);
            this._info = null;
         }
         this._info = param1;
         if(this._info)
         {
            this._info.addEventListener(RoomEvent.GAME_MODE_CHANGE,this.__update);
            this._info.addEventListener(RoomEvent.STARTED_CHANGED,this.__startedHandler);
            this._info.addEventListener(RoomEvent.PLAYER_STATE_CHANGED,this.__update);
            this._info.addEventListener(RoomEvent.ADD_PLAYER,this.__update);
            this._info.addEventListener(RoomEvent.REMOVE_PLAYER,this.__update);
            this._info.addEventListener(RoomEvent.ROOMPLACE_CHANGED,this.__update);
            if(this._info.type == RoomInfo.RANK_ROOM)
            {
               this._eliteTime = EliteGameController.Instance.leftTime;
               this._timeTxt.text = this._eliteTime < 10 ? "0" + this._eliteTime : this._eliteTime.toString();
               this._eliteGameTimer = new Timer(1000);
               this._eliteGameTimer.addEventListener(TimerEvent.TIMER,this.__eliteGameTimerHandler);
               this._eliteGameTimer.start();
            }
         }
         this.updateView();
         this.updateBtns();
      }
      
      private function __eliteGameTimerHandler(param1:TimerEvent) : void
      {
         --this._eliteTime;
         this._eliteTime = this._eliteTime < 0 ? int(int(0)) : int(int(this._eliteTime));
         this._timeTxt.text = this._eliteTime < 10 ? "0" + this._eliteTime : this._eliteTime + "";
      }
      
      private function __update(param1:RoomEvent) : void
      {
         this.updateView();
         this.updateBtns();
      }
      
      private function __startedHandler(param1:RoomEvent) : void
      {
         if(this._info.started)
         {
            if(!this._timer.running)
            {
               if(this._eliteGameTimer)
               {
                  this._eliteGameTimer.removeEventListener(TimerEvent.TIMER,this.__eliteGameTimerHandler);
                  this._eliteGameTimer = null;
               }
               this._timeTxt.text = "00";
               this._timer.start();
            }
         }
         else
         {
            this._timer.stop();
            this._timer.reset();
            if(this._info.gameMode == RoomInfo.BOTH_MODE && this._info.selfRoomPlayer.isHost)
            {
               SocketManager.Instance.out.sendGameStyle(RoomInfo.GUILD_MODE);
            }
         }
         this.updateView();
         this.updateBtns();
      }
      
      private function __timer(param1:TimerEvent) : void
      {
         var _loc2_:uint = this._timer.currentCount / 60;
         var _loc3_:uint = this._timer.currentCount % 60;
         this._timeTxt.text = _loc3_ > 9 ? _loc3_.toString() : "0" + _loc3_;
         if(this._timer.currentCount == 20)
         {
            if(!this._info.selfRoomPlayer.isHost && !this._info.selfRoomPlayer.isViewer)
            {
               MainToolBar.Instance.setReturnEnable(true);
               dispatchEvent(new RoomEvent(RoomEvent.TWEENTY_SEC));
            }
         }
      }
      
      private function updateView() : void
      {
         if(this._freeModeBtn && this._gameModeIcon && this._matchingPic)
         {
            if(this._info)
            {
               if(this._info.type == RoomInfo.RANK_ROOM)
               {
                  this._gameModeIcon.visible = this._matchingPic.visible = this._timeTxt.visible = true;
                  this._matchingPic.visible = this._info.started;
                  this._eliteGame.visible = this._freeModeBtn.visible = this._guildModeBtn.visible = false;
                  this._gameModeIcon.setFrame(3);
               }
               else if(this._info.type == RoomInfo.SCORE_ROOM)
               {
                  this._gameModeIcon.visible = this._matchingPic.visible = this._timeTxt.visible = this._info.started;
                  this._eliteGame.visible = !this._info.started;
                  this._freeModeBtn.visible = this._guildModeBtn.visible = false;
                  this._gameModeIcon.setFrame(3);
               }
               else
               {
                  this._eliteGame.visible = false;
                  this._freeModeBtn.visible = this._guildModeBtn.visible = !this._info.started;
                  this._gameModeIcon.visible = this._matchingPic.visible = this._timeTxt.visible = this._info.started;
                  if(this._info.gameMode != RoomInfo.BOTH_MODE)
                  {
                     this._gameModeIcon.setFrame(this._info.gameMode + 1);
                  }
                  if(this._info.gameMode == RoomInfo.LEAGE_ROOM)
                  {
                     this._gameModeIcon.setFrame(1);
                  }
                  if(this._info.gameMode == RoomInfo.GUILD_LEAGE_MODE)
                  {
                     this._gameModeIcon.setFrame(2);
                  }
               }
            }
            else
            {
               this._eliteGame.visible = this._freeModeBtn.visible = this._guildModeBtn.visible = this._gameModeIcon.visible = this._matchingPic.visible = this._timeTxt.visible = false;
            }
         }
      }
      
      private function updateBtns() : void
      {
         var _loc1_:Boolean = false;
         _loc1_ = this._info.canPlayGuidMode();
         if(this._freeModeBtn && this._gameModeIcon)
         {
            this._guildModeBtn.selected = this._info && this._info.gameMode == RoomInfo.GUILD_MODE || this._info && this._info.gameMode == RoomInfo.GUILD_LEAGE_MODE;
            this._freeModeBtn.selected = this._info && this._info.gameMode == RoomInfo.FREE_MODE || this._info && this._info.gameMode == RoomInfo.LEAGE_ROOM;
            this._freeModeBtn.enable = this._freeModeBtn.buttonMode = this._info && this._info.selfRoomPlayer.isHost;
            this._guildModeBtn.enable = this._guildModeBtn.buttonMode = this._info && this._info.selfRoomPlayer.isHost && _loc1_;
            this._freeModeBtn.gray = false;
            this._freeModeBtn.buttonMode = this._info && _loc1_ && this._info.selfRoomPlayer.isHost;
            this._guildModeBtn.gray = !(this._info && _loc1_);
         }
      }
      
      private function __freeClickHandler(param1:MouseEvent) : void
      {
         if(this._info && this._info.canPlayGuidMode())
         {
            SoundManager.instance.play("008");
         }
         SocketManager.Instance.out.sendGameStyle(RoomInfo.FREE_MODE);
      }
      
      private function __guildClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendGameStyle(RoomInfo.GUILD_MODE);
      }
      
      private function removeEvents() : void
      {
         if(this._info)
         {
            this._info.removeEventListener(RoomEvent.GAME_MODE_CHANGE,this.__update);
            this._info.removeEventListener(RoomEvent.STARTED_CHANGED,this.__startedHandler);
            this._info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED,this.__update);
            this._info.removeEventListener(RoomEvent.ADD_PLAYER,this.__update);
            this._info.removeEventListener(RoomEvent.REMOVE_PLAYER,this.__update);
         }
         if(this._eliteGameTimer)
         {
            this._eliteGameTimer.removeEventListener(TimerEvent.TIMER,this.__eliteGameTimerHandler);
            this._eliteGameTimer.stop();
         }
         this._timer.removeEventListener(TimerEvent.TIMER,this.__timer);
         this._freeModeBtn.removeEventListener(MouseEvent.CLICK,this.__freeClickHandler);
         this._guildModeBtn.removeEventListener(MouseEvent.CLICK,this.__guildClickHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._guildModeBtn);
         this._guildModeBtn = null;
         ObjectUtils.disposeObject(this._freeModeBtn);
         this._freeModeBtn = null;
         ObjectUtils.disposeObject(this._gameModeIcon);
         this._gameModeIcon = null;
         ObjectUtils.disposeObject(this._matchingPic);
         this._matchingPic = null;
         ObjectUtils.disposeObject(this._timeTxt);
         this._timeTxt = null;
         this._timer.stop();
         this._timer = null;
         this._eliteGameTimer = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
