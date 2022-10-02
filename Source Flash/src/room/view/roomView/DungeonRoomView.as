package room.view.roomView
{
   import LimitAward.LimitAwardButton;
   import calendar.CalendarManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.DungeonInfo;
   import ddt.events.RoomEvent;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.QueueManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.bossbox.SmallBoxButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.view.RoomDupSimpleTipFram;
   import room.view.RoomPlayerItem;
   import room.view.bigMapInfoPanel.DungeonBigMapInfoPanel;
   import room.view.chooseMap.DungeonChooseMapFrame;
   import room.view.smallMapInfoPanel.DungeonSmallMapInfoPanel;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   import trainer.view.VaneTipView;
   
   public class DungeonRoomView extends BaseRoomView
   {
       
      
      private var _bigMapInfoPanel:DungeonBigMapInfoPanel;
      
      private var _smallMapInfoPanel:DungeonSmallMapInfoPanel;
      
      private var _rightBg:Scale9CornerImage;
      
      private var _playerItemContainer:SimpleTileList;
      
      private var _btnSwitchTeam:BaseButton;
      
      private var _boxButton:SmallBoxButton;
      
      private var _limitAwardButton:LimitAwardButton;
      
      private var _singleAlsert:BaseAlerFrame;
      
      public function DungeonRoomView(param1:RoomInfo)
      {
         super(param1);
      }
      
      override protected function initView() : void
      {
         if(QueueManager.facebookResumeEnable)
         {
            QueueManager.resumeFaceBookFeed();
         }
         this._bigMapInfoPanel = ComponentFactory.Instance.creatCustomObject("room.dungeonBigMapInfoPanel");
         addChild(this._bigMapInfoPanel);
         this._smallMapInfoPanel = ComponentFactory.Instance.creatCustomObject("room.dungeonSmallMapInfoPanel");
         this._smallMapInfoPanel.info = _info;
         addChild(this._smallMapInfoPanel);
         this._rightBg = ComponentFactory.Instance.creatComponentByStylename("asset.room.roomBg");
         addChild(this._rightBg);
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
         this._showBoGuTip();
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         this._bigMapInfoPanel.addEventListener(RoomEvent.OPEN_DUNGEON_CHOOSER,this.__onOpenMapChooser);
         addEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
      }
      
      override protected function __prepareClick(param1:MouseEvent) : void
      {
         super.__prepareClick(param1);
         if(PlayerManager.Instance.Self.dungeonFlag[_info.mapId] && PlayerManager.Instance.Self.dungeonFlag[_info.mapId] == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.reduceGains"));
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.room.RoomIIController.reduceGains"));
         }
      }
      
      override protected function removeEvents() : void
      {
         super.removeEvents();
         this._bigMapInfoPanel.removeEventListener(RoomEvent.OPEN_DUNGEON_CHOOSER,this.__onOpenMapChooser);
         removeEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
      }
      
      private function __loadWeakGuild(param1:Event) : void
      {
         var _loc2_:VaneTipView = null;
         removeEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         if(!WeakGuildManager.Instance.switchUserGuide)
         {
            return;
         }
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VANE_TIP) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VANE_OPEN))
         {
            _loc2_ = ComponentFactory.Instance.creat("trainer.vane.mainFrame");
            _loc2_.show();
         }
      }
      
      private function __onOpenMapChooser(param1:RoomEvent) : void
      {
         this._smallMapInfoPanel.stopShine();
      }
      
      override protected function initTileList() : void
      {
         var _loc2_:Point = null;
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
         if(isViewerRoom)
         {
            PositionUtils.setPos(_viewerItems[0],"asset.challengeroom.ViewerItemPos_0");
            PositionUtils.setPos(_viewerItems[1],"asset.challengeroom.ViewerItemPos_1");
            addChild(_viewerItems[0]);
            addChild(_viewerItems[1]);
         }
      }
      
      override protected function checkCanStartGame() : Boolean
      {
         var _loc2_:DungeonChooseMapFrame = null;
         var _loc1_:DungeonInfo = MapManager.getDungeonInfo(_info.mapId);
         if(super.checkCanStartGame())
         {
            if(_info.type == RoomInfo.FRESHMAN_ROOM)
            {
               return true;
            }
            if(_info.mapId == 0 || _info.mapId == 10000)
            {
               _loc2_ = ComponentFactory.Instance.creatCustomObject("asset.room.dungeonChooseMapFrame");
               _loc2_.show();
               dispatchEvent(new RoomEvent(RoomEvent.OPEN_DUNGEON_CHOOSER));
               return false;
            }
            if(RoomManager.Instance.current.players.length - RoomManager.Instance.current.currentViewerCnt == 1 && _loc1_.Type != MapManager.PVE_ACADEMY_MAP)
            {
               this._singleAlsert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.clewContent"),"",LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               this._singleAlsert.moveEnable = false;
               this._singleAlsert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
               return false;
            }
            if(_loc1_.Type == MapManager.PVE_ACADEMY_MAP && !super.academyDungeonAllow())
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         this._singleAlsert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._singleAlsert.dispose();
         this._singleAlsert = null;
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            startGame();
         }
      }
      
      override protected function kickHandler() : void
      {
         GameInSocketOut.sendGameRoomSetUp(10000,RoomInfo.DUNGEON_ROOM,false,_info.roomPass,_info.roomName,1,0,0,false,0);
         super.kickHandler();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._boxButton)
         {
            BossBoxManager.instance.deleteBoxButton();
            ObjectUtils.disposeObject(this._boxButton);
         }
         if(this._limitAwardButton)
         {
            ObjectUtils.disposeObject(this._limitAwardButton);
         }
         this._limitAwardButton = null;
         if(this._singleAlsert)
         {
            this._singleAlsert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            this._singleAlsert.dispose();
            this._singleAlsert = null;
         }
         this._boxButton = null;
         this._bigMapInfoPanel.dispose();
         this._bigMapInfoPanel = null;
         this._smallMapInfoPanel.dispose();
         this._smallMapInfoPanel = null;
         this._rightBg.dispose();
         this._rightBg = null;
         this._playerItemContainer.dispose();
         this._playerItemContainer = null;
         this._btnSwitchTeam.dispose();
         this._btnSwitchTeam = null;
      }
      
      private function sendStartGame() : void
      {
         __startClick(null);
         SoundManager.instance.play("008");
      }
      
      private function _showBoGuTip() : void
      {
         var _loc1_:RoomDupSimpleTipFram = null;
         if(PlayerManager.Instance.Self._isDupSimpleTip)
         {
            PlayerManager.Instance.Self._isDupSimpleTip = false;
            _loc1_ = ComponentFactory.Instance.creatComponentByStylename("room.RoomDupSimpleTipFram");
            _loc1_.show();
         }
      }
   }
}
