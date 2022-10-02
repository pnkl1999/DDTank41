package church.view.weddingRoom.frame
{
   import church.controller.ChurchRoomController;
   import church.model.ChurchRoomModel;
   import church.vo.PlayerVO;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class WeddingRoomGuestListView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _controller:ChurchRoomController;
      
      private var _model:ChurchRoomModel;
      
      private var _btnGuestListClose:BaseButton;
      
      private var _guestListBox:Bitmap;
      
      private var _listPanel:ListPanel;
      
      private var _data:DictionaryData;
      
      private var _currentItem:WeddingRoomGuestListItemView;
      
      public function WeddingRoomGuestListView(param1:ChurchRoomController, param2:ChurchRoomModel)
      {
         super();
         this._controller = param1;
         this._model = param2;
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this._data = this._model.getPlayers();
         this.setView();
         this.setEvent();
         this.getGuestList();
         this.addSelfItem();
      }
      
      private function setView() : void
      {
         this._bg = ComponentFactory.Instance.creat("church.weddingRoom.guestListBg");
         addChild(this._bg);
         this._guestListBox = ComponentFactory.Instance.creat("asset.church.room.guestListBoxAsset");
         addChild(this._guestListBox);
         this._btnGuestListClose = ComponentFactory.Instance.creat("church.room.guestListCloseAsset");
         addChild(this._btnGuestListClose);
         this._listPanel = ComponentFactory.Instance.creatComponentByStylename("church.room.listGuestListAsset");
         addChild(this._listPanel);
         this._listPanel.list.updateListView();
         this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.itemClick);
      }
      
      private function getGuestList() : void
      {
         var _loc2_:PlayerInfo = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._data.length)
         {
            _loc2_ = (this._data.list[_loc1_] as PlayerVO).playerInfo;
            this._listPanel.vectorListModel.insertElementAt(_loc2_,this.getInsertIndex(_loc2_));
            this.upSelfItem();
            _loc1_++;
         }
      }
      
      private function itemClick(param1:ListItemEvent) : void
      {
         if(!this._currentItem)
         {
            this._currentItem = param1.cell as WeddingRoomGuestListItemView;
            this._currentItem.setListCellStatus(this._listPanel.list,true,param1.index);
         }
         if(this._currentItem != param1.cell as WeddingRoomGuestListItemView)
         {
            this._currentItem.setListCellStatus(this._listPanel.list,false,param1.index);
            this._currentItem = param1.cell as WeddingRoomGuestListItemView;
            this._currentItem.setListCellStatus(this._listPanel.list,true,param1.index);
         }
      }
      
      private function setEvent() : void
      {
         this._btnGuestListClose.addEventListener(MouseEvent.CLICK,this.closeView);
         this._data.addEventListener(DictionaryEvent.ADD,this.addGuest);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.removeGuest);
      }
      
      private function addGuest(param1:DictionaryEvent) : void
      {
         var _loc2_:PlayerInfo = (param1.data as PlayerVO).playerInfo;
         this._listPanel.vectorListModel.insertElementAt(_loc2_,this.getInsertIndex(_loc2_));
         this._listPanel.list.updateListView();
         this.upSelfItem();
      }
      
      private function getInsertIndex(param1:PlayerInfo) : int
      {
         var _loc2_:int = 0;
         var _loc3_:Array = this._listPanel.vectorListModel.elements;
         if(_loc3_.length == 0)
         {
            return 0;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(param1.Grade > (_loc3_[_loc4_] as PlayerInfo).Grade)
            {
               return _loc2_;
            }
            if(param1.Grade <= (_loc3_[_loc4_] as PlayerInfo).Grade)
            {
               _loc2_ = _loc4_ + 1;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function removeGuest(param1:DictionaryEvent) : void
      {
         var _loc2_:PlayerInfo = (param1.data as PlayerVO).playerInfo;
         if(_loc2_)
         {
            this._listPanel.vectorListModel.remove(_loc2_);
         }
         this._listPanel.list.updateListView();
      }
      
      private function addSelfItem() : void
      {
         this._listPanel.vectorListModel.insertElementAt(PlayerManager.Instance.Self,0);
      }
      
      private function upSelfItem() : void
      {
         var _loc1_:PlayerInfo = this._data[PlayerManager.Instance.Self.ID];
         var _loc2_:int = this._listPanel.vectorListModel.indexOf(_loc1_);
         if(_loc2_ == -1 || _loc2_ == 0)
         {
            return;
         }
         this._listPanel.vectorListModel.removeAt(_loc2_);
         this._listPanel.vectorListModel.insertElementAt(_loc1_,0);
      }
      
      private function closeView(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER);
      }
      
      private function removeView() : void
      {
         if(this._bg)
         {
            if(this._bg.parent)
            {
               this._bg.parent.removeChild(this._bg);
            }
            this._bg.dispose();
         }
         this._bg = null;
         if(this._btnGuestListClose)
         {
            if(this._btnGuestListClose.parent)
            {
               this._btnGuestListClose.parent.removeChild(this._btnGuestListClose);
            }
            this._btnGuestListClose.dispose();
         }
         this._btnGuestListClose = null;
         if(this._guestListBox)
         {
            if(this._guestListBox.parent)
            {
               this._guestListBox.parent.removeChild(this._guestListBox);
            }
            this._guestListBox.bitmapData.dispose();
            this._guestListBox.bitmapData = null;
         }
         this._guestListBox = null;
         if(this._listPanel)
         {
            if(this._listPanel.parent)
            {
               this._listPanel.parent.removeChild(this._listPanel);
            }
            this._listPanel.dispose();
         }
         this._listPanel = null;
         if(this._currentItem)
         {
            if(this._currentItem.parent)
            {
               this._currentItem.parent.removeChild(this._currentItem);
            }
            this._currentItem.dispose();
         }
         this._currentItem = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function removeEvent() : void
      {
         if(this._btnGuestListClose)
         {
            this._btnGuestListClose.removeEventListener(MouseEvent.CLICK,this.closeView);
         }
         this._data.removeEventListener(DictionaryEvent.ADD,this.addGuest);
         this._data.removeEventListener(DictionaryEvent.REMOVE,this.removeGuest);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}
