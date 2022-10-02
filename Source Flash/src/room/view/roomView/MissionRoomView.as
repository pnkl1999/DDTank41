package room.view.roomView
{
   import LimitAward.LimitAwardButton;
   import calendar.CalendarManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.DungeonInfo;
   import ddt.manager.BossBoxManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.MapManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import ddt.view.bossbox.SmallBoxButton;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.view.RoomPlayerItem;
   import room.view.bigMapInfoPanel.MissionRoomBigMapInfoPanel;
   import room.view.smallMapInfoPanel.MissionRoomSmallMapInfoPanel;
   
   public class MissionRoomView extends BaseRoomView
   {
       
      
      private var _bigMapInfoPanel:MissionRoomBigMapInfoPanel;
      
      private var _smallMapInfoPanel:MissionRoomSmallMapInfoPanel;
      
      private var _rightBg:Scale9CornerImage;
      
      private var _playerItemContainer:SimpleTileList;
      
      private var _boxButton:SmallBoxButton;
      
      private var _limitAwardButton:LimitAwardButton;
      
      private var _btnSwitchTeam:BaseButton;
      
      public function MissionRoomView(param1:RoomInfo)
      {
         super(param1);
         _info.started = false;
      }
      
      override protected function initView() : void
      {
         this._rightBg = ComponentFactory.Instance.creatComponentByStylename("asset.room.roomBg");
         addChild(this._rightBg);
         this.initPanel();
         this._btnSwitchTeam = ComponentFactory.Instance.creatComponentByStylename("asset.room.switchTeamBtn");
         addChild(this._btnSwitchTeam);
         this._btnSwitchTeam.enable = false;
         if(BossBoxManager.instance.isShowBoxButton())
         {
            this._boxButton = new SmallBoxButton(SmallBoxButton.PVP_ROOM_POINT);
            addChild(this._boxButton);
         }
         if(CalendarManager.getInstance().checkEventInfo() && PlayerManager.Instance.Self.Grade >= 8)
         {
            if(!this._limitAwardButton)
            {
               this._limitAwardButton = new LimitAwardButton(LimitAwardButton.PVP_ROOM_POINT);
               addChild(this._limitAwardButton);
            }
         }
         super.initView();
      }
      
      override protected function checkCanStartGame() : Boolean
      {
         var _loc1_:DungeonInfo = MapManager.getDungeonInfo(_info.mapId);
         if(super.checkCanStartGame())
         {
            if(_loc1_.Type == MapManager.PVE_ACADEMY_MAP && !super.academyDungeonAllow())
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      protected function initPanel() : void
      {
         this._bigMapInfoPanel = ComponentFactory.Instance.creatCustomObject("room.missionBigMapInfoPanel");
         addChild(this._bigMapInfoPanel);
         this._smallMapInfoPanel = ComponentFactory.Instance.creatCustomObject("room.missionSmallMapInfoPanel");
         this._smallMapInfoPanel.info = _info;
         addChild(this._smallMapInfoPanel);
      }
      
      override protected function initTileList() : void
      {
         var _loc2_:Point = null;
         _loc2_ = null;
         var _loc4_:RoomPlayerItem = null;
         super.initTileList();
         this._playerItemContainer = new SimpleTileList(2);
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("room.dungeonRoom.listSpace");
         this._playerItemContainer.hSpace = _loc1_.x;
         this._playerItemContainer.vSpace = _loc1_.y;
         _loc2_ = ComponentFactory.Instance.creatCustomObject("asset.room.playerListPos");
         this._playerItemContainer.x = this._rightBg.x + _loc2_.x;
         this._playerItemContainer.y = this._rightBg.y + _loc2_.y;
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            _loc4_ = new RoomPlayerItem(_loc3_);
            this._playerItemContainer.addChild(_loc4_);
            _playerItems.push(_loc4_);
            _loc3_++;
         }
         addChild(this._playerItemContainer);
         PositionUtils.setPos(_viewerItems[0],"asset.challengeroom.ViewerItemPos_0");
         PositionUtils.setPos(_viewerItems[1],"asset.challengeroom.ViewerItemPos_1");
         addChild(_viewerItems[0]);
         addChild(_viewerItems[1]);
      }
      
      override protected function prepareGame() : void
      {
         GameInSocketOut.sendGameMissionPrepare(_info.selfRoomPlayer.place,true);
         GameInSocketOut.sendPlayerState(1);
      }
      
      override protected function startGame() : void
      {
         GameInSocketOut.sendGameMissionStart(true);
      }
      
      override protected function __onHostTimer(param1:TimerEvent) : void
      {
         if(_info.selfRoomPlayer.isHost)
         {
            if(_hostTimer.currentCount >= KICK_TIMEIII && _info.players.length - _info.currentViewerCnt > 1)
            {
               this.kickHandler();
            }
            else if(_hostTimer.currentCount >= KICK_TIMEII && _info.players.length - _info.currentViewerCnt == 1)
            {
               this.kickHandler();
            }
            else if(_hostTimer.currentCount >= KICK_TIME && _info.players.length - _info.currentViewerCnt > 1 && _info.currentViewerCnt == 0 && _info.isAllReady())
            {
               this.kickHandler();
            }
            else if(_hostTimer.currentCount >= HURRY_UP_TIME && _info.isAllReady())
            {
               if(!TaskManager.isShow)
               {
                  if(!SoundManager.instance.isPlaying("007"))
                  {
                     SoundManager.instance.play("007",false,true);
                  }
               }
               else
               {
                  SoundManager.instance.stop("007");
               }
            }
         }
      }
      
      override protected function kickHandler() : void
      {
      }
      
      override protected function __cancelClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!RoomManager.Instance.current.selfRoomPlayer.isHost)
         {
            GameInSocketOut.sendGameMissionPrepare(_info.selfRoomPlayer.place,false);
            GameInSocketOut.sendPlayerState(0);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._limitAwardButton)
         {
            ObjectUtils.disposeObject(this._limitAwardButton);
         }
         this._limitAwardButton = null;
         this._bigMapInfoPanel.dispose();
         this._smallMapInfoPanel.dispose();
         this._rightBg.dispose();
         this._playerItemContainer.dispose();
         this._bigMapInfoPanel = null;
         this._smallMapInfoPanel = null;
         this._rightBg = null;
         this._playerItemContainer = null;
         if(this._boxButton)
         {
            BossBoxManager.instance.deleteBoxButton();
            ObjectUtils.disposeObject(this._boxButton);
         }
         this._boxButton = null;
      }
   }
}
