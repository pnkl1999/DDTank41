package game.view
{
   import flash.display.Sprite;
   
   public class CheckCodeMixedBack extends Sprite
   {
      
      private static const CUVER_MAX:int = 10;
      
      private static const PointNum:int = 20;
      
      private static const CuverNum:int = 20;
       
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _color:uint;
      
      private var _renderBox:Sprite;
      
      private var masker:Sprite;
      
      public function CheckCodeMixedBack(param1:Number, param2:Number, param3:Number)
      {
         super();
         this._color = param3;
         this._height = param2;
         this._width = param1;
         this._renderBox = new Sprite();
         addChild(this._renderBox);
         this.createPoint();
         this.creatCurver();
         this.render();
      }
      
      private function createPoint() : void
      {
         this._renderBox.graphics.beginFill(this._color,0.5);
         var _loc1_:int = 0;
         while(_loc1_ < PointNum)
         {
            this._renderBox.graphics.drawCircle(Math.random() * this._width,Math.random() * this._height,Math.random() * 1.5);
            _loc1_++;
         }
         this._renderBox.graphics.endFill();
      }
      
      private function creatCurver() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         this._renderBox.graphics.lineStyle(1,this._color,0.5);
         var _loc1_:int = 0;
         while(_loc1_ < CuverNum)
         {
            _loc2_ = Math.random() * this._width;
            _loc3_ = Math.random() * this._height;
            this._renderBox.graphics.moveTo(_loc2_ + (Math.random() * CUVER_MAX - CUVER_MAX),_loc3_ + (Math.random() * CUVER_MAX - CUVER_MAX));
            this._renderBox.graphics.curveTo(_loc2_ + (Math.random() * CUVER_MAX - CUVER_MAX),_loc3_ + (Math.random() * CUVER_MAX - CUVER_MAX),_loc2_,_loc3_);
            _loc1_++;
         }
         this._renderBox.graphics.endFill();
      }
      
      private function render() : void
      {
         addChild(this._renderBox);
      }
   }
}
