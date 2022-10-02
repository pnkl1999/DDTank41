package room.view.bigMapInfoPanel
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.events.RoomEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.events.MouseEvent;
   import room.RoomManager;
   import room.view.chooseMap.DungeonChooseMapFrame;
   
   public class DungeonBigMapInfoPanel extends MissionRoomBigMapInfoPanel
   {
       
      
      private var _chooseBtn:SimpleBitmapButton;
      
      public function DungeonBigMapInfoPanel()
      {
         super();
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         this._chooseBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._chooseBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this._chooseBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         _info.addEventListener(RoomEvent.STARTED_CHANGED,this.__onGameStarted);
         _info.addEventListener(RoomEvent.PLAYER_STATE_CHANGED,this.__playerStateChange);
         _info.addEventListener(RoomEvent.OPEN_BOSS_CHANGED,this.__openBossChange);
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(RoomManager.Instance.current.isOpenBoss)
         {
            this._chooseBtn.visible = false;
            return;
         }
         var _loc2_:DungeonChooseMapFrame = ComponentFactory.Instance.creatCustomObject("asset.room.dungeonChooseMapFrame");
         _loc2_.show();
         dispatchEvent(new RoomEvent(RoomEvent.OPEN_DUNGEON_CHOOSER));
      }
      
      private function __outHandler(param1:MouseEvent) : void
      {
         if(_info.mapId != 0 && _info.mapId != 10000)
         {
            this._chooseBtn.alpha = 0;
         }
         else
         {
            if(RoomManager.Instance.current.isOpenBoss)
            {
               this._chooseBtn.visible = false;
               return;
            }
            this._chooseBtn.alpha = 1;
         }
      }
      
      private function __overHandler(param1:MouseEvent) : void
      {
         if(RoomManager.Instance.current.isOpenBoss)
         {
            this._chooseBtn.visible = false;
            return;
         }
         this._chooseBtn.alpha = 1;
      }
      
      override protected function removeEvents() : void
      {
         super.removeEvents();
         this._chooseBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._chooseBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this._chooseBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         _info.removeEventListener(RoomEvent.STARTED_CHANGED,this.__onGameStarted);
         _info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED,this.__playerStateChange);
         _info.removeEventListener(RoomEvent.OPEN_BOSS_CHANGED,this.__openBossChange);
      }
      
      override protected function initView() : void
      {
         _bg = ComponentFactory.Instance.creatBitmap("asset.room.view.bigMapInfoPanel.mathRoomBigMapInfoPanelBgAsset");
         addChild(_bg);
         _mapShowContainer = ComponentFactory.Instance.creatCustomObject("asset.room.bigMapIconContainer");
         addChild(_mapShowContainer);
         _pos1 = ComponentFactory.Instance.creatCustomObject("room.dropListPos1");
         _pos2 = ComponentFactory.Instance.creatCustomObject("room.dropListPos2");
         this._chooseBtn = ComponentFactory.Instance.creatComponentByStylename("asset.room.selectDungeonButton");
         this._chooseBtn.transparentEnable = true;
         this._chooseBtn.displacement = false;
         this._chooseBtn.visible = false;
         addChild(this._chooseBtn);
         _dropList = new DropList();
         _dropList.x = _pos1.x;
         _dropList.y = _pos1.y;
         addChild(_dropList);
         _dropList.visible = true;
         _info = RoomManager.Instance.current;
         if(_info)
         {
            _info.addEventListener(RoomEvent.MAP_CHANGED,this.__onMapChanged);
            _info.addEventListener(RoomEvent.HARD_LEVEL_CHANGED,__updateHard);
            this.updateMap();
            updateDropList();
         }
         MainToolBar.Instance.backFunction = this.leaveAlert;
      }
      
      private function leaveAlert() : void
      {
         if((RoomManager.Instance.current.isOpenBoss || RoomManager.Instance.current.mapId == 12016) && !RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this.showAlert();
         }
         else
         {
            StateManager.setState(StateType.DUNGEON_LIST);
         }
      }
      
      private function showAlert() : void
      {
         var _loc1_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.missionsettle.dungeon.leaveConfirm.contents"),"",LanguageMgr.GetTranslation("cancel"),true,true,false,LayerManager.BLCAK_BLOCKGOUND);
         _loc1_.moveEnable = false;
         _loc1_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
         _loc2_ = null;
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            StateManager.setState(StateType.DUNGEON_LIST);
         }
      }
      
      private function __onGameStarted(param1:RoomEvent) : void
      {
         this._chooseBtn.enable = !_info.started;
      }
      
      override protected function __onMapChanged(param1:RoomEvent) : void
      {
         super.__onMapChanged(param1);
         if(_info.mapId == 12016)
         {
            this._chooseBtn.visible = false;
         }
         if(_info.mapId != 0 && _info.mapId != 10000)
         {
            this._chooseBtn.alpha = 0;
         }
         else
         {
            this._chooseBtn.alpha = 1;
         }
      }
      
      private function __playerStateChange(param1:RoomEvent) : void
      {
         if(RoomManager.Instance.current.isOpenBoss || RoomManager.Instance.current.mapId == 12016)
         {
            this._chooseBtn.visible = false;
         }
         else
         {
            this._chooseBtn.visible = _info.selfRoomPlayer.isHost;
         }
      }
      
      private function __openBossChange(param1:RoomEvent) : void
      {
         this.updateMap();
         updateDropList();
      }
      
      override protected function updateMap() : void
      {
         super.updateMap();
         if(_info.selfRoomPlayer && _info.mapId != 12016)
         {
            this._chooseBtn.visible = _info.selfRoomPlayer.isHost;
         }
      }
      
      override protected function solvePath() : String
      {
         var _loc1_:String = PathManager.SITE_MAIN + "image/map/";
         if(_info && _info.mapId > 0)
         {
            if(_info.isOpenBoss)
            {
               if(_info.pic && _info.pic.length > 0)
               {
                  _loc1_ += _info.mapId + "/" + _info.pic;
               }
            }
            else
            {
               _loc1_ += _info.mapId + "/show1.jpg";
            }
         }
         else
         {
            _loc1_ += "10000/show1.jpg";
         }
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._chooseBtn.dispose();
         this._chooseBtn = null;
         MainToolBar.Instance.backFunction = null;
      }
   }
}
