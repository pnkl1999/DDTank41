package church.view.weddingRoomList
{
   import baglocked.BaglockedManager;
   import church.controller.ChurchRoomListController;
   import church.model.ChurchRoomListModel;
   import church.view.ChurchMainView;
   import church.view.weddingRoomList.frame.WeddingRoomCreateView;
   import church.view.weddingRoomList.frame.WeddingUnmarryView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class WeddingRoomListNavView extends Sprite implements Disposeable
   {
      
      public static const DIVORCE_NUM:int = 5214;
       
      
      private var _controller:ChurchRoomListController;
      
      private var _model:ChurchRoomListModel;
      
      private var _bgNavAsset:Bitmap;
      
      private var _btnCreateAsset:BaseButton;
      
      private var _btnJoinAsset:BaseButton;
      
      private var _btnDivorceAsset:BaseButton;
      
      private var _createRoomFrame:WeddingRoomCreateView;
      
      private var _weddingUnmarryView:WeddingUnmarryView;
      
      public function WeddingRoomListNavView(param1:ChurchRoomListController, param2:ChurchRoomListModel)
      {
         super();
         this._controller = param1;
         this._model = param2;
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.addEvent();
      }
      
      private function setView() : void
      {
         this._bgNavAsset = ComponentFactory.Instance.creatBitmap("asset.church.main.bgNavAsset");
         addChild(this._bgNavAsset);
         this._btnCreateAsset = ComponentFactory.Instance.creat("church.main.btnCreateAsset");
         addChild(this._btnCreateAsset);
         this._btnJoinAsset = ComponentFactory.Instance.creat("church.main.btnJoinAsset");
         addChild(this._btnJoinAsset);
         this._btnDivorceAsset = ComponentFactory.Instance.creat("church.main.btnDivorceAsset");
         addChild(this._btnDivorceAsset);
         if(DivorcePromptFrame.Instance.isOpenDivorce == true)
         {
            this._openDivorce();
            DivorcePromptFrame.Instance.isOpenDivorce = false;
         }
      }
      
      private function removeView() : void
      {
         if(this._bgNavAsset)
         {
            if(this._bgNavAsset.parent)
            {
               this._bgNavAsset.parent.removeChild(this._bgNavAsset);
            }
            this._bgNavAsset.bitmapData.dispose();
            this._bgNavAsset.bitmapData = null;
         }
         this._bgNavAsset = null;
         if(this._btnCreateAsset)
         {
            if(this._btnCreateAsset.parent)
            {
               this._btnCreateAsset.parent.removeChild(this._btnCreateAsset);
            }
            this._btnCreateAsset.dispose();
         }
         this._btnCreateAsset = null;
         if(this._btnJoinAsset)
         {
            if(this._btnJoinAsset.parent)
            {
               this._btnJoinAsset.parent.removeChild(this._btnJoinAsset);
            }
            this._btnJoinAsset.dispose();
         }
         this._btnJoinAsset = null;
         if(this._btnDivorceAsset)
         {
            if(this._btnDivorceAsset.parent)
            {
               this._btnDivorceAsset.parent.removeChild(this._btnDivorceAsset);
            }
            this._btnDivorceAsset.dispose();
         }
         this._btnDivorceAsset = null;
         if(this._createRoomFrame)
         {
            if(this._createRoomFrame.parent)
            {
               this._createRoomFrame.parent.removeChild(this._createRoomFrame);
            }
            this._createRoomFrame.dispose();
         }
         this._createRoomFrame = null;
      }
      
      private function addEvent() : void
      {
         this._btnCreateAsset.addEventListener(MouseEvent.CLICK,this.onClickListener);
         this._btnJoinAsset.addEventListener(MouseEvent.CLICK,this.onClickListener);
         this._btnDivorceAsset.addEventListener(MouseEvent.CLICK,this.onClickListener);
      }
      
      private function removeEvent() : void
      {
         this._btnCreateAsset.removeEventListener(MouseEvent.CLICK,this.onClickListener);
         this._btnJoinAsset.removeEventListener(MouseEvent.CLICK,this.onClickListener);
         this._btnDivorceAsset.removeEventListener(MouseEvent.CLICK,this.onClickListener);
      }
      
      private function onClickListener(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._btnCreateAsset:
               this.showWeddingRoomCreateView();
               break;
            case this._btnJoinAsset:
               this._controller.changeViewState(ChurchMainView.ROOM_LIST);
               break;
            case this._btnDivorceAsset:
               if(!PlayerManager.Instance.Self.IsMarried)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.RoomListBtnPanel.clickListener"));
                  return;
               }
               this._openDivorce();
               break;
         }
      }
      
      private function _openDivorce() : void
      {
         SocketManager.Instance.out.sendMateTime(PlayerManager.Instance.Self.SpouseID);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MATE_ONLINE_TIME,this.__mateTime);
      }
      
      private function __mateTime(param1:CrazyTankSocketEvent) : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MATE_ONLINE_TIME,this.__mateTime);
         var _loc2_:Date = param1.pkg.readDate();
         var _loc3_:int = CalculateDate.needMoney(_loc2_);
         this.showUnmarryFrame(_loc2_,_loc3_);
      }
      
      public function showWeddingRoomCreateView() : void
      {
         if(!PlayerManager.Instance.Self.IsMarried)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.WeddingRoomControler.showCreateFrame"));
            return;
         }
         if(ChurchManager.instance.selfRoom)
         {
            SocketManager.Instance.out.sendEnterRoom(0,"");
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._createRoomFrame = ComponentFactory.Instance.creat("church.main.weddingRoomList.weddingRoomCreateView");
         this._createRoomFrame.setController(this._controller,this._model);
         this._createRoomFrame.show();
      }
      
      public function showUnmarryFrame(param1:Date, param2:int) : void
      {
         this._weddingUnmarryView = ComponentFactory.Instance.creat("church.weddingRoomList.frame.WeddingUnmarryView");
         this._weddingUnmarryView.controller = this._controller;
         var _loc3_:Array = CalculateDate.start(param1);
         this._weddingUnmarryView.setText(_loc3_[0],_loc3_[1]);
         this._weddingUnmarryView.show(param2);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}
