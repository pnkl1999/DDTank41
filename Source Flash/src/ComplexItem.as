package
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ComplexItem extends BitmapRendItem
   {
       
      
      protected var _items:Vector.<BitmapRendItem>;
      
      private var item:BitmapRendItem;
      
      private var tempcopyInfo:Array;
      
      public function ComplexItem($width:Number, $height:Number, $rendmode:String = "original", pixelSnapping:String = "auto", smoothing:Boolean = false)
      {
         super($width,$height,$rendmode,pixelSnapping,smoothing);
         _type = BitmapRendItem.COMPLEX;
         this._items = new Vector.<BitmapRendItem>();
      }
      
      public function addItem(item:FrameByFrameItem) : void
      {
         this._items.push(item);
         if(rendMode == BitmapRendMode.COPY_PIXEL)
         {
            item.scaleX = scaleX;
         }
      }
      
      public function removeItem(item:FrameByFrameItem) : void
      {
         var index:int = this._items.indexOf(item);
         if(index > -1)
         {
            this._items.splice(index,1);
         }
      }
      
      override public function set scaleX(value:Number) : void
      {
         var item:BitmapRendItem = null;
         super.scaleX = value;
         if(rendMode == BitmapRendMode.COPY_PIXEL)
         {
            for each(item in this._items)
            {
               item.scaleX = scaleX;
            }
         }
      }
      
      override protected function update() : void
      {
         var item:BitmapRendItem = null;
         var i:int = 0;
         if(_realRender && rendMode != BitmapRendMode.COPY_PIXEL)
         {
            bitmapData.lock();
            bitmapData.fillRect(_selfRect,0);
            for(i = 0; i < this._items.length; i++)
            {
               item = this._items[i];
               bitmapData.copyPixels(item.copyInfo[0],item.copyInfo[1],item.copyInfo[2],null,null,true);
            }
            bitmapData.unlock();
         }
      }
      
      override internal function get copyInfo() : Array
      {
         var rect:Rectangle = null;
         var result:Array = [];
         for(var i:int = 0; i < this._items.length; i++)
         {
            this.item = this._items[i];
            this.tempcopyInfo = this.item.copyInfo;
            result.push(this.tempcopyInfo[0]);
            if(scaleX == 1)
            {
               result.push(this.tempcopyInfo[1]);
               result.push(new Point(x + this.item.x,y + this.item.y));
            }
            else
            {
               rect = Rectangle(this.tempcopyInfo[1]);
               result.push(new Rectangle(x + this.item.x,y + this.item.y,rect.width,rect.height));
               result.push(new Point(-x + this.tempcopyInfo[2].x,y + this.tempcopyInfo[2].y));
            }
         }
         return result;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._items = null;
         this.item = null;
         this.tempcopyInfo = null;
      }
      
      override public function get typeToString() : String
      {
         return "复杂位图影片";
      }
      
      override public function toXml() : XML
      {
         var it:BitmapRendItem = null;
         var result:XML = <asset></asset>;
         for(var i:int = 0; i < this._items.length; i++)
         {
            it = this._items[i];
            result.appendChild(it.toXml());
         }
         result.@width = _itemWidth;
         result.@height = _itemHeight;
         result.@name = name;
         result.@type = _type;
         result.@x = x;
         result.@y = y;
         result.@rendMode = rendMode;
         return result;
      }
   }
}
