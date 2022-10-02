package roomLoading.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import game.GameManager;
   import room.model.RoomPlayer;
   import room.view.RoomViewerItem;
   
   public class RoomLoadingViewerItem extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _viewerItems:Vector.<RoomViewerItem>;
      
      public function RoomLoadingViewerItem()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         this._viewerItems = new Vector.<RoomViewerItem>();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.roomLoading.ViewerItemBg");
         var _loc1_:Vector.<RoomPlayer> = this.findViewers();
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            this._viewerItems.push(new RoomViewerItem(_loc1_[_loc2_].place));
            this._viewerItems[_loc2_].loadingMode = true;
            this._viewerItems[_loc2_].info = _loc1_[_loc2_];
            this._viewerItems[_loc2_].mouseChildren = false;
            this._viewerItems[_loc2_].mouseEnabled = false;
            PositionUtils.setPos(this._viewerItems[_loc2_],"asset.roomLoading.ViewerItemPos_" + String(_loc2_));
            addChild(this._viewerItems[_loc2_]);
            _loc2_++;
         }
         addChildAt(this._bg,0);
      }
      
      private function findViewers() : Vector.<RoomPlayer>
      {
         var _loc3_:RoomPlayer = null;
         var _loc1_:Array = GameManager.Instance.Current.roomPlayers;
         var _loc2_:Vector.<RoomPlayer> = new Vector.<RoomPlayer>();
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.isViewer)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function dispose() : void
      {
         var _loc1_:RoomViewerItem = null;
         if(this._bg)
         {
            this._bg.parent.removeChild(this._bg);
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         for each(_loc1_ in this._viewerItems)
         {
            _loc1_.dispose();
            _loc1_ = null;
         }
         this._viewerItems = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
