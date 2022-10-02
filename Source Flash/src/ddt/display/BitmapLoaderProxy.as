package ddt.display
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class BitmapLoaderProxy extends Sprite implements Disposeable
   {
      
      public static const LOADING_FINISH:String = "loadingFinish";
       
      
      private var _loader:BitmapLoader;
      
      private var _bitmap:Bitmap;
      
      private var _size:Rectangle;
      
      private var _isSmoothing:Boolean;
      
      public function BitmapLoaderProxy(param1:String, param2:Rectangle = null, param3:Boolean = false)
      {
         super();
         this._size = param2;
         this._isSmoothing = param3;
         this._loader = LoaderManager.Instance.creatLoader(param1,BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.onComplete);
         LoaderManager.Instance.startLoad(this._loader);
      }
      
      private function onComplete(param1:LoaderEvent) : void
      {
         if(this._loader.isSuccess)
         {
            this._bitmap = this._loader.content;
            if(this._size)
            {
               this._bitmap.x = this._size.x;
               this._bitmap.y = this._size.y;
               this._bitmap.width = this._size.width;
               this._bitmap.height = this._size.height;
            }
            addChild(this._bitmap);
            this._bitmap.smoothing = this._isSmoothing;
            dispatchEvent(new Event(LOADING_FINISH));
         }
      }
      
      public function dispose() : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.onComplete);
         this._loader = null;
         if(this._bitmap)
         {
            removeChild(this._bitmap);
            this._bitmap.bitmapData.dispose();
            this._bitmap = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
