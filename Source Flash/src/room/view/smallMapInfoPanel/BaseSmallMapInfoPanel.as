package room.view.smallMapInfoPanel
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.RoomEvent;
   import ddt.manager.PathManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import room.model.RoomInfo;
   
   public class BaseSmallMapInfoPanel extends Sprite implements Disposeable
   {
      
      protected static const DEFAULT_MAP_ID:String = "10000";
       
      
      protected var _info:RoomInfo;
      
      private var _bg:Bitmap;
      
      private var _smallMapIcon:Bitmap;
      
      private var _smallMapContainer:Sprite;
      
      private var _loader:DisplayLoader;
      
      public function BaseSmallMapInfoPanel()
      {
         super();
         this.initView();
      }
      
      protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.room.view.smallMapInfoPanel.roomSmallMapPanelBgAsset");
         addChild(this._bg);
         this._smallMapContainer = ComponentFactory.Instance.creatCustomObject("asset.room.view.smallMapInfoPanel.smallMapContainer");
         addChild(this._smallMapContainer);
         this._loader = LoaderManager.Instance.creatLoader(this.solvePath(),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
         LoaderManager.Instance.startLoad(this._loader);
      }
      
      protected function solvePath() : String
      {
         if(this._info && this._info.mapId > 0)
         {
            return PathManager.SITE_MAIN + "image/map/" + this._info.mapId.toString() + "/samll_map.png";
         }
         return PathManager.SITE_MAIN + "image/map/" + DEFAULT_MAP_ID + "/samll_map.png";
      }
      
      protected function __completeHandler(param1:LoaderEvent) : void
      {
         var _loc2_:Rectangle = null;
         if(this._loader)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
         }
         if(this._loader.isSuccess)
         {
            ObjectUtils.disposeAllChildren(this._smallMapContainer);
            this._smallMapIcon = this._loader.content as Bitmap;
            _loc2_ = ComponentFactory.Instance.creatCustomObject("asset.smallInfoPanel.imageRect");
            this._smallMapIcon.width = _loc2_.width;
            this._smallMapIcon.height = _loc2_.height;
            this._smallMapContainer.addChild(this._smallMapIcon);
         }
      }
      
      public function set info(param1:RoomInfo) : void
      {
         this._info = param1;
         this._info.addEventListener(RoomEvent.MAP_CHANGED,this.__update);
         this._info.addEventListener(RoomEvent.MAP_TIME_CHANGED,this.__update);
         this._info.addEventListener(RoomEvent.HARD_LEVEL_CHANGED,this.__update);
         this.updateView();
      }
      
      private function __update(param1:Event) : void
      {
         this.updateView();
      }
      
      protected function updateView() : void
      {
         if(this._loader)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
            this._loader = null;
         }
         ObjectUtils.disposeAllChildren(this._smallMapContainer);
         this._loader = LoaderManager.Instance.creatLoader(this.solvePath(),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
         LoaderManager.Instance.startLoad(this._loader);
      }
      
      public function dispose() : void
      {
         this._info.removeEventListener(RoomEvent.MAP_CHANGED,this.__update);
         this._info.removeEventListener(RoomEvent.MAP_TIME_CHANGED,this.__update);
         this._info.removeEventListener(RoomEvent.HARD_LEVEL_CHANGED,this.__update);
         if(this._loader)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__completeHandler);
         }
         removeChild(this._bg);
         this._bg.bitmapData.dispose();
         this._bg = null;
         this._smallMapIcon = null;
         ObjectUtils.disposeAllChildren(this._smallMapContainer);
         removeChild(this._smallMapContainer);
         this._smallMapContainer = null;
         this._info = null;
         this._loader = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
