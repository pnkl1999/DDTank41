package roomLoading.view
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import game.GameManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class RoomLoadingDungeonMapItem extends Sprite implements Disposeable
   {
       
      
      private var _mapFrame:Bitmap;
      
      private var _mapLoader:DisplayLoader;
      
      public function RoomLoadingDungeonMapItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._mapFrame = ComponentFactory.Instance.creatBitmap("asset.roomLoading.DungeonMapFrame");
         this._mapLoader = LoaderManager.Instance.creatLoader(this.solveMapPath(),BaseLoader.BITMAP_LOADER);
         this._mapLoader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         LoaderManager.Instance.startLoad(this._mapLoader);
      }
      
      private function __onLoadComplete(param1:Event) : void
      {
         if(this._mapLoader.isSuccess)
         {
            this._mapLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
            addChild(PositionUtils.setPos(Bitmap(this._mapLoader.content),"asset.roomLoading.DungeonMapLoaderPos"));
            addChild(this._mapFrame);
         }
      }
      
      private function solveMapPath() : String
      {
         var _loc1_:String = PathManager.SITE_MAIN + "image/map/";
         if(GameManager.Instance.Current.gameMode == 8)
         {
            return _loc1_ + "1133/show.jpg";
         }
         if(RoomManager.Instance.current.type == RoomInfo.LANBYRINTH_ROOM)
         {
            return _loc1_ + "214/show1.png";
         }
         var _loc2_:String = GameManager.Instance.Current.missionInfo.pic;
         var _loc3_:String = RoomManager.Instance.current.pic;
         if(RoomManager.Instance.current.isOpenBoss)
         {
            if(_loc3_ == null || _loc3_ == "")
            {
               _loc1_ += RoomManager.Instance.current.mapId + "/show1.jpg";
            }
            else
            {
               _loc1_ += RoomManager.Instance.current.mapId + "/" + _loc3_;
            }
         }
         else if(_loc2_ == null || _loc2_ == "")
         {
            _loc1_ += RoomManager.Instance.current.mapId + "/show1.jpg";
         }
         else
         {
            _loc1_ += RoomManager.Instance.current.mapId + "/" + _loc2_;
         }
         return _loc1_;
      }
      
      public function dispose() : void
      {
         this._mapLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         ObjectUtils.disposeAllChildren(this);
         this._mapFrame = null;
         this._mapLoader = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
