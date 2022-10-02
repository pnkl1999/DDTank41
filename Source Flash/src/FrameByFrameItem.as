package
{
   import flash.display.BitmapData;
   import flash.display.PixelSnapping;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class FrameByFrameItem extends BitmapRendItem
   {
       
      
      protected var _source:BitmapData;
      
      protected var _autoStop:Boolean;
      
      protected var _rects:Vector.<Rectangle>;
      
      protected var _moveInfo:Vector.<Point>;
      
      protected var _index:int = 0;
      
      protected var _offset:Point;
      
      protected var _len:int;
      
      protected var _sourceName:String;
      
      public function FrameByFrameItem($width:Number, $height:Number, source:BitmapData, $rendmode:String = "original", autoStop:Boolean = false)
      {
         super($width,$height,$rendmode,PixelSnapping.NEVER,false);
         _type = BitmapRendItem.FRAME_BY_FRAME;
         this._source = source;
         this._autoStop = autoStop;
         this._offset = new Point();
         this.initRectangles();
         this._len = this._rects.length;
      }
      
      public function set source(value:BitmapData) : void
      {
         if(this._source == value)
         {
            return;
         }
         this._source = value;
         this.initRectangles();
         this._len = this._rects.length;
      }
      
      public function get sourceName() : String
      {
         return this._sourceName;
      }
      
      public function set sourceName(value:String) : void
      {
         this._sourceName = value;
      }
      
      public function get source() : BitmapData
      {
         return this._source;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._source = null;
      }
      
      private function initRectangles() : void
      {
         var j:int = 0;
         this._rects = new Vector.<Rectangle>();
         var rowNum:int = Math.ceil(this._source.width / _itemWidth);
         var lineNum:int = Math.ceil(this._source.height / _itemHeight);
         for(var i:int = 1; i <= lineNum; i++)
         {
            for(j = 1; j <= rowNum; j++)
            {
               this._rects.push(new Rectangle((j - 1) * _itemWidth,(i - 1) * _itemHeight,_itemWidth,_itemHeight));
            }
         }
      }
      
      override public function get totalFrames() : int
      {
         return this._len;
      }
      
      override internal function get copyInfo() : Array
      {
         if(scaleX == 1)
         {
            return [this._source,this._rects[this._index],new Point(x,y)];
         }
         return [this._source,new Rectangle(x,y,_itemWidth,_itemHeight),new Point(-this._rects[this._index].x - x - _itemWidth,y)];
      }
      
      override public function reset() : void
      {
         this._index = 0;
      }
      
      public function set moveInfo(value:Vector.<Point>) : void
      {
         this._moveInfo = value;
      }
      
      override protected function update() : void
      {
         if(_realRender && rendMode == BitmapRendMode.ORIGINAL)
         {
            bitmapData.lock();
            bitmapData.fillRect(_selfRect,0);
            bitmapData.copyPixels(this._source,this._rects[this._index],this._offset,null,null,true);
            bitmapData.unlock();
         }
         if(this._moveInfo)
         {
            x = this._moveInfo[this._index % this._moveInfo.length].x;
            y = this._moveInfo[this._index % this._moveInfo.length].y;
         }
         ++this._index;
         if(this._index >= this._len)
         {
            if(this._autoStop)
            {
               stop();
            }
            this._index = 0;
         }
      }
      
      public function get autoStop() : Boolean
      {
         return this._autoStop;
      }
      
      public function set autoStop(value:Boolean) : void
      {
         this._autoStop = value;
      }
      
      override public function toXml() : XML
      {
         var result:XML = <asset/>;
         result.@type = type;
         result.@width = _itemWidth;
         result.@height = _itemHeight;
         result.@resource = this._sourceName;
         result.@rendMode = rendMode;
         return result;
      }
      
      override public function get typeToString() : String
      {
         return "逐帧位图影片";
      }
   }
}
