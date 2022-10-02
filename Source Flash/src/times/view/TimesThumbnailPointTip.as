package times.view
{
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITip;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class TimesThumbnailPointTip extends Sprite implements ITip
   {
       
      
      private var _bg:Bitmap;
      
      private var _bitmap:Bitmap;
      
      private var _text:FilterFrameText;
      
      private var _isRevertTip:Boolean;
      
      private var _offset:Point;
      
      private var _bitmapLoader:BitmapLoader;
      
      private var _bitmapDatas:Array;
      
      public function TimesThumbnailPointTip()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.__configPos);
         addEventListener(Event.REMOVED_FROM_STAGE,this.__removeBitmap);
         this._offset = ComponentFactory.Instance.creatCustomObject("times.PagePointTipOffset");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.times.ThumbnailZoomBg");
      }
      
      public function get tipData() : Object
      {
         if(this._bitmap)
         {
            return this._bitmap.bitmapData;
         }
         return null;
      }
      
      public function set tipData(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         this._bitmapDatas = param1.bitmapDatas;
         if(this._bitmapDatas && this._bitmapDatas[param1.category] && this._bitmapDatas[param1.category][param1.page])
         {
            this._bitmap = new Bitmap(this._bitmapDatas[param1.category][param1.page].bitmapData);
            this._isRevertTip = param1.isRevertTip;
            this._bitmap.x = 11;
            this._bitmap.y = 8;
            if(this._bg)
            {
               addChild(this._bg);
            }
            return;
         }
      }
      
      private function __configPos(param1:Event = null) : void
      {
         this._bg.x = 0;
         if(this._isRevertTip)
         {
            this._bg.scaleX = -1;
            this._bg.x += this._bg.width - 3;
            x -= this._offset.x - 2;
         }
         else
         {
            this._bg.scaleX = 1;
            x += this._offset.y;
         }
         if(this._bitmap)
         {
            this._bitmap.x = 8;
            this._bitmap.y = 8;
         }
         if(this._bitmap)
         {
            addChild(this._bitmap);
         }
      }
      
      private function __removeBitmap(param1:Event) : void
      {
         if(this._bitmap && this._bitmap.parent)
         {
            this._bitmap.parent.removeChild(this._bitmap);
         }
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
