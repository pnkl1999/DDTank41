package
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.events.PropertyChangeEvent;
   
   public class CrossFrameItem extends FrameByFrameItem
   {
       
      
      protected var _frames:Vector.<int>;
      
      public function CrossFrameItem($width:Number, $height:Number, source:BitmapData, frames:Vector.<int> = null, $rendmode:String = "original", autoStop:Boolean = false)
      {
         var i:int = 0;
         super($width,$height,source,$rendmode,autoStop);
         _type = BitmapRendItem.CROSS_FRAME;
         if(frames == null)
         {
            frames = new Vector.<int>();
            for(i = 0; i < _len; i++)
            {
               frames.push(i);
            }
         }
         this.invalid(frames);
         this._frames = frames;
         _len = this._frames.length;
      }
      
      override internal function get copyInfo() : Array
      {
         if(_moveInfo)
         {
            x = _moveInfo[_index % _moveInfo.length].x;
            y = _moveInfo[_index % _moveInfo.length].y;
         }
         if(scaleX == 1)
         {
            return [_source,_rects[this._frames[_index]],new Point(x,y)];
         }
         return [_source,new Rectangle(x,y,_itemWidth,_itemHeight),new Point(-x - _rects[this._frames[_index]].x - _itemWidth,y)];
      }
      
      protected function invalid(value:Vector.<int>) : void
      {
         var i:int = 0;
         var endFrame:int = 0;
         for each(i in value)
         {
            if(i > endFrame)
            {
               endFrame = i;
            }
         }
         if(_rects && _rects.length <= endFrame)
         {
            throw new Error("帧数超出了图片的大小");
         }
      }
      
      public function set _896505829source(value:BitmapData) : void
      {
         super.source = value;
         this.invalid(this._frames);
      }
      
      override protected function update() : void
      {
         if(_realRender && rendMode == BitmapRendMode.ORIGINAL)
         {
            bitmapData.lock();
            bitmapData.fillRect(_selfRect,0);
            bitmapData.copyPixels(_source,_rects[this._frames[_index]],_offset,null,null,true);
            bitmapData.unlock();
         }
         if(_moveInfo)
         {
            x = _moveInfo[_index % _moveInfo.length].x;
            y = _moveInfo[_index % _moveInfo.length].y;
         }
         ++_index;
         if(_index >= _len)
         {
            if(_autoStop)
            {
               stop();
            }
            _index = 0;
         }
      }
      
      public function get frames() : Vector.<int>
      {
         return this._frames.concat();
      }
      
      private function set _1266514778frames(value:Vector.<int>) : void
      {
         if(this._frames == value)
         {
            return;
         }
         this.invalid(value);
         this._frames = value;
         _len = this._frames.length;
      }
      
      override public function get typeToString() : String
      {
         return "跳帧位图影片";
      }
      
      override public function toXml() : XML
      {
         var result:XML = <asset/>;
         result.@type = type;
         result.@width = _itemWidth;
         result.@height = _itemHeight;
         result.@resource = _sourceName;
         result.@frames = this._frames.toString();
         result.@x = x;
         result.@y = y;
         result.@name = name;
         result.@rendMode = rendMode;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      override public function set source(param1:BitmapData) : void
      {
         var _loc2_:Object = this.source;
         if(_loc2_ !== param1)
         {
            this._896505829source = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"source",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set frames(param1:Vector.<int>) : void
      {
         var _loc2_:Object = this.frames;
         if(_loc2_ !== param1)
         {
            this._1266514778frames = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"frames",_loc2_,param1));
            }
         }
      }
   }
}
