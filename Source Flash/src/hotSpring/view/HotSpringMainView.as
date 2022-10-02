package hotSpring.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.HotSpringRoomInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.bossbox.SmallBoxButton;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import hotSpring.controller.HotSpringRoomListController;
   import hotSpring.event.HotSpringRoomListEvent;
   import hotSpring.model.HotSpringRoomListModel;
   import road7th.comm.PackageIn;
   
   public class HotSpringMainView extends Sprite implements Disposeable
   {
       
      
      private var _model:HotSpringRoomListModel;
      
      private var _controller:HotSpringRoomListController;
      
      private var _roomList:RoomListView;
      
      private var _boxButton:SmallBoxButton;
      
      private var _title:Bitmap;
      
      private var _bigBG:Bitmap;
      
      private var _freeBG:Bitmap;
      
      private var _roomListBG:Bitmap;
      
      private var _quickEnterBtn:SimpleBitmapButton;
      
      private var _creatRoomBtn:SimpleBitmapButton;
      
      private var _firstPageBtn:SimpleBitmapButton;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _lastPagBtn:SimpleBitmapButton;
      
      private var _roomCurCount:FilterFrameText;
      
      private var _roomCount:FilterFrameText;
      
      private var _chatFrame:Sprite;
      
      private var _roomVO:HotSpringRoomInfo;
      
      public function HotSpringMainView(param1:HotSpringRoomListController, param2:HotSpringRoomListModel)
      {
         super();
         this._controller = param1;
         this._model = param2;
         this.initialize();
      }
      
      protected function initialize() : void
      {
         SoundManager.instance.playMusic("062");
         this.initBackground();
         this.initButton();
         this._roomCurCount = ComponentFactory.Instance.creat("asset.HotSpringMainView.roomCurCount");
         addChild(this._roomCurCount);
         this._roomCount = ComponentFactory.Instance.creat("asset.HotSpringMainView.roomCount");
         addChild(this._roomCount);
         this._roomList = new RoomListView(this._controller,this._model);
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("asset.HotSpringMainView.roomListPos");
         this._roomList.x = _loc1_.x;
         this._roomList.y = _loc1_.y;
         addChild(this._roomList);
         if(BossBoxManager.instance.isShowBoxButton())
         {
            this._boxButton = new SmallBoxButton(SmallBoxButton.HOTSPRING_ROOM_POINT);
            addChild(this._boxButton);
         }
         this.roomListUpdateView();
         ChatManager.Instance.state = ChatManager.CHAT_HOTSPRING_VIEW;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
         this.setEvent();
      }
      
      private function initBackground() : void
      {
         this._title = ComponentFactory.Instance.creatBitmap("asset.HotSpringMainView.titleBGAsset");
         addChild(this._title);
         this._bigBG = ComponentFactory.Instance.creatBitmap("asset.HotSpringMainView.IMGBGAsset");
         addChild(this._bigBG);
         this._freeBG = ComponentFactory.Instance.creatBitmap("asset.HotSpringMainView.freeIMGAsset");
         addChild(this._freeBG);
         this._roomListBG = ComponentFactory.Instance.creatBitmap("asset.HotSpringMainView.roomListBGAsset");
         addChild(this._roomListBG);
      }
      
      private function initButton() : void
      {
         this._quickEnterBtn = ComponentFactory.Instance.creatComponentByStylename("asset.HotSpringMainView.quickEnterBtn");
         addChild(this._quickEnterBtn);
         this._creatRoomBtn = ComponentFactory.Instance.creatComponentByStylename("asset.HotSpringMainView.creatRoomBtn");
         addChild(this._creatRoomBtn);
         this._creatRoomBtn.enable = false;
         this._firstPageBtn = ComponentFactory.Instance.creatComponentByStylename("asset.HotSpringMainView.firstPageBtn");
         addChild(this._firstPageBtn);
         this._preBtn = ComponentFactory.Instance.creatComponentByStylename("asset.HotSpringMainView.preBtn");
         addChild(this._preBtn);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("asset.HotSpringMainView.nextBtn");
         addChild(this._nextBtn);
         this._lastPagBtn = ComponentFactory.Instance.creatComponentByStylename("asset.HotSpringMainView.lastPagBtn");
         addChild(this._lastPagBtn);
      }
      
      private function setEvent() : void
      {
         this._firstPageBtn.addEventListener(MouseEvent.CLICK,this.getPageList);
         this._preBtn.addEventListener(MouseEvent.CLICK,this.getPageList);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.getPageList);
         this._lastPagBtn.addEventListener(MouseEvent.CLICK,this.getPageList);
         this._creatRoomBtn.addEventListener(MouseEvent.CLICK,this.createRoom);
         this._quickEnterBtn.addEventListener(MouseEvent.CLICK,this.quickEnterRoom);
         this._roomList.addEventListener(HotSpringRoomListEvent.ROOM_LIST_UPDATE_VIEW,this.roomListUpdateView);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER_CONFIRM,this.roomEnterConfirmSucceed);
      }
      
      private function removeEvent() : void
      {
         this._firstPageBtn.removeEventListener(MouseEvent.CLICK,this.getPageList);
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.getPageList);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.getPageList);
         this._lastPagBtn.removeEventListener(MouseEvent.CLICK,this.getPageList);
         this._creatRoomBtn.removeEventListener(MouseEvent.CLICK,this.createRoom);
         this._quickEnterBtn.removeEventListener(MouseEvent.CLICK,this.quickEnterRoom);
         this._roomList.removeEventListener(HotSpringRoomListEvent.ROOM_LIST_UPDATE_VIEW,this.roomListUpdateView);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER_CONFIRM,this.roomEnterConfirmSucceed);
      }
      
      private function roomListUpdateView(param1:HotSpringRoomListEvent = null) : void
      {
         this._roomCurCount.text = this._roomList.pageCount > 0 ? this._roomList.pageIndex.toString() : "0";
         this._roomCount.text = "/" + this._roomList.pageCount.toString();
         this._firstPageBtn.enable = this._preBtn.enable = this._roomList.pageCount > 0 && this._roomList.pageIndex > 1;
         this._nextBtn.enable = this._lastPagBtn.enable = this._roomList.pageCount > 0 && this._roomList.pageIndex < this._roomList.pageCount;
      }
      
      private function getPageList(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._firstPageBtn:
               this._roomList.pageIndex = 1;
               break;
            case this._preBtn:
               this._roomList.pageIndex = this._roomList.pageIndex - 1 > 0 ? int(int(this._roomList.pageIndex - 1)) : int(int(1));
               break;
            case this._nextBtn:
               this._roomList.pageIndex = this._roomList.pageIndex + 1 <= this._roomList.pageCount ? int(int(this._roomList.pageIndex + 1)) : int(int(this._roomList.pageCount));
               break;
            case this._lastPagBtn:
               this._roomList.pageIndex = this._roomList.pageCount;
         }
      }
      
      private function createRoom(param1:MouseEvent) : void
      {
      }
      
      public function roomEnterConfirmSucceed(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:BaseAlerFrame = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         this._roomVO = this._model.roomList[_loc3_];
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._roomVO.roomType != 3)
         {
            if(this._roomVO.roomID <= 4)
            {
               _loc4_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.hotSpring.comfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               _loc4_.moveEnable = false;
               _loc4_.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            }
            else
            {
               _loc4_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.hotSpring.comfirm1"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               _loc4_.moveEnable = false;
               _loc4_.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            }
         }
      }
      
      private function __alertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         ObjectUtils.disposeObject(_loc2_);
         if(_loc2_.parent)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.confirmRoomEnter();
         }
      }
      
      private function confirmRoomEnter() : void
      {
         var _loc1_:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.Gold < 10000)
         {
            _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            _loc1_.moveEnable = false;
            _loc1_.addEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
            return;
         }
         if(this._controller)
         {
            this._controller.roomEnter(this._roomVO.roomID,"");
         }
      }
      
      private function __quickBuyResponse(param1:FrameEvent) : void
      {
         var _loc3_:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         _loc2_.dispose();
         if(_loc2_.parent)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         _loc2_ = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            _loc3_ = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
            _loc3_.itemID = EquipType.GOLD_BOX;
            _loc3_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function quickEnterRoom(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._controller.quickEnterRoom();
      }
      
      private function RoomEnterPassword(param1:String, param2:HotSpringRoomInfo) : void
      {
      }
      
      public function show() : void
      {
         this._controller.addChild(this);
         this._controller.hotSpringEnter();
      }
      
      public function hide() : void
      {
         this._controller.removeChild(this);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._quickEnterBtn)
         {
            ObjectUtils.disposeObject(this._quickEnterBtn);
         }
         this._quickEnterBtn = null;
         if(this._creatRoomBtn)
         {
            ObjectUtils.disposeObject(this._creatRoomBtn);
         }
         this._creatRoomBtn = null;
         if(this._firstPageBtn)
         {
            ObjectUtils.disposeObject(this._firstPageBtn);
         }
         this._firstPageBtn = null;
         if(this._preBtn)
         {
            ObjectUtils.disposeObject(this._preBtn);
         }
         this._preBtn = null;
         if(this._nextBtn)
         {
            ObjectUtils.disposeObject(this._nextBtn);
         }
         this._nextBtn = null;
         if(this._lastPagBtn)
         {
            ObjectUtils.disposeObject(this._lastPagBtn);
         }
         this._lastPagBtn = null;
         if(this._roomCurCount)
         {
            ObjectUtils.disposeObject(this._roomCurCount);
         }
         this._roomCurCount = null;
         if(this._roomCount)
         {
            ObjectUtils.disposeObject(this._roomCount);
         }
         this._roomCount = null;
         if(this._roomList)
         {
            ObjectUtils.disposeObject(this._roomList);
         }
         this._roomList = null;
         if(this._boxButton)
         {
            ObjectUtils.disposeObject(this._boxButton);
         }
         this._boxButton = null;
         this._model = null;
         this._controller = null;
         if(this._title)
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(this._bigBG)
         {
            ObjectUtils.disposeObject(this._bigBG);
         }
         this._bigBG = null;
         if(this._freeBG)
         {
            ObjectUtils.disposeObject(this._freeBG);
         }
         this._freeBG = null;
         if(this._roomListBG)
         {
            ObjectUtils.disposeObject(this._roomListBG);
         }
         this._roomListBG = null;
         if(this._chatFrame)
         {
            ObjectUtils.disposeObject(this._chatFrame);
         }
         this._chatFrame = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
