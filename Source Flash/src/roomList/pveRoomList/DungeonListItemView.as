package roomList.pveRoomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.loader.MapSmallIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import room.model.RoomInfo;
   
   public class DungeonListItemView extends Sprite implements Disposeable
   {
      
      public static const NAN_MAP:int = 10000;
       
      
      private var _info:RoomInfo;
      
      private var _mode:ScaleFrameImage;
      
      private var _hardLevel:ScaleFrameImage;
      
      private var _itemBg:ScaleFrameImage;
      
      private var _lock:Bitmap;
      
      private var _idText:FilterFrameText;
      
      private var _nameText:FilterFrameText;
      
      private var _placeCountText:FilterFrameText;
      
      private var _mapIcon:MapSmallIcon;
      
      public function DungeonListItemView(param1:RoomInfo = null)
      {
         this._info = param1;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.buttonMode = true;
         this._itemBg = ComponentFactory.Instance.creat("roomList.DungeonList.DungeonListItem");
         addChild(this._itemBg);
         this._mode = ComponentFactory.Instance.creat("roomList.DungeonList.mode");
         this._mode.setFrame(1);
         addChild(this._mode);
         this._hardLevel = ComponentFactory.Instance.creat("roomList.DungeonList.DungeonListHardLevel");
         addChild(this._hardLevel);
         this._idText = ComponentFactory.Instance.creat("roomList.DungeonList.IDText");
         addChild(this._idText);
         this._nameText = ComponentFactory.Instance.creat("roomList.DungeonList.nameText");
         addChild(this._nameText);
         this._placeCountText = ComponentFactory.Instance.creat("roomList.DungeonList.placeCountText");
         addChild(this._placeCountText);
         this._lock = ComponentFactory.Instance.creatBitmap("asset.roomList.lock");
         this._lock.visible = false;
         addChild(this._lock);
         this._mapIcon = new MapSmallIcon(this._info.mapId == 0 ? int(int(NAN_MAP)) : int(int(this._info.mapId)));
         this._mapIcon.addEventListener(Event.COMPLETE,this.__loadComlete);
         this._mapIcon.startLoad();
         this.update();
      }
      
      private function __loadComlete(param1:Event) : void
      {
         var _loc2_:Point = null;
         this._mapIcon.removeEventListener(Event.COMPLETE,this.__loadComlete);
         _loc2_ = ComponentFactory.Instance.creatCustomObject("roomList.DungeonList.pveMapIconPos");
         this._mapIcon.x = _loc2_.x;
         this._mapIcon.y = _loc2_.y;
         if(this._mapIcon.width > 115)
         {
            this._mapIcon.width = 115;
         }
         addChild(this._mapIcon);
      }
      
      public function get info() : RoomInfo
      {
         return this._info;
      }
      
      public function set info(param1:RoomInfo) : void
      {
         this._info = param1;
         this.update();
      }
      
      public function get id() : int
      {
         return this._info.ID;
      }
      
      private function update() : void
      {
         //ConsoleLog.write("update ListItemView From ????????????");
         this._itemBg.setFrame(!!this._info.isPlaying ? int(int(2)) : int(int(1)));
         this._mode.setFrame(this._info.type - 2);
         if(this._info.mapId != 0 && this._info.mapId != NAN_MAP)
         {
            this._hardLevel.setFrame(this._info.hardLevel + 2);
         }
         else
         {
            this._hardLevel.setFrame(1);
         }
         this._idText.text = String(this._info.ID);
         this._nameText.text = this._info.Name;
         this._placeCountText.text = String(this._info.totalPlayer) + "/" + String(this._info.placeCount);
         this._lock.visible = this._info.IsLocked;
      }
      
      public function dispose() : void
      {
         this._mapIcon.removeEventListener(Event.COMPLETE,this.__loadComlete);
         this._mapIcon.dispose();
         this._mode.dispose();
         this._hardLevel.dispose();
         this._itemBg.dispose();
         this._idText.dispose();
         this._nameText.dispose();
         this._placeCountText.dispose();
         this._lock.bitmapData.dispose();
         this._lock = null;
         this._mapIcon = null;
         this._mode = null;
         this._hardLevel = null;
         this._itemBg = null;
         this._idText = null;
         this._nameText = null;
         this._placeCountText = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
