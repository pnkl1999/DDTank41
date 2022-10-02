package ddt.view.chat.chatBall
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ChatBallBackground extends MovieClip
   {
       
      
      private var paopaomc:MovieClip;
      
      private var _baseTextArea:Rectangle;
      
      private var _scale:Number;
      
      private var _direction:Point;
      
      public function ChatBallBackground(param1:MovieClip)
      {
         super();
         this._scale = 1;
         this.paopaomc = param1;
         addChild(this.paopaomc);
         this.paopaomc.bg.rtTopPoint.parent.removeChild(this.paopaomc.bg.rtTopPoint);
         this._baseTextArea = new Rectangle(this.paopaomc.bg.rtTopPoint.x,this.paopaomc.bg.rtTopPoint.y,this.paopaomc.bg.rtTopPoint.width,this.paopaomc.bg.rtTopPoint.height);
         this.direction = new Point(-1,-1);
      }
      
      public function fitSize(param1:Point) : void
      {
         var _loc2_:Number = param1.x / this._baseTextArea.width;
         var _loc3_:Number = param1.y / this._baseTextArea.height;
         if(_loc2_ > _loc3_)
         {
            this.scale = _loc2_;
         }
         else
         {
            this.scale = _loc3_;
         }
         this.update();
      }
      
      public function set direction(param1:Point) : void
      {
         if(x == 0)
         {
            x = -1;
         }
         if(y == 0)
         {
            y = -1;
         }
         if(this._direction == param1)
         {
            return;
         }
         this._direction = param1;
         if(this._direction == null)
         {
            return;
         }
         if(this._direction.x > 0)
         {
            this.paopaomc.scaleX = -this._scale;
         }
         else
         {
            this.paopaomc.scaleX = this._scale;
         }
         if(this._direction.y > 0)
         {
            this.paopaomc.scaleY = -this._scale;
         }
         else
         {
            this.paopaomc.scaleY = this._scale;
         }
         this.update();
      }
      
      public function get direction() : Point
      {
         return this._direction;
      }
      
      protected function set scale(param1:Number) : void
      {
         if(this._scale == param1)
         {
            return;
         }
         this._scale = param1;
         if(this.paopaomc.scaleX > 0)
         {
            this.paopaomc.scaleX = param1;
         }
         else
         {
            this.paopaomc.scaleX = -param1;
         }
         if(this.paopaomc.scaleY > 0)
         {
            this.paopaomc.scaleY = param1;
         }
         else
         {
            this.paopaomc.scaleY = -param1;
         }
         this.update();
      }
      
      protected function get scale() : Number
      {
         return this._scale;
      }
      
      public function get textArea() : Rectangle
      {
         var _loc1_:Rectangle = new Rectangle();
         if(this.paopaomc.scaleX > 0)
         {
            _loc1_.x = this._baseTextArea.x * this.scale;
         }
         else
         {
            _loc1_.x = -this._baseTextArea.right * this.scale;
         }
         if(this.paopaomc.scaleY > 0)
         {
            _loc1_.y = this._baseTextArea.y * this.scale;
         }
         else
         {
            _loc1_.y = -this._baseTextArea.bottom * this.scale;
         }
         _loc1_.width = this._baseTextArea.width * Math.abs(this.scale);
         _loc1_.height = this._baseTextArea.height * Math.abs(this.scale);
         return _loc1_;
      }
      
      public function drawTextArea() : void
      {
      }
      
      private function update() : void
      {
      }
      
      public function dispose() : void
      {
         this._baseTextArea = null;
         this.paopaomc = null;
      }
   }
}
