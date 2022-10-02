package roomList.pvpRoomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import room.model.RoomInfo;
   
   public class RoomListItemView extends Sprite implements Disposeable
   {
       
      
      private var _info:RoomInfo;
      
      private var _mode:ScaleFrameImage;
      
      private var _itemBg:ScaleFrameImage;
      
      private var _NAN:Bitmap;
      
      private var _lock:Bitmap;
      
      private var _idText:FilterFrameText;
      
      private var _nameText:FilterFrameText;
      
      private var _placeCountText:FilterFrameText;
      
      public function RoomListItemView(param1:RoomInfo)
      {
         this._info = param1;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.buttonMode = true;
         this._itemBg = ComponentFactory.Instance.creat("roomList.pvpRoomList.roomListItem");
         addChild(this._itemBg);
         this._mode = ComponentFactory.Instance.creat("roomList.pvpRoomList.mode");
         this._mode.setFrame(1);
         addChild(this._mode);
         this._NAN = ComponentFactory.Instance.creatBitmap("asset.roomList.NAN");
         addChild(this._NAN);
         this._idText = ComponentFactory.Instance.creat("roomList.pvpRoomList.IDText");
         addChild(this._idText);
         this._nameText = ComponentFactory.Instance.creat("roomList.pvpRoomList.nameText");
         addChild(this._nameText);
         this._placeCountText = ComponentFactory.Instance.creat("roomList.pvpRoomList.placeCountText");
         addChild(this._placeCountText);
         this._lock = ComponentFactory.Instance.creatBitmap("asset.roomList.lock");
         addChild(this._lock);
         this.upadte();
      }
      
      private function upadte() : void
      {
         if(this._info.isPlaying)
         {
            this._itemBg.setFrame(2);
         }
         else
         {
            this._itemBg.setFrame(1);
         }
         this._mode.setFrame(this._info.type + 1);
         this._nameText.text = this._info.Name;
         this._idText.text = String(this._info.ID);
         this._lock.visible = this._info.IsLocked;
         this._placeCountText.text = String(this._info.totalPlayer) + "/" + String(this._info.placeCount);
      }
      
      public function get info() : RoomInfo
      {
         return this._info;
      }
      
      public function get id() : int
      {
         return this._info.ID;
      }
      
      public function dispose() : void
      {
         this._itemBg.dispose();
         this._mode.dispose();
         this._idText.dispose();
         this._nameText.dispose();
         this._placeCountText.dispose();
         this._NAN = null;
         this._lock = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
