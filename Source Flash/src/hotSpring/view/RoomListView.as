package hotSpring.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.HotSpringRoomInfo;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import hotSpring.controller.HotSpringRoomListController;
   import hotSpring.event.HotSpringRoomListEvent;
   import hotSpring.model.HotSpringRoomListModel;
   
   public class RoomListView extends Sprite implements Disposeable
   {
       
      
      private var _controller:HotSpringRoomListController;
      
      private var _model:HotSpringRoomListModel;
      
      private var _roomListItem:RoomListItemView;
      
      private var _pageCount:int;
      
      private var _pageIndex:int = 1;
      
      private var _pageSize:int = 8;
      
      private var _list:VBox;
      
      public function RoomListView(param1:HotSpringRoomListController, param2:HotSpringRoomListModel, param3:int = 1, param4:int = 8)
      {
         super();
         this._controller = param1;
         this._model = param2;
         this._pageIndex = param3;
         this._pageSize = param4;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("asset.HotSpringMainView.roomListVBox");
         addChild(this._list);
         this.setRoomList();
         this.setEvent();
      }
      
      private function setEvent() : void
      {
         this._model.addEventListener(HotSpringRoomListEvent.ROOM_LIST_UPDATE,this.setRoomList);
      }
      
      public function setRoomList(param1:HotSpringRoomListEvent = null) : void
      {
         var _loc6_:BaseButton = null;
         var _loc4_:HotSpringRoomInfo = null;
         var _loc5_:RoomListItemView = null;
         _loc6_ = null;
         this.removeRoomList();
         if(!this._model.roomList || this._model.roomList.length <= 0)
         {
            return;
         }
         var _loc2_:Array = this._model.roomList.list.slice(this._pageIndex * this._pageSize - this._pageSize,this._pageIndex * this._pageSize <= this._model.roomList.length ? this._pageIndex * this._pageSize : this._model.roomList.length);
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = new RoomListItemView(this._model,_loc4_);
            _loc6_ = ComponentFactory.Instance.creatComponentByStylename("asset.HotSpringMainView.roomListItemBtn");
            _loc6_.backgound = _loc5_;
            _loc6_.mouseChildren = true;
            _loc5_.addEventListener(MouseEvent.CLICK,this.rootListItemClick);
            this._list.addChild(_loc6_);
         }
         this._list.refreshChildPos();
         dispatchEvent(new HotSpringRoomListEvent(HotSpringRoomListEvent.ROOM_LIST_UPDATE_VIEW));
      }
      
      private function rootListItemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         var _loc2_:HotSpringRoomInfo = param1.currentTarget.roomVO;
         if(_loc2_.roomType == 1 || _loc2_.roomType == 2)
         {
            this._controller.roomEnterConfirm(_loc2_.roomID);
         }
      }
      
      private function removeRoomList() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._list.numChildren)
         {
            (this._list.getChildAt(_loc1_) as BaseButton).backgound.removeEventListener(MouseEvent.CLICK,this.rootListItemClick);
            (this._list.getChildAt(_loc1_) as BaseButton).dispose();
            _loc1_++;
         }
         this._list.disposeAllChildren();
      }
      
      public function get pageIndex() : int
      {
         return this._pageIndex;
      }
      
      public function set pageIndex(param1:int) : void
      {
         this._pageIndex = param1;
         this.setRoomList();
      }
      
      public function get pageCount() : int
      {
         this._pageCount = this._model.roomList.length / this._pageSize;
         if(this._model.roomList.length % this._pageSize > 0)
         {
            this._pageCount += 1;
         }
         return this._pageCount;
      }
      
      public function dispose() : void
      {
         this._model.removeEventListener(HotSpringRoomListEvent.ROOM_LIST_UPDATE,this.setRoomList);
         this.removeRoomList();
         this._controller = null;
         this._model = null;
         if(this._list)
         {
            this._list.disposeAllChildren();
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
