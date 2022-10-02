package ddt.view.chat
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ChatScrollBar extends Sprite implements Disposeable
   {
       
      
      private var _currentIndex:int;
      
      private var _rowsOfScreen:int = 16;
      
      private var _length:int;
      
      private var _height:Number;
      
      private var _moveBtn:Sprite;
      
      private var _bitDB:BitmapData;
      
      private var _isDrag:Boolean = false;
      
      private var _backFun:Function;
      
      public function ChatScrollBar(param1:Function)
      {
         super();
         this._backFun = param1;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bitDB = ComponentFactory.Instance.creatBitmapData("asset.core.scroll.thumbV2");
         this._moveBtn = new Sprite();
         this._moveBtn.buttonMode = true;
         this._moveBtn.filters = [new GlowFilter(6705447,0.9)];
         addChild(this._moveBtn);
      }
      
      private function initEvent() : void
      {
         this._moveBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDown);
      }
      
      private function removeEvent() : void
      {
         this._moveBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDown);
         if(stage.hasEventListener(MouseEvent.MOUSE_UP))
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.__mouseUp);
         }
         if(stage.hasEventListener(MouseEvent.MOUSE_MOVE))
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__mouseMove);
         }
      }
      
      private function __mouseDown(param1:MouseEvent) : void
      {
         this._isDrag = true;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.__mouseUp);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.__mouseMove);
         this._moveBtn.startDrag(false,new Rectangle(0,0,0,this._height - this._moveBtn.height));
      }
      
      private function __mouseUp(param1:MouseEvent) : void
      {
         this._isDrag = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.__mouseUp);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__mouseMove);
         this._moveBtn.stopDrag();
      }
      
      private function __mouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this._length > this._rowsOfScreen)
         {
            _loc2_ = this._length - this._rowsOfScreen - int(this._moveBtn.y / ((this._height - this._moveBtn.height) / (this._length - this._rowsOfScreen)));
            if(_loc2_ != this._currentIndex)
            {
               this._backFun(this._moveBtn.y + this._moveBtn.height + 1 >= this._height ? 0 : _loc2_);
            }
         }
      }
      
      private function drawBackground() : void
      {
         graphics.clear();
         graphics.beginFill(0,0.5);
         graphics.drawRoundRect(4,1,4,this._height,4,4);
         graphics.endFill();
      }
      
      private function draw() : void
      {
         var _loc1_:Number = NaN;
         if(this._length > this._rowsOfScreen)
         {
            _loc1_ = this._rowsOfScreen / this._length * this._height;
            this.drawThumb(_loc1_);
            this._moveBtn.y = this._height - this._moveBtn.height - this._currentIndex * (1 / (this._length - this._rowsOfScreen)) * (this._height - _loc1_);
         }
         else
         {
            this._moveBtn.graphics.clear();
         }
      }
      
      private function drawThumb(param1:Number) : void
      {
         var _loc2_:Matrix = new Matrix();
         var _loc3_:BitmapData = new BitmapData(12,8);
         var _loc4_:BitmapData = new BitmapData(12,8);
         var _loc5_:BitmapData = new BitmapData(12,8);
         _loc3_.copyPixels(this._bitDB,new Rectangle(0,0,12,8),new Point(0,0));
         _loc4_.copyPixels(this._bitDB,new Rectangle(0,8,12,8),new Point(0,0));
         _loc5_.copyPixels(this._bitDB,new Rectangle(0,this._bitDB.height - 8,12,8),new Point(0,0));
         this._moveBtn.graphics.clear();
         this._moveBtn.graphics.beginBitmapFill(_loc3_,_loc2_,false);
         this._moveBtn.graphics.drawRect(0,0,12,8);
         this._moveBtn.graphics.beginBitmapFill(_loc4_,_loc2_);
         this._moveBtn.graphics.drawRect(0,8,12,param1 - 16);
         _loc2_.ty = param1 - 9;
         this._moveBtn.graphics.beginBitmapFill(_loc5_,_loc2_,false);
         this._moveBtn.graphics.drawRect(0,param1 - 9,12,8);
         this._moveBtn.graphics.endFill();
      }
      
      public function set length(param1:int) : void
      {
         if(this._length != param1)
         {
            this._length = param1;
            this.draw();
         }
      }
      
      public function set currentIndex(param1:int) : void
      {
         if(this._currentIndex != param1 && !this._isDrag)
         {
            this._currentIndex = param1 + this._rowsOfScreen > this._length ? int(int(this._length - this._rowsOfScreen)) : int(int(param1));
            this.draw();
         }
      }
      
      public function set Height(param1:Number) : void
      {
         if(this._height != param1)
         {
            this._height = param1;
            this.drawBackground();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._moveBtn = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
