package roomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.loader.MapSmallIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class MapItemView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _mapIcon:MapSmallIcon;
      
      private var _bgII:Bitmap;
      
      private var _mapID:int;
      
      private var _cellWidth:int;
      
      private var _cellheight:int;
      
      public function MapItemView(param1:int, param2:int, param3:int)
      {
         this._mapID = param1;
         this._cellWidth = param2;
         this._cellheight = param3;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.buttonMode = true;
         this._mapIcon = new MapSmallIcon(this._mapID);
         this._mapIcon.addEventListener(Event.COMPLETE,this.__mapIconLoadComplete);
         this._mapIcon.startLoad();
         this._bgII = ComponentFactory.Instance.creat("asset.roomList.white");
         this._bgII.width = this._cellWidth;
         this._bgII.height = this._cellheight;
         this._bgII.alpha = 0;
         addChild(this._bgII);
      }
      
      private function __mapIconLoadComplete(param1:Event) : void
      {
         this._mapIcon.removeEventListener(Event.COMPLETE,this.__mapIconLoadComplete);
         this._bg = this._mapIcon.icon;
         if(this._bg)
         {
            this._bg.x = this._cellWidth / 2 - this._bg.width / 2 + 5;
            addChild(this._bg);
         }
      }
      
      public function get id() : int
      {
         return this._mapID;
      }
      
      public function dispose() : void
      {
         if(this._mapIcon)
         {
            this._mapIcon.removeEventListener(Event.COMPLETE,this.__mapIconLoadComplete);
            this._mapIcon.dispose();
            this._mapIcon = null;
         }
         if(this._bg && this._bg.parent)
         {
            this._bg.parent.removeChild(this._bg);
            this._bg = null;
         }
         if(this._bgII && this._bgII.bitmapData)
         {
            this._bgII.bitmapData.dispose();
            this._bgII = null;
         }
      }
   }
}
