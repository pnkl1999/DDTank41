package roomList.pveRoomList
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
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
   import room.view.chooseMap.DungeonChooseMapView;
   import roomList.LookupEnumerate;
   import roomList.RoomListMapTipPanel;
   import roomList.RoomListTipPanel;
   
   public class DungeonListBGView extends Sprite implements Disposeable
   {
       
      
      private var _dungeonListBG:Bitmap;
      
      private var _svrnameBG:Bitmap;
      
      private var _model:DungeonListModel;
      
      private var _idBtn:SimpleBitmapButton;
      
      private var _roomNameBtn:SimpleBitmapButton;
      
      private var _roomModeBtn:SimpleBitmapButton;
      
      private var _hardLevelBtn:SimpleBitmapButton;
      
      private var _placeCountBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _iconBtn:SimpleBitmapButton;
      
      private var _iconBtnII:SimpleBitmapButton;
      
      private var _iconBtnIII:SimpleBitmapButton;
      
      private var _mapBtn:SimpleBitmapButton;
      
      private var _createBtn:SimpleBitmapButton;
      
      private var _rivalshipBtn:SimpleBitmapButton;
      
      private var _lookUpBtn:SimpleBitmapButton;
      
      private var _createRoomView:DungeonCreateRoomView;
      
      private var _itemList:VBox;
      
      private var _itemArray:Array;
      
      private var _pveModelRoomListTipPanel:RoomListTipPanel;
      
      private var _pveHardLeveRoomListTipPanel:RoomListTipPanel;
      
      private var _pveMapRoomListTipPanel:RoomListMapTipPanel;
      
      private var _svrnameText:FilterFrameText;
      
      private var _controlle:DungeonListController;
      
      private var _boxButton:SmallBoxButton;
      
      private var _tempDataList:Array;
      
      private var _isPermissionEnter:Boolean;
      
      private var _selectItemPos:int;
      
      private var _selectItemID:int;
      
      public function DungeonListBGView(param1:DungeonListController, param2:DungeonListModel)
      {
         this._controlle = param1;
         this._model = param2;
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._itemArray = [];
         this._dungeonListBG = ComponentFactory.Instance.creat("asset.DungeonList.DungeonListBG");
         addChild(this._dungeonListBG);
         this._svrnameBG = ComponentFactory.Instance.creat("asset.roomList.svrname");
         addChild(this._svrnameBG);
         this._idBtn = ComponentFactory.Instance.creat("asset.DungeonList.IDBtn");
         addChild(this._idBtn);
         this._roomNameBtn = ComponentFactory.Instance.creat("asset.DungeonList.roomNameBtn");
         addChild(this._roomNameBtn);
         this._roomModeBtn = ComponentFactory.Instance.creat("asset.DungeonList.roomModeBtn");
         addChild(this._roomModeBtn);
         this._hardLevelBtn = ComponentFactory.Instance.creat("asset.DungeonList.hardLevelBtn");
         addChild(this._hardLevelBtn);
         this._mapBtn = ComponentFactory.Instance.creat("asset.DungeonList.mapBtn");
         addChild(this._mapBtn);
         this._placeCountBtn = ComponentFactory.Instance.creat("asset.DungeonList.placeCountBtn");
         addChild(this._placeCountBtn);
         this._nextBtn = ComponentFactory.Instance.creat("asset.DungeonList.nextBtn");
         addChild(this._nextBtn);
         this._preBtn = ComponentFactory.Instance.creat("asset.DungeonList.preBtn");
         addChild(this._preBtn);
         this._createBtn = ComponentFactory.Instance.creat("asset.DungeonList.createBtn");
         this._createBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.RoomListIIRoomBtnPanel.createRoom");
         addChild(this._createBtn);
         this._rivalshipBtn = ComponentFactory.Instance.creat("asset.DungeonList.rivalshipBtn");
         this._rivalshipBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.joinDuplicateQuickly");
         addChild(this._rivalshipBtn);
         this._lookUpBtn = ComponentFactory.Instance.creat("asset.DungeonList.lookupBtn");
         this._lookUpBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.RoomListIIRoomBtnPanel.findRoom");
         addChild(this._lookUpBtn);
         this._iconBtn = ComponentFactory.Instance.creat("asset.DungeonList.iconButton_01");
         addChild(this._iconBtn);
         this._iconBtnII = ComponentFactory.Instance.creat("asset.DungeonList.iconButton_02");
         addChild(this._iconBtnII);
         this._iconBtnIII = ComponentFactory.Instance.creat("asset.DungeonList.iconButton_03");
         addChild(this._iconBtnIII);
         this._svrnameText = ComponentFactory.Instance.creat("roomList.pvpRoomList.svrnameText");
         addChild(this._svrnameText);
         var _loc1_:String = String(ServerManager.Instance.current.Name);
         var _loc2_:int = _loc1_.indexOf("(");
         _loc2_ = _loc2_ == -1 ? int(int(_loc1_.length)) : int(int(_loc2_));
         this._svrnameText.text = _loc1_.substr(0,_loc2_);
         this._itemList = ComponentFactory.Instance.creat("roomList.DungeonList.ItemList");
         addChild(this._itemList);
         this.addTipPanel();
         this._boxButton = new SmallBoxButton(SmallBoxButton.PVE_ROOMLIST_POINT);
         addChild(this._boxButton);
         this._isPermissionEnter = true;
      }
      
      private function initEvent() : void
      {
         this._createBtn.addEventListener(MouseEvent.CLICK,this.__createClick);
         this._rivalshipBtn.addEventListener(MouseEvent.CLICK,this.__rivalshipBtnClick);
         this._iconBtn.addEventListener(MouseEvent.CLICK,this.__iconBtnClick);
         this._iconBtnII.addEventListener(MouseEvent.CLICK,this.__iconBtnIIClick);
         this._iconBtnIII.addEventListener(MouseEvent.CLICK,this.__iconBtnIIIClick);
         this._idBtn.addEventListener(MouseEvent.CLICK,this.__idBtnClick);
         this._roomNameBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
         this._roomModeBtn.addEventListener(MouseEvent.CLICK,this.__roomModeClick);
         this._hardLevelBtn.addEventListener(MouseEvent.CLICK,this.__hardLevelClick);
         this._placeCountBtn.addEventListener(MouseEvent.CLICK,this.__iconBtnIIIClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
         this._mapBtn.addEventListener(MouseEvent.CLICK,this.__mapClick);
         this._lookUpBtn.addEventListener(MouseEvent.CLICK,this.__lookupClick);
         this._model.addEventListener(DungeonListModel.DUNGEON_LIST_UPDATE,this.__addRoom);
         this._model.getRoomList().addEventListener(DictionaryEvent.CLEAR,this.__clearRoom);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClick);
      }
      
      private function removeEvent() : void
      {
         this._createBtn.removeEventListener(MouseEvent.CLICK,this.__createClick);
         this._rivalshipBtn.removeEventListener(MouseEvent.CLICK,this.__rivalshipBtnClick);
         this._iconBtn.removeEventListener(MouseEvent.CLICK,this.__iconBtnClick);
         this._iconBtnII.removeEventListener(MouseEvent.CLICK,this.__iconBtnIIClick);
         this._iconBtnIII.removeEventListener(MouseEvent.CLICK,this.__iconBtnIIIClick);
         this._idBtn.removeEventListener(MouseEvent.CLICK,this.__idBtnClick);
         this._roomNameBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
         this._roomModeBtn.removeEventListener(MouseEvent.CLICK,this.__roomModeClick);
         this._hardLevelBtn.removeEventListener(MouseEvent.CLICK,this.__hardLevelClick);
         this._placeCountBtn.removeEventListener(MouseEvent.CLICK,this.__iconBtnIIIClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
         this._mapBtn.removeEventListener(MouseEvent.CLICK,this.__mapClick);
         this._lookUpBtn.removeEventListener(MouseEvent.CLICK,this.__lookupClick);
         this._model.removeEventListener(DungeonListModel.DUNGEON_LIST_UPDATE,this.__addRoom);
         this._model.getRoomList().removeEventListener(DictionaryEvent.CLEAR,this.__clearRoom);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__stageClick);
      }
      
      private function __mapClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendUpdate();
      }
      
      private function __rivalshipBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._isPermissionEnter)
         {
            return;
         }
         SocketManager.Instance.out.sendGameLogin(LookupEnumerate.DUNGEON_LIST,4);
         this._isPermissionEnter = false;
      }
      
      private function __stageClick(param1:MouseEvent) : void
      {
         if(!DisplayUtils.isTargetOrContain(param1.target as DisplayObject,this._iconBtn) && !DisplayUtils.isTargetOrContain(param1.target as DisplayObject,this._iconBtnII) && !DisplayUtils.isTargetOrContain(param1.target as DisplayObject,this._iconBtnIII))
         {
            this._pveModelRoomListTipPanel.visible = false;
            this._pveMapRoomListTipPanel.visible = false;
            this._pveHardLeveRoomListTipPanel.visible = false;
         }
      }
      
      private function __lookupClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._controlle.showFindRoom();
      }
      
      private function __hardLevelClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendUpdate();
      }
      
      private function __roomModeClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendUpdate();
      }
      
      private function __idBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendUpdate();
      }
      
      private function sendUpdate() : void
      {
         SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.DUNGEON_LIST,LookupEnumerate.DUNGEON_LIST_DEFAULT);
      }
      
      private function addTipPanel() : void
      {
         var _loc4_:Point = null;
         var _loc10_:Point = null;
         var _loc11_:Point = null;
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.roomList.mode_03");
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.roomList.mode_04");
         var _loc3_:Point = ComponentFactory.Instance.creatCustomObject("roomList.DungeonList.DungeonListTipPanelSize");
         this._pveModelRoomListTipPanel = new RoomListTipPanel(_loc3_.x,_loc3_.y);
         this._pveModelRoomListTipPanel.addItem(_loc1_,LookupEnumerate.DUNGEON_LIST_DUNGEON);
         this._pveModelRoomListTipPanel.addItem(_loc2_,LookupEnumerate.DUNGEON_LIST_BOOS);
         _loc4_ = ComponentFactory.Instance.creatCustomObject("roomList.DungeonList.pveModelRoomListTipPanelPos");
         this._pveModelRoomListTipPanel.x = _loc4_.x;
         this._pveModelRoomListTipPanel.y = _loc4_.y;
         this._pveModelRoomListTipPanel.visible = false;
         LayerManager.Instance.addToLayer(this._pveModelRoomListTipPanel,LayerManager.GAME_DYNAMIC_LAYER);
         var _loc5_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.roomList.hardLevel_01");
         var _loc6_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.roomList.hardLevel_02");
         var _loc7_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.roomList.hardLevel_03");
         var _loc8_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.roomList.hardLevel_04");
         var _loc9_:Point = ComponentFactory.Instance.creatCustomObject("roomList.DungeonList.DungeonListTipPanelSizeII");
         this._pveHardLeveRoomListTipPanel = new RoomListTipPanel(_loc9_.x,_loc9_.y);
         this._pveHardLeveRoomListTipPanel.addItem(_loc5_,LookupEnumerate.DUNGEON_LIST_SIMPLE);
         this._pveHardLeveRoomListTipPanel.addItem(_loc6_,LookupEnumerate.DUNGEON_LIST_COMMON);
         this._pveHardLeveRoomListTipPanel.addItem(_loc7_,LookupEnumerate.DUNGEON_LIST_STRAIT);
         this._pveHardLeveRoomListTipPanel.addItem(_loc8_,LookupEnumerate.DUNGEON_LIST_HERO);
         _loc10_ = ComponentFactory.Instance.creatCustomObject("roomList.DungeonList.pveHardLeveRoomListTipPanelPos");
         this._pveHardLeveRoomListTipPanel.x = _loc10_.x;
         this._pveHardLeveRoomListTipPanel.y = _loc10_.y;
         this._pveHardLeveRoomListTipPanel.visible = false;
         LayerManager.Instance.addToLayer(this._pveHardLeveRoomListTipPanel,LayerManager.GAME_DYNAMIC_LAYER);
         _loc11_ = ComponentFactory.Instance.creatCustomObject("roomList.DungeonList.pveMapPanelPos");
         var _loc12_:Point = ComponentFactory.Instance.creatCustomObject("roomList.DungeonList.DungeonListTipPanelSizeIII");
         this._pveMapRoomListTipPanel = new RoomListMapTipPanel(_loc12_.x,_loc12_.y);
         this._pveMapRoomListTipPanel.x = _loc11_.x;
         this._pveMapRoomListTipPanel.y = _loc11_.y;
         this._pveMapRoomListTipPanel.addItem(10000);
         var _loc13_:int = 1;
         while(_loc13_ < DungeonChooseMapView.DUNGEON_NO)
         {
            if(MapManager.getByOrderingDungeonInfo(_loc13_))
            {
               this._pveMapRoomListTipPanel.addItem(MapManager.getByOrderingDungeonInfo(_loc13_).ID);
            }
            _loc13_++;
         }
         var _loc14_:int = 1;
         while(_loc14_ < DungeonChooseMapView.DUNGEON_NO)
         {
            if(MapManager.getByOrderingSpecialDungeonInfo(_loc14_))
            {
               this._pveMapRoomListTipPanel.addItem(MapManager.getByOrderingSpecialDungeonInfo(_loc14_).ID);
            }
            _loc14_++;
         }
         this._pveMapRoomListTipPanel.visible = false;
         addChild(this._pveMapRoomListTipPanel);
      }
      
      private function __clearRoom(param1:DictionaryEvent) : void
      {
         this.cleanItem();
         this._isPermissionEnter = true;
      }
      
      private function __addRoom(param1:Event) : void
      {
         this.upadteItemPos();
         this._isPermissionEnter = true;
      }
      
      private function upadteItemPos() : void
      {
         var _loc1_:RoomInfo = null;
         var _loc2_:int = 0;
         var _loc3_:RoomInfo = null;
         var _loc4_:DungeonListItemView = null;
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
               _loc4_ = new DungeonListItemView(_loc3_);
               _loc4_.addEventListener(MouseEvent.CLICK,this.__itemClick,false,0,true);
               this._itemList.addChild(_loc4_);
               this._itemArray.push(_loc4_);
            }
         }
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
            if(!(this._itemArray[_loc2_] as DungeonListItemView))
            {
               return 0;
            }
            if((this._itemArray[_loc2_] as DungeonListItemView).id == param1)
            {
               this._selectItemPos = _loc2_;
               this._selectItemID = (this._itemArray[_loc2_] as DungeonListItemView).id;
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
      
      private function __iconBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._pveModelRoomListTipPanel.visible = !this._pveModelRoomListTipPanel.visible;
         this._pveMapRoomListTipPanel.visible = false;
         this._pveHardLeveRoomListTipPanel.visible = false;
      }
      
      private function __iconBtnIIClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._pveMapRoomListTipPanel.visible = !this._pveMapRoomListTipPanel.visible;
         this._pveModelRoomListTipPanel.visible = false;
         this._pveHardLeveRoomListTipPanel.visible = false;
      }
      
      private function __iconBtnIIIClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._pveHardLeveRoomListTipPanel.visible = !this._pveHardLeveRoomListTipPanel.visible;
         this._pveMapRoomListTipPanel.visible = false;
         this._pveModelRoomListTipPanel.visible = false;
         this.sendUpdate();
      }
      
      private function __updateClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.DUNGEON_LIST,LookupEnumerate.DUNGEON_LIST_DEFAULT);
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         if(!this._isPermissionEnter)
         {
            return;
         }
         this.gotoIntoRoom((param1.currentTarget as DungeonListItemView).info);
         this.getSelectItemPos((param1.currentTarget as DungeonListItemView).id);
      }
      
      public function gotoIntoRoom(param1:RoomInfo) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendGameLogin(2,-1,param1.ID,"");
         this._isPermissionEnter = false;
      }
      
      private function __createClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._controlle.showCreateView();
      }
      
      private function cleanItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._itemArray.length)
         {
            (this._itemArray[_loc1_] as DungeonListItemView).removeEventListener(MouseEvent.CLICK,this.__itemClick);
            (this._itemArray[_loc1_] as DungeonListItemView).dispose();
            _loc1_++;
         }
         this._itemList.disposeAllChildren();
         this._itemArray = [];
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.cleanItem();
         ObjectUtils.disposeObject(this._dungeonListBG);
         this._dungeonListBG = null;
         ObjectUtils.disposeObject(this._svrnameBG);
         this._svrnameBG = null;
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
         this._iconBtnIII.dispose();
         this._iconBtnIII = null;
         this._mapBtn.dispose();
         this._mapBtn = null;
         this._createBtn.dispose();
         this._createBtn = null;
         this._rivalshipBtn.dispose();
         this._rivalshipBtn = null;
         this._lookUpBtn.dispose();
         this._lookUpBtn = null;
         this._svrnameText.dispose();
         this._svrnameText = null;
         if(this._pveModelRoomListTipPanel && this._pveModelRoomListTipPanel.parent)
         {
            this._pveModelRoomListTipPanel.parent.removeChild(this._pveModelRoomListTipPanel);
         }
         this._pveModelRoomListTipPanel.dispose();
         this._pveModelRoomListTipPanel = null;
         if(this._pveHardLeveRoomListTipPanel && this._pveHardLeveRoomListTipPanel.parent)
         {
            this._pveHardLeveRoomListTipPanel.parent.removeChild(this._pveHardLeveRoomListTipPanel);
         }
         this._pveHardLeveRoomListTipPanel.dispose();
         this._pveHardLeveRoomListTipPanel = null;
         if(this._pveMapRoomListTipPanel && this._pveMapRoomListTipPanel.parent)
         {
            this._pveMapRoomListTipPanel.parent.removeChild(this._pveMapRoomListTipPanel);
         }
         this._pveMapRoomListTipPanel.dispose();
         this._pveMapRoomListTipPanel = null;
         if(this._boxButton && this._boxButton.parent)
         {
            this._boxButton.parent.removeChild(this._boxButton);
            this._boxButton.dispose();
            this._boxButton = null;
         }
         this._itemList.dispose();
         this._itemList = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
