package roomList.pvpRoomList
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.CloneImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.bossbox.SmallBoxButton;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.data.DictionaryEvent;
   import room.model.RoomInfo;
   import roomList.LookupEnumerate;
   import roomList.RoomListTipPanel;
   
   public class RoomListBGView extends Sprite implements Disposeable
   {
       
      
      private var _roomListBG:Scale9CornerImage;
      
      private var _roomListBGII:Scale9CornerImage;
      
      private var _titleBg:Bitmap;
      
      private var _titleBgII:Bitmap;
      
      private var _commonBG:Bitmap;
      
      private var _commonBGII:Bitmap;
      
      private var _svrnameBG:Bitmap;
      
      private var _itemBg:CloneImage;
      
      private var _idBtn:SimpleBitmapButton;
      
      private var _roomNameBtn:SimpleBitmapButton;
      
      private var _roomModeBtn:SimpleBitmapButton;
      
      private var _hardLevelBtn:SimpleBitmapButton;
      
      private var _placeCountBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _iconBtn:SimpleBitmapButton;
      
      private var _iconBtnII:SimpleBitmapButton;
      
      private var _createBtn:SimpleBitmapButton;
      
      private var _rivalshipBtn:SimpleBitmapButton;
      
      private var _lookUpBtn:SimpleBitmapButton;
      
      private var _createRoomView:RoomListCreateRoomView;
      
      private var _itemList:VBox;
      
      private var _itemArray:Array;
      
      private var _svrnameText:FilterFrameText;
      
      private var _model:RoomListModel;
      
      private var _controller:RoomListController;
      
      private var _pvpModelRoomListTipPanel:RoomListTipPanel;
      
      private var _pvpHardLeveRoomListTipPanel:RoomListTipPanel;
      
      private var _boxButton:SmallBoxButton;
      
      private var _tempDataList:Array;
      
      private var _isPermissionEnter:Boolean;
      
      private var _selectItemPos:int;
      
      private var _selectItemID:int;
      
      public function RoomListBGView(param1:RoomListController, param2:RoomListModel)
      {
         this._model = param2;
         this._controller = param1;
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._roomListBG = ComponentFactory.Instance.creat("roomList.pvpRoomList.roomListBG");
         addChild(this._roomListBG);
         this._roomListBGII = ComponentFactory.Instance.creat("roomList.pvpRoomList.roomListBGII");
         addChild(this._roomListBGII);
         this._titleBg = ComponentFactory.Instance.creat("asset.roomList.titleBg_01");
         addChild(this._titleBg);
         this._titleBgII = ComponentFactory.Instance.creat("asset.roomList.titleBg_02");
         addChild(this._titleBgII);
         this._commonBG = ComponentFactory.Instance.creat("asset.roomList.commonBG_01");
         addChild(this._commonBG);
         this._svrnameBG = ComponentFactory.Instance.creat("asset.roomList.svrname");
         addChild(this._svrnameBG);
         this._itemBg = ComponentFactory.Instance.creat("roomList.pvpRoomList.roomListItemBG");
         addChild(this._itemBg);
         this.initButton();
         this._itemList = ComponentFactory.Instance.creat("roomList.pvpRoomList.ItemList");
         addChild(this._itemList);
         this.updateList();
         this._boxButton = new SmallBoxButton(SmallBoxButton.PVR_ROOMLIST_POINT);
         addChild(this._boxButton);
         this._isPermissionEnter = true;
      }
      
      private function initButton() : void
      {
         this._idBtn = ComponentFactory.Instance.creat("asset.roomList.IDBtn");
         addChild(this._idBtn);
         this._roomNameBtn = ComponentFactory.Instance.creat("asset.roomList.roomNameBtn");
         addChild(this._roomNameBtn);
         this._roomModeBtn = ComponentFactory.Instance.creat("asset.roomList.roomModeBtn");
         addChild(this._roomModeBtn);
         this._hardLevelBtn = ComponentFactory.Instance.creat("asset.roomList.hardLevelBtn");
         addChild(this._hardLevelBtn);
         this._placeCountBtn = ComponentFactory.Instance.creat("asset.roomList.placeCountBtn");
         addChild(this._placeCountBtn);
         this._nextBtn = ComponentFactory.Instance.creat("asset.roomList.nextBtn");
         addChild(this._nextBtn);
         this._preBtn = ComponentFactory.Instance.creat("asset.roomList.preBtn");
         addChild(this._preBtn);
         this._createBtn = ComponentFactory.Instance.creat("asset.roomList.createBtn");
         this._createBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.RoomListIIRoomBtnPanel.createRoom");
         addChild(this._createBtn);
         this._rivalshipBtn = ComponentFactory.Instance.creat("asset.roomList.rivalshipBtn");
         this._rivalshipBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.joinBattleQuickly");
         addChild(this._rivalshipBtn);
         this._lookUpBtn = ComponentFactory.Instance.creat("asset.roomList.lookupBtn");
         this._lookUpBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.RoomListIIRoomBtnPanel.findRoom");
         addChild(this._lookUpBtn);
         this._iconBtn = ComponentFactory.Instance.creat("asset.roomList.iconButton_01");
         addChild(this._iconBtn);
         this._iconBtnII = ComponentFactory.Instance.creat("asset.roomList.iconButton_02");
         addChild(this._iconBtnII);
         this._svrnameText = ComponentFactory.Instance.creat("roomList.pvpRoomList.svrnameText");
         addChild(this._svrnameText);
         this.addTipPanel();
         var _loc1_:String = String(ServerManager.Instance.current.Name);
         var _loc2_:int = _loc1_.indexOf("(");
         _loc2_ = _loc2_ == -1 ? int(int(_loc1_.length)) : int(int(_loc2_));
         this._svrnameText.text = _loc1_.substr(0,_loc2_);
         this._itemArray = [];
      }
      
      private function initEvent() : void
      {
         this._createBtn.addEventListener(MouseEvent.CLICK,this.__createBtnClick);
         this._rivalshipBtn.addEventListener(MouseEvent.CLICK,this._rivalshipClick);
         this._lookUpBtn.addEventListener(MouseEvent.CLICK,this.__lookupClick);
         this._idBtn.addEventListener(MouseEvent.CLICK,this.__idBtnClick);
         this._roomNameBtn.addEventListener(MouseEvent.CLICK,this.__roomNameClick);
         this._roomModeBtn.addEventListener(MouseEvent.CLICK,this.__roomModeClick);
         this._hardLevelBtn.addEventListener(MouseEvent.CLICK,this.__hardLevelClick);
         this._placeCountBtn.addEventListener(MouseEvent.CLICK,this.__placeCountClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
         this._iconBtn.addEventListener(MouseEvent.CLICK,this.__iconBtnClick);
         this._iconBtnII.addEventListener(MouseEvent.CLICK,this.__iconBtnIIClick);
         this._model.addEventListener(RoomListModel.ROOM_ITEM_UPDATE,this._updateItem);
         this._model.getRoomList().addEventListener(DictionaryEvent.CLEAR,this._clearRoom);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClick);
      }
      
      private function removeEvent() : void
      {
         this._createBtn.removeEventListener(MouseEvent.CLICK,this.__createBtnClick);
         this._rivalshipBtn.removeEventListener(MouseEvent.CLICK,this._rivalshipClick);
         this._lookUpBtn.removeEventListener(MouseEvent.CLICK,this.__lookupClick);
         this._idBtn.removeEventListener(MouseEvent.CLICK,this.__idBtnClick);
         this._roomNameBtn.removeEventListener(MouseEvent.CLICK,this.__roomNameClick);
         this._roomModeBtn.removeEventListener(MouseEvent.CLICK,this.__roomModeClick);
         this._hardLevelBtn.removeEventListener(MouseEvent.CLICK,this.__hardLevelClick);
         this._placeCountBtn.removeEventListener(MouseEvent.CLICK,this.__placeCountClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
         this._iconBtn.removeEventListener(MouseEvent.CLICK,this.__iconBtnClick);
         this._iconBtnII.removeEventListener(MouseEvent.CLICK,this.__iconBtnIIClick);
         this._model.removeEventListener(RoomListModel.ROOM_ITEM_UPDATE,this._updateItem);
         if(this._model.getRoomList())
         {
            this._model.getRoomList().removeEventListener(DictionaryEvent.CLEAR,this._clearRoom);
         }
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__stageClick);
      }
      
      private function _updateItem(param1:Event) : void
      {
         this.upadteItemPos();
         this._isPermissionEnter = true;
      }
      
      private function __stageClick(param1:MouseEvent) : void
      {
         if(!DisplayUtils.isTargetOrContain(param1.target as DisplayObject,this._iconBtn) && !DisplayUtils.isTargetOrContain(param1.target as DisplayObject,this._iconBtnII))
         {
            this._pvpHardLeveRoomListTipPanel.visible = false;
            this._pvpModelRoomListTipPanel.visible = false;
         }
      }
      
      private function addTipPanel() : void
      {
         var _loc4_:Point = null;
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.roomList.mode_0");
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.roomList.mode_01");
         var _loc3_:Point = ComponentFactory.Instance.creatCustomObject("roomList.pvpRoomList.roomListTipPanelSize");
         this._pvpModelRoomListTipPanel = new RoomListTipPanel(_loc3_.x,_loc3_.y);
         this._pvpModelRoomListTipPanel.addItem(_loc1_,1);
         this._pvpModelRoomListTipPanel.addItem(_loc2_,2);
         LayerManager.Instance.addToLayer(this._pvpModelRoomListTipPanel,LayerManager.GAME_DYNAMIC_LAYER);
         _loc4_ = ComponentFactory.Instance.creatCustomObject("roomList.RoomList.pvpModelRoomListTipPanelPos");
         this._pvpModelRoomListTipPanel.x = _loc4_.x;
         this._pvpModelRoomListTipPanel.y = _loc4_.y;
         this._pvpModelRoomListTipPanel.visible = false;
         var _loc5_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.roomList.NAN");
         var _loc6_:Point = ComponentFactory.Instance.creatCustomObject("roomList.pvpRoomList.roomListTipPanelSize");
         this._pvpHardLeveRoomListTipPanel = new RoomListTipPanel(_loc6_.x,_loc6_.y);
         this._pvpHardLeveRoomListTipPanel.addItem(_loc5_,1);
         LayerManager.Instance.addToLayer(this._pvpHardLeveRoomListTipPanel,LayerManager.GAME_DYNAMIC_LAYER);
         var _loc7_:Point = ComponentFactory.Instance.creatCustomObject("roomList.RoomList.pvphardLeveRoomListTipPanelPos");
         this._pvpHardLeveRoomListTipPanel.x = _loc7_.x;
         this._pvpHardLeveRoomListTipPanel.y = _loc7_.y;
         this._pvpHardLeveRoomListTipPanel.visible = false;
      }
      
      private function __iconBtnIIClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._pvpHardLeveRoomListTipPanel.visible = !this._pvpHardLeveRoomListTipPanel.visible;
         this._pvpModelRoomListTipPanel.visible = false;
      }
      
      private function __iconBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._pvpModelRoomListTipPanel.visible = !this._pvpModelRoomListTipPanel.visible;
         this._pvpHardLeveRoomListTipPanel.visible = false;
      }
      
      private function _clearRoom(param1:DictionaryEvent) : void
      {
         this.cleanItem();
         this._isPermissionEnter = true;
      }
      
      private function updateList() : void
      {
         var _loc2_:RoomInfo = null;
         var _loc3_:RoomListItemView = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._model.getRoomList().length)
         {
            _loc2_ = this._model.getRoomList().list[_loc1_];
            _loc3_ = new RoomListItemView(_loc2_);
            _loc3_.addEventListener(MouseEvent.CLICK,this.__itemClick);
            this._itemList.addChild(_loc3_);
            this._itemArray.push(_loc3_);
            _loc1_++;
         }
      }
      
      private function cleanItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._itemArray.length)
         {
            (this._itemArray[_loc1_] as RoomListItemView).removeEventListener(MouseEvent.CLICK,this.__itemClick);
            (this._itemArray[_loc1_] as RoomListItemView).dispose();
            _loc1_++;
         }
         this._itemList.disposeAllChildren();
         this._itemArray = [];
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         if(!this._isPermissionEnter)
         {
            return;
         }
         this.gotoIntoRoom((param1.currentTarget as RoomListItemView).info);
         this.getSelectItemPos((param1.currentTarget as RoomListItemView).id);
      }
      
      private function getSelectItemPos(param1:int) : int
      {
         if(!this._itemList)
         {
            return 0;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._itemArray.length)
         {
            if(!(this._itemArray[_loc2_] as RoomListItemView))
            {
               return 0;
            }
            if((this._itemArray[_loc2_] as RoomListItemView).id == param1)
            {
               this._selectItemPos = _loc2_;
               this._selectItemID = (this._itemArray[_loc2_] as RoomListItemView).id;
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function get currentDataList() : Array
      {
         if(this._model.roomShowMode == 1)
         {
            return this._model.getRoomList().filter("isPlaying",false).concat(this._model.getRoomList().filter("isPlaying",true));
         }
         return this._model.getRoomList().list;
      }
      
      private function getInfosPos(param1:int) : int
      {
         this._tempDataList = this.currentDataList;
         if(!this._tempDataList)
         {
            return 0;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._tempDataList.length)
         {
            if((this._tempDataList[_loc2_] as RoomInfo).ID == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      private function upadteItemPos() : void
      {
         var _loc1_:RoomInfo = null;
         var _loc2_:int = 0;
         var _loc3_:RoomInfo = null;
         var _loc4_:RoomListItemView = null;
         this._tempDataList = this.currentDataList;
         if(this._tempDataList)
         {
            _loc1_ = this._tempDataList[this._selectItemPos];
            _loc2_ = this.getInfosPos(this._selectItemID);
            this._tempDataList[this._selectItemPos] = this._tempDataList[_loc2_];
            this._tempDataList[_loc2_] = _loc1_;
            this.cleanItem();
            for each(_loc3_ in this._tempDataList)
            {
               if(!_loc3_)
               {
                  return;
               }
               _loc4_ = new RoomListItemView(_loc3_);
               _loc4_.addEventListener(MouseEvent.CLICK,this.__itemClick,false,0,true);
               this._itemList.addChild(_loc4_);
               this._itemArray.push(_loc4_);
            }
         }
      }
      
      public function gotoIntoRoom(param1:RoomInfo) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendGameLogin(1,-1,param1.ID,"");
         this._isPermissionEnter = false;
      }
      
      private function __lookupClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._controller.showFindRoom();
      }
      
      private function _rivalshipClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._isPermissionEnter)
         {
            return;
         }
         SocketManager.Instance.out.sendGameLogin(1,0);
         this._isPermissionEnter = false;
      }
      
      private function __updateClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_DEFAULT);
      }
      
      private function __placeCountClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_DEFAULT);
      }
      
      private function __hardLevelClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_DEFAULT);
      }
      
      private function __roomModeClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_DEFAULT);
      }
      
      private function __roomNameClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_DEFAULT);
      }
      
      private function __idBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_DEFAULT);
      }
      
      private function __createBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._controller.showCreateView();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.cleanItem();
         this._roomListBG.dispose();
         this._roomListBG = null;
         this._roomListBGII.dispose();
         this._roomListBGII = null;
         ObjectUtils.disposeObject(this._titleBg);
         this._titleBg = null;
         ObjectUtils.disposeObject(this._titleBgII);
         this._titleBgII = null;
         ObjectUtils.disposeObject(this._commonBG);
         this._commonBG = null;
         ObjectUtils.disposeObject(this._commonBGII);
         this._commonBGII = null;
         ObjectUtils.disposeObject(this._svrnameBG);
         this._svrnameBG = null;
         this._itemBg.dispose();
         this._itemBg = null;
         this._idBtn.dispose();
         this._idBtn = null;
         this._roomNameBtn.dispose();
         this._roomNameBtn = null;
         this._roomModeBtn.dispose();
         this._roomModeBtn = null;
         this._hardLevelBtn.dispose();
         this._hardLevelBtn = null;
         this._placeCountBtn.dispose();
         this._placeCountBtn = null;
         this._nextBtn.dispose();
         this._nextBtn = null;
         this._preBtn.dispose();
         this._preBtn = null;
         this._iconBtn.dispose();
         this._iconBtn = null;
         this._iconBtnII.dispose();
         this._iconBtnII = null;
         this._createBtn.dispose();
         this._createBtn = null;
         this._rivalshipBtn.dispose();
         this._rivalshipBtn = null;
         this._lookUpBtn.dispose();
         this._lookUpBtn = null;
         if(this._createRoomView && this._createRoomView.parent)
         {
            this._createRoomView.parent.removeChild(this._createRoomView);
            this._createRoomView.dispose();
            this._createRoomView = null;
         }
         if(this._itemList)
         {
            this._itemList.disposeAllChildren();
         }
         ObjectUtils.disposeObject(this._itemList);
         this._itemList = null;
         this._itemArray = null;
         if(this._boxButton && this._boxButton.parent)
         {
            this._boxButton.parent.removeChild(this._boxButton);
            this._boxButton.dispose();
            this._boxButton = null;
         }
         if(this._svrnameText && this._svrnameText.parent)
         {
            this._svrnameText.parent.removeChild(this._svrnameText);
            this._svrnameText.dispose();
            this._svrnameText = null;
         }
         this._pvpModelRoomListTipPanel.dispose();
         this._pvpModelRoomListTipPanel = null;
         this._pvpHardLeveRoomListTipPanel.dispose();
         this._pvpHardLeveRoomListTipPanel = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
