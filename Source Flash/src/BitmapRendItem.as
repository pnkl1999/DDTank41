package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.events.PropertyChangeEvent;
   
   public class BitmapRendItem extends Bitmap
   {
      
      public static const BASE:int = -1;
      
      public static const FRAME_BY_FRAME:int = 0;
      
      public static const CROSS_FRAME:int = 1;
      
      public static const COMPLEX:int = 2;
       
      
      private var _925155509reference:int = 0;
      
      private var _playing:Boolean = true;
      
      private var _rendMode:String;
      
      protected var _itemWidth:Number;
      
      protected var _itemHeight:Number;
      
      protected var _selfRect:Rectangle;
      
      protected var _totalFrames:int;
      
      protected var _type:int;
      
      protected var _disposed:Boolean;
      
      protected var _realRender:Boolean = true;
      
      public function BitmapRendItem(itemWidth:Number, itemHeight:Number, $rendmode:String = "original", pixelSnapping:String = "auto", smoothing:Boolean = false)
      {
         this._rendMode = $rendmode;
         this._itemWidth = itemWidth;
         this._itemHeight = itemHeight;
         var bmd:BitmapData = null;
         if(this._rendMode == BitmapRendMode.ORIGINAL)
         {
            bmd = new BitmapData(this._itemWidth,this._itemHeight,true,0);
         }
         this._selfRect = new Rectangle(0,0,this._itemWidth,this._itemHeight);
         this._totalFrames = 1;
         super(bmd,pixelSnapping,smoothing);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function set _2146088563itemWidth(value:Number) : void
      {
         if(this._itemWidth == value)
         {
            return;
         }
         this._itemWidth = value;
         bitmapData = new BitmapData(this._itemWidth,this._itemHeight,true,0);
      }
      
      private function set _1671241242itemHeight(value:Number) : void
      {
         if(this._itemHeight == value)
         {
            return;
         }
         this._itemHeight = value;
         bitmapData = new BitmapData(this._itemWidth,this._itemHeight,true,0);
      }
      
      public function get totalFrames() : int
      {
         return this._totalFrames;
      }
      
      private function onEnterFrame(evt:Event) : void
      {
         if(this._playing)
         {
            this.update();
         }
      }
      
      public function play() : void
      {
         this._playing = true;
      }
      
      public function stop() : void
      {
         this._playing = false;
      }
      
      public function reset() : void
      {
      }
      
	  internal function get copyInfo() : Array
      {
         return [bitmapData,this._selfRect,new Point(x,y)];
      }
      
      protected function update() : void
      {
      }
      
      public function dispose() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         this.stop();
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         bitmapData.dispose();
         this._disposed = true;
      }
      
      public function get rendMode() : String
      {
         return this._rendMode;
      }
      
      public function get itemWidth() : Number
      {
         return this._itemWidth;
      }
      
      public function get itemHeight() : Number
      {
         return this._itemHeight;
      }
      
      public function toXml() : XML
      {
         return new XML();
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get typeToString() : String
      {
         return "baseBitmapRendItem";
      }
      
      public function get realRender() : Boolean
      {
         return this._realRender;
      }
      
      private function set _2032707372realRender(value:Boolean) : void
      {
         this._realRender = value;
      }
      
      [Bindable(event="propertyChange")]
      public function get reference() : int
      {
         return this._925155509reference;
      }
      
      public function set reference(param1:int) : void
      {
         var _loc2_:Object = this._925155509reference;
         if(_loc2_ !== param1)
         {
            this._925155509reference = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reference",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set itemWidth(param1:Number) : void
      {
         var _loc2_:Object = this.itemWidth;
         if(_loc2_ !== param1)
         {
            this._2146088563itemWidth = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemWidth",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set itemHeight(param1:Number) : void
      {
         var _loc2_:Object = this.itemHeight;
         if(_loc2_ !== param1)
         {
            this._1671241242itemHeight = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemHeight",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set realRender(param1:Boolean) : void
      {
         var _loc2_:Object = this.realRender;
         if(_loc2_ !== param1)
         {
            this._2032707372realRender = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"realRender",_loc2_,param1));
            }
         }
      }
   }
}
