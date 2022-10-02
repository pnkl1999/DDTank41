package church.view
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import church.controller.ChurchRoomListController;
   import church.model.ChurchRoomListModel;
   import church.view.weddingRoomList.WeddingRoomListNavView;
   import church.view.weddingRoomList.WeddingRoomListView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.ItemManager;
   import ddt.manager.SocketManager;
   import ddt.view.MainToolBar;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class ChurchMainView extends Sprite implements Disposeable
   {
      
      public static const NAV_PANEL:String = "btn panel";
      
      public static const ROOM_LIST:String = "room list";
       
      
      private var _controller:ChurchRoomListController;
      
      private var _model:ChurchRoomListModel;
      
      private var _titleMainAsset:Bitmap;
      
      private var _picPreviewAsset:Bitmap;
      
      private var _chatFrame:Sprite;
      
      private var _weddingRoomListView:WeddingRoomListView;
      
      private var _weddingRoomListNavView:WeddingRoomListNavView;
      
      private var _currentState:String = "btn panel";
      
      private var _cell:BagCell;
      
      public function ChurchMainView(param1:ChurchRoomListController, param2:ChurchRoomListModel)
      {
         super();
         this._controller = param1;
         this._model = param2;
         this.initialize();
      }
      
      protected function initialize() : void
      {
         var _loc1_:Point = null;
         _loc1_ = null;
         this._weddingRoomListNavView = new WeddingRoomListNavView(this._controller,this._model);
         this._weddingRoomListView = new WeddingRoomListView(this._controller,this._model);
         this._titleMainAsset = ComponentFactory.Instance.creatBitmap("asset.church.main.titleMainAsset");
         addChild(this._titleMainAsset);
         this._picPreviewAsset = ComponentFactory.Instance.creatBitmap("asset.church.main.picPreviewAsset");
         addChild(this._picPreviewAsset);
         this._cell = CellFactory.instance.createPersonalInfoCell(-1,ItemManager.Instance.getTemplateById(9022),true) as BagCell;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("church.view.WeddingRoomListItemView.cellPos");
         this._cell.x = _loc1_.x;
         this._cell.y = _loc1_.y;
         this._cell.setContentSize(60,60);
         addChild(this._cell);
         this.updateViewState();
         ChatManager.Instance.state = ChatManager.CHAT_WEDDINGLIST_STATE;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
         ChatManager.Instance.setFocus();
      }
      
      public function changeState(param1:String) : void
      {
         if(this._currentState == param1)
         {
            return;
         }
         this._currentState = param1;
         this.updateViewState();
      }
      
      private function updateViewState() : void
      {
         switch(this._currentState)
         {
            case NAV_PANEL:
               addChild(this._weddingRoomListNavView);
               MainToolBar.Instance.backFunction = null;
               if(this._weddingRoomListView.parent)
               {
                  removeChild(this._weddingRoomListView);
                  this._weddingRoomListView.updateList();
               }
               break;
            case ROOM_LIST:
               SocketManager.Instance.out.sendMarryRoomLogin();
               addChild(this._weddingRoomListView);
               this._weddingRoomListView.updateList();
               MainToolBar.Instance.backFunction = this.returnClick;
               if(this._weddingRoomListNavView.parent)
               {
                  removeChild(this._weddingRoomListNavView);
               }
         }
      }
      
      private function returnClick() : void
      {
         this.changeState(NAV_PANEL);
      }
      
      public function show() : void
      {
         this._controller.addChild(this);
      }
      
      public function dispose() : void
      {
         this._controller = null;
         this._model = null;
         if(this._titleMainAsset)
         {
            if(this._titleMainAsset.bitmapData)
            {
               this._titleMainAsset.bitmapData.dispose();
            }
            this._titleMainAsset.bitmapData = null;
         }
         this._titleMainAsset = null;
         if(this._picPreviewAsset)
         {
            if(this._picPreviewAsset.bitmapData)
            {
               this._picPreviewAsset.bitmapData.dispose();
            }
            this._picPreviewAsset.bitmapData = null;
         }
         this._picPreviewAsset = null;
         if(this._chatFrame)
         {
            ObjectUtils.disposeObject(this._chatFrame);
         }
         this._chatFrame = null;
         if(this._weddingRoomListView)
         {
            ObjectUtils.disposeObject(this._weddingRoomListView);
         }
         this._weddingRoomListView = null;
         if(this._weddingRoomListNavView)
         {
            ObjectUtils.disposeObject(this._weddingRoomListNavView);
         }
         this._weddingRoomListNavView = null;
         if(this._cell)
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
      }
   }
}
