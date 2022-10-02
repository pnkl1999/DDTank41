package ddt.loader
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class MapSmallIcon extends Sprite implements Disposeable
   {
       
      
      protected var _loader:DisplayLoader;
      
      protected var _icon:Bitmap;
      
      protected var _mapID:int = 0;
      
      public function MapSmallIcon(param1:int = 9999999)
      {
         this._mapID = param1;
         super();
      }
      
      public function startLoad() : void
      {
         this.loadIcon();
      }
      
      protected function loadIcon() : void
      {
         if(this.id == 9999999)
         {
            return;
         }
         this._loader = LoaderManager.Instance.creatLoader(PathManager.solveMapIconPath(this._mapID,0),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__complete);
         LoaderManager.Instance.startLoad(this._loader);
      }
      
      private function __complete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
         if(param1.loader.isSuccess)
         {
            this._icon = param1.loader.content;
            if(this._icon)
            {
               addChild(this._icon);
            }
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function set id(param1:int) : void
      {
         this._mapID = param1;
         this.loadIcon();
      }
      
      public function get id() : int
      {
         return this._mapID;
      }
      
      public function get icon() : Bitmap
      {
         return this._icon;
      }
      
      public function dispose() : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         this._loader = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
