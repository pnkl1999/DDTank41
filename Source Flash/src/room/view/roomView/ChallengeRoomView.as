package room.view.roomView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.data.player.SelfInfo;
   import ddt.events.RoomEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import game.view.DefyAfficheViewFrame;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.view.RoomPlayerItem;
   import room.view.smallMapInfoPanel.ChallengeRoomSmallMapInfoPanel;
   
   public class ChallengeRoomView extends BaseRoomView implements Disposeable
   {
      
      public static const PLAYER_POS_CHANGE:String = "playerposchange";
       
      
      private var _bg:Bitmap;
      
      private var _btnSwitchTeam:BaseButton;
      
      private var _playerItemContainers:Vector.<SimpleTileList>;
      
      private var _smallMapInfoPanel:ChallengeRoomSmallMapInfoPanel;
      
      private var _blueTeamBitmap:Bitmap;
      
      private var _redTeamBitmap:Bitmap;
      
      private var _self:SelfInfo;
      
      public function ChallengeRoomView(param1:RoomInfo)
      {
         super(param1);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._btnSwitchTeam.dispose();
         this._smallMapInfoPanel.dispose();
         this._bg = null;
         this._btnSwitchTeam = null;
         this._playerItemContainers = null;
         this._smallMapInfoPanel = null;
      }
      
      override protected function updateButtons() : void
      {
         var _loc4_:RoomPlayerItem = null;
         super.updateButtons();
         if(_info.selfRoomPlayer.isViewer)
         {
            this._btnSwitchTeam.enable = false;
            return;
         }
         if(RoomManager.Instance.current.selfRoomPlayer.isHost)
         {
            this._btnSwitchTeam.enable = _startBtn.visible;
            _cancelBtn.visible = !_startBtn.visible;
         }
         else
         {
            this._btnSwitchTeam.enable = _prepareBtn.visible;
            _cancelBtn.visible = !_prepareBtn.visible;
         }
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < _playerItems.length)
         {
            _loc4_ = _playerItems[_loc3_] as RoomPlayerItem;
            if(_loc4_.info && _loc4_.info.team == RoomPlayer.BLUE_TEAM)
            {
               _loc1_ = true;
            }
            if(_loc4_.info && _loc4_.info.team == RoomPlayer.RED_TEAM)
            {
               _loc2_ = true;
            }
            _loc3_++;
         }
         if(!_loc1_ || !_loc2_)
         {
            _startBtn.removeEventListener(MouseEvent.CLICK,__startClick);
            _startBtn.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
            _startBtn.gotoAndStop(1);
            _startBtn.buttonMode = false;
         }
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         this._btnSwitchTeam.addEventListener(MouseEvent.CLICK,this.__switchTeam);
      }
      
      override protected function initTileList() : void
      {
         var _loc2_:RoomPlayerItem = null;
         var _loc3_:RoomPlayerItem = null;
         super.initTileList();
         this._playerItemContainers = new Vector.<SimpleTileList>();
         this._playerItemContainers[RoomPlayer.BLUE_TEAM - 1] = new SimpleTileList(2);
         this._playerItemContainers[RoomPlayer.RED_TEAM - 1] = new SimpleTileList(2);
         this._playerItemContainers[RoomPlayer.BLUE_TEAM - 1].hSpace = this._playerItemContainers[RoomPlayer.RED_TEAM - 1].hSpace = 2;
         this._playerItemContainers[RoomPlayer.BLUE_TEAM - 1].vSpace = this._playerItemContainers[RoomPlayer.RED_TEAM - 1].vSpace = 4;
         PositionUtils.setPos(this._playerItemContainers[RoomPlayer.BLUE_TEAM - 1],"room.ChallengeBlueTeamPos");
         PositionUtils.setPos(this._playerItemContainers[RoomPlayer.RED_TEAM - 1],"room.ChallengeRedTeamPos");
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = new RoomPlayerItem(_loc1_);
            this._playerItemContainers[RoomPlayer.BLUE_TEAM - 1].addChild(_loc2_);
            _playerItems.push(_loc2_);
            _loc3_ = new RoomPlayerItem(_loc1_ + 1);
            this._playerItemContainers[RoomPlayer.RED_TEAM - 1].addChild(_loc3_);
            _playerItems.push(_loc3_);
            _loc1_ += 2;
         }
         addChild(this._playerItemContainers[RoomPlayer.BLUE_TEAM - 1]);
         addChild(this._playerItemContainers[RoomPlayer.RED_TEAM - 1]);
         PositionUtils.setPos(_viewerItems[0],"asset.challengeroom.ViewerItemPos_0");
         PositionUtils.setPos(_viewerItems[1],"asset.challengeroom.ViewerItemPos_1");
         addChild(_viewerItems[0]);
         addChild(_viewerItems[1]);
      }
      
      override protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.room.ChallengeRoomBg1");
         this._smallMapInfoPanel = ComponentFactory.Instance.creatCustomObject("room.challengeRoomSmallMapInfoPanel");
         this._btnSwitchTeam = ComponentFactory.Instance.creatComponentByStylename("asset.room.switchTeamBtn");
         this._blueTeamBitmap = ComponentFactory.Instance.creatBitmap("asset.room.BlueTeam");
         this._redTeamBitmap = ComponentFactory.Instance.creatBitmap("asset.room.RedTeam");
         this._smallMapInfoPanel.info = _info;
         this._self = PlayerManager.Instance.Self;
         addChild(this._bg);
         addChild(this._blueTeamBitmap);
         addChild(this._redTeamBitmap);
         addChild(this._btnSwitchTeam);
         addChild(this._smallMapInfoPanel);
         super.initView();
         if(!_info.selfRoomPlayer.isViewer)
         {
            this.openDefyAffiche();
         }
      }
      
      private function openDefyAffiche() : void
      {
         var _loc2_:DefyAfficheViewFrame = null;
         if(!_info || !_info.defyInfo)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ <= _info.defyInfo[0].length)
         {
            if(this._self.NickName == _info.defyInfo[0][_loc1_])
            {
               if(_info.defyInfo[1].length != 0)
               {
                  _loc2_ = ComponentFactory.Instance.creatComponentByStylename("game.view.defyAfficheViewFrame");
                  _loc2_.roomInfo = _info;
                  _loc2_.show();
               }
            }
            _loc1_++;
         }
      }
      
      override protected function __updatePlayerItems(param1:RoomEvent) : void
      {
         initPlayerItems();
         this.updateButtons();
      }
      
      override protected function removeEvents() : void
      {
         super.removeEvents();
         this._btnSwitchTeam.removeEventListener(MouseEvent.CLICK,this.__switchTeam);
      }
      
      private function __switchTeam(param1:MouseEvent) : void
      {
         SoundManager.instance.play("012");
         if(!_info.selfRoomPlayer.isReady || _info.selfRoomPlayer.isHost)
         {
            GameInSocketOut.sendGameTeam(int(_info.selfRoomPlayer.team == RoomPlayer.BLUE_TEAM ? RoomPlayer.RED_TEAM : RoomPlayer.BLUE_TEAM));
         }
      }
   }
}
