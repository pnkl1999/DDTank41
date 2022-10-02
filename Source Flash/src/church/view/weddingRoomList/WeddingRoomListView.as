package church.view.weddingRoomList
{
   import church.controller.ChurchRoomListController;
   import church.model.ChurchRoomListModel;
   import church.view.weddingRoomList.frame.WeddingRoomEnterConfirmView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ChurchRoomInfo;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryEvent;
   
   public class WeddingRoomListView extends Sprite implements Disposeable
   {
       
      
      private var _controller:ChurchRoomListController;
      
      private var _model:ChurchRoomListModel;
      
      private var _bgJoinListAsset:Bitmap;
      
      private var _btnPageFirstAsset:BaseButton;
      
      private var _btnPageBackAsset:BaseButton;
      
      private var _btnPageNextAsset:BaseButton;
      
      private var _btnPageLastAsset:BaseButton;
      
      private var _pageInfoText:FilterFrameText;
      
      private var _pageCount:int;
      
      private var _pageIndex:int = 1;
      
      private var _pageSize:int = 8;
      
      private var _weddingRoomListBox:VBox;
      
      private var _enterConfirmView:WeddingRoomEnterConfirmView;
      
      public function WeddingRoomListView(param1:ChurchRoomListController, param2:ChurchRoomListModel)
      {
         super();
         this._controller = param1;
         this._model = param2;
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
         this.updateList();
      }
      
      private function setView() : void
      {
         this._bgJoinListAsset = ComponentFactory.Instance.creatBitmap("asset.church.main.bgJoinListAsset");
         addChild(this._bgJoinListAsset);
         this._weddingRoomListBox = ComponentFactory.Instance.creat("asset.church.main.WeddingRoomListBoxAsset");
         addChild(this._weddingRoomListBox);
         this._btnPageFirstAsset = ComponentFactory.Instance.creat("church.main.btnPageFirstAsset");
         addChild(this._btnPageFirstAsset);
         this._btnPageBackAsset = ComponentFactory.Instance.creat("church.main.btnPageBackAsset");
         addChild(this._btnPageBackAsset);
         this._btnPageNextAsset = ComponentFactory.Instance.creat("church.main.btnPageNextAsset");
         addChild(this._btnPageNextAsset);
         this._btnPageLastAsset = ComponentFactory.Instance.creat("church.main.btnPageLastAsset");
         addChild(this._btnPageLastAsset);
         this._pageInfoText = ComponentFactory.Instance.creat("church.main.lblPageInfo");
         addChild(this._pageInfoText);
      }
      
      private function removeView() : void
      {
         if(this._bgJoinListAsset)
         {
            if(this._bgJoinListAsset.parent)
            {
               this._bgJoinListAsset.parent.removeChild(this._bgJoinListAsset);
            }
            this._bgJoinListAsset.bitmapData.dispose();
            this._bgJoinListAsset.bitmapData = null;
         }
         this._bgJoinListAsset = null;
         if(this._btnPageFirstAsset)
         {
            if(this._btnPageFirstAsset.parent)
            {
               this._btnPageFirstAsset.parent.removeChild(this._btnPageFirstAsset);
            }
            this._btnPageFirstAsset.dispose();
         }
         this._btnPageFirstAsset = null;
         if(this._btnPageBackAsset)
         {
            if(this._btnPageBackAsset.parent)
            {
               this._btnPageBackAsset.parent.removeChild(this._btnPageBackAsset);
            }
            this._btnPageBackAsset.dispose();
         }
         this._btnPageBackAsset = null;
         if(this._btnPageNextAsset)
         {
            if(this._btnPageNextAsset.parent)
            {
               this._btnPageNextAsset.parent.removeChild(this._btnPageNextAsset);
            }
            this._btnPageNextAsset.dispose();
         }
         this._btnPageNextAsset = null;
         if(this._btnPageLastAsset)
         {
            if(this._btnPageLastAsset.parent)
            {
               this._btnPageLastAsset.parent.removeChild(this._btnPageLastAsset);
            }
            this._btnPageLastAsset.dispose();
         }
         this._btnPageLastAsset = null;
         if(this._enterConfirmView)
         {
            if(this._enterConfirmView.parent)
            {
               this._enterConfirmView.parent.removeChild(this._enterConfirmView);
            }
            this._enterConfirmView.dispose();
         }
         this._enterConfirmView = null;
         if(this._pageInfoText)
         {
            ObjectUtils.disposeObject(this._pageInfoText);
         }
         this._pageInfoText = null;
         if(this._weddingRoomListBox)
         {
            ObjectUtils.disposeObject(this._weddingRoomListBox);
         }
         this._weddingRoomListBox = null;
      }
      
      private function setEvent() : void
      {
         this._model.roomList.addEventListener(DictionaryEvent.ADD,this.updateList);
         this._model.roomList.addEventListener(DictionaryEvent.REMOVE,this.updateList);
         this._model.roomList.addEventListener(DictionaryEvent.UPDATE,this.updateList);
         this._btnPageFirstAsset.addEventListener(MouseEvent.CLICK,this.getPageList);
         this._btnPageBackAsset.addEventListener(MouseEvent.CLICK,this.getPageList);
         this._btnPageNextAsset.addEventListener(MouseEvent.CLICK,this.getPageList);
         this._btnPageLastAsset.addEventListener(MouseEvent.CLICK,this.getPageList);
      }
      
      private function removeEvent() : void
      {
         this._btnPageFirstAsset.removeEventListener(MouseEvent.CLICK,this.getPageList);
         this._btnPageBackAsset.removeEventListener(MouseEvent.CLICK,this.getPageList);
         this._btnPageNextAsset.removeEventListener(MouseEvent.CLICK,this.getPageList);
         this._btnPageLastAsset.removeEventListener(MouseEvent.CLICK,this.getPageList);
      }
      
      private function getPageList(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.target)
         {
            case this._btnPageFirstAsset:
               this.pageIndex = 1;
               break;
            case this._btnPageBackAsset:
               this.pageIndex = this.pageIndex - 1 > 0 ? int(int(this.pageIndex - 1)) : int(int(1));
               break;
            case this._btnPageNextAsset:
               this.pageIndex = this.pageIndex + 1 <= this.pageCount ? int(int(this.pageIndex + 1)) : int(int(this.pageCount));
               break;
            case this._btnPageLastAsset:
               this.pageIndex = this.pageCount;
         }
      }
      
      public function updateList(param1:DictionaryEvent = null) : void
      {
         var _loc3_:ChurchRoomInfo = null;
         var _loc4_:WeddingRoomListItemView = null;
         this._weddingRoomListBox.disposeAllChildren();
         this._btnPageFirstAsset.enable = this._btnPageBackAsset.enable = this.pageCount > 0 && this.pageIndex > 1;
         this._btnPageNextAsset.enable = this._btnPageLastAsset.enable = this.pageCount > 0 && this.pageIndex < this.pageCount;
         this.updatePageText();
         if(!this.currentDataList || this.currentDataList.length <= 0)
         {
            return;
         }
         var _loc2_:Array = this.currentDataList.slice(this._pageIndex * this._pageSize - this._pageSize,this._pageIndex * this._pageSize <= this.currentDataList.length ? this._pageIndex * this._pageSize : this.currentDataList.length);
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = ComponentFactory.Instance.creatCustomObject("church.view.WeddingRoomListItemView");
            _loc4_.churchRoomInfo = _loc3_;
            this._weddingRoomListBox.addChild(_loc4_);
            _loc4_.addEventListener(MouseEvent.CLICK,this.__itemClick);
         }
      }
      
      private function updatePageText() : void
      {
         this._pageInfoText.text = this._pageIndex + "/" + this._pageCount;
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         var _loc2_:WeddingRoomListItemView = param1.currentTarget as WeddingRoomListItemView;
         this._enterConfirmView = ComponentFactory.Instance.creat("church.main.weddingRoomList.WeddingRoomEnterConfirmView");
         this._enterConfirmView.controller = this._controller;
         this._enterConfirmView.churchRoomInfo = _loc2_.churchRoomInfo;
         this._enterConfirmView.show();
      }
      
      public function get currentDataList() : Array
      {
         var _loc1_:Array = null;
         if(this._model && this._model.roomList)
         {
            _loc1_ = this._model.roomList.list;
            _loc1_.sortOn("id",Array.NUMERIC);
            return _loc1_;
         }
         return null;
      }
      
      public function get pageIndex() : int
      {
         return this._pageIndex;
      }
      
      public function set pageIndex(param1:int) : void
      {
         this._pageIndex = param1;
         this.updateList();
      }
      
      public function get pageCount() : int
      {
         this._pageCount = this.currentDataList.length / this._pageSize;
         if(this.currentDataList.length % this._pageSize > 0)
         {
            this._pageCount += 1;
         }
         this._pageCount = this._pageCount == 0 ? int(int(1)) : int(int(this._pageCount));
         return this._pageCount;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}
