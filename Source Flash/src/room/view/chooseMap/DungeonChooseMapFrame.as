package room.view.chooseMap
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.DungeonInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MapManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class DungeonChooseMapFrame extends Frame
   {
       
      
      private var _view:DungeonChooseMapView;
      
      private var _okBtn:TextButton;
      
      private var _alert:BaseAlerFrame;
      
      private var _voucherAlert:BaseAlerFrame;
      
      public function DungeonChooseMapFrame()
      {
         super();
         escEnable = true;
         this._view = ComponentFactory.Instance.creatCustomObject("room.dungeonChooseMapView");
         addToContent(this._view);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("asset.room.dungeonChooseMapButton");
         this._okBtn.text = LanguageMgr.GetTranslation("ok");
         addToContent(this._okBtn);
         PositionUtils.setPos(this._okBtn,"asset.DungeonRoom.OkbtnPos");
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__okClick);
         titleText = LanguageMgr.GetTranslation("tank.room.RoomIIMapSetPanel.room");
         addEventListener(FrameEvent.RESPONSE,this.__responeHandler);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __okClick(param1:MouseEvent) : void
      {
         var _loc2_:DungeonInfo = null;
         SoundManager.instance.play("008");
         if(this._view.checkState())
         {
            _loc2_ = MapManager.getDungeonInfo(this._view.selectedMapID);
            if(this._view.select)
            {
               this.showAlert();
            }
            else
            {
               if(_loc2_.Type == MapManager.PVE_ACADEMY_MAP)
               {
                  GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,RoomInfo.ACADEMY_DUNGEON_ROOM,false,this._view._roomPass,this._view._roomName,1,this._view.selectedLevel,0,false,0);
               }
               else if(_loc2_.Type == MapManager.PVE_ACTIVITY_MAP)
               {
                  GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,RoomInfo.ACTIVITY_DUNGEON_ROOM,false,this._view._roomPass,this._view._roomName,1,this._view.selectedLevel,0,false,0);
               }
               else
               {
                  GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,RoomInfo.DUNGEON_ROOM,false,this._view._roomPass,this._view._roomName,1,this._view.selectedLevel,0,false,0);
               }
               RoomManager.Instance.current.roomName = this._view._roomName;
               RoomManager.Instance.current.roomPass = this._view._roomPass;
               RoomManager.Instance.current.dungeonType = this._view.selectedDungeonType;
               this.dispose();
            }
         }
      }
      
      private function getPrice() : String
      {
         var _loc1_:Array = [];
         var _loc2_:String = "";
         var _loc3_:String = MapManager.getDungeonInfo(this._view.selectedMapID).BossFightNeedMoney;
         if(_loc3_)
         {
            _loc1_ = _loc3_.split("|");
         }
         if(_loc1_ && _loc1_.length > 0)
         {
            switch(this._view.selectedLevel)
            {
               case RoomInfo.EASY:
                  _loc2_ = _loc1_[0];
                  break;
               case RoomInfo.NORMAL:
                  _loc2_ = _loc1_[1];
                  break;
               case RoomInfo.HARD:
                  _loc2_ = _loc1_[2];
                  break;
               case RoomInfo.HERO:
                  _loc2_ = _loc1_[3];
            }
         }
         return _loc2_;
      }
      
      private function showAlert() : void
      {
         if(this._alert == null)
         {
            this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.room.openBossTip.text",this.getPrice()),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            this._alert.moveEnable = false;
            this._alert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         }
      }
      
      private function disposeAlert() : void
      {
         if(this._alert)
         {
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            ObjectUtils.disposeObject(this._alert);
            this._alert.dispose();
         }
         this._alert = null;
      }
      
      private function __alertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               if(PlayerManager.Instance.Self.Money < Number(this.getPrice()))
               {
                  this.showVoucherAlert();
               }
               else
               {
                  this.doOpenBossRoom();
               }
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.disposeAlert();
         }
      }
      
      private function showVoucherAlert() : void
      {
         if(this._voucherAlert == null)
         {
            this._voucherAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
            this._voucherAlert.addEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
         }
      }
      
      private function disposeVoucherAlert() : void
      {
         this.disposeAlert();
         if(this._voucherAlert)
         {
            this._voucherAlert.removeEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
            this._voucherAlert.disposeChildren = true;
            this._voucherAlert.dispose();
            this._voucherAlert = null;
         }
      }
      
      private function __onNoMoneyResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.disposeVoucherAlert();
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      private function __responeHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function doOpenBossRoom() : void
      {
         GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,RoomInfo.DUNGEON_ROOM,true,this._view._roomPass,this._view._roomName,1,this._view.selectedLevel,0,false,this._view.selectedMapID);
         RoomManager.Instance.current.roomName = this._view._roomName;
         RoomManager.Instance.current.roomPass = this._view._roomPass;
         RoomManager.Instance.current.dungeonType = this._view.selectedDungeonType;
         this.dispose();
      }
      
      override public function dispose() : void
      {
         this.disposeAlert();
         this.disposeVoucherAlert();
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__okClick);
         removeEventListener(FrameEvent.RESPONSE,this.__responeHandler);
         this._view.dispose();
         this._view = null;
         super.dispose();
      }
   }
}
