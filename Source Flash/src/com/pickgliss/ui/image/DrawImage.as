package com.pickgliss.ui.image
{
   import flash.display.Shape;
   
   public class DrawImage extends Image
   {
      
      public static const P_ellipseWidth:String = "ellipseWidth";
      
      public static const P_ellipseHeight:String = "ellipseHeight";
       
      
      private const CIRCLE:String = "circle";
      
      private const RECT:String = "rectangle";
      
      private const TRIANGLES:String = "triangles";
      
      public var imageStyle:String;
      
      public var color:uint;
      
      public var imageAlpha:Number;
      
      protected var _ellipseWidth:int;
      
      protected var _ellipseHeight:int;
      
      public function DrawImage()
      {
         this.imageAlpha = 1;
         _display = new Shape();
         super();
      }
      
      public function get ellipseWidth() : int
      {
         return this._ellipseWidth;
      }
      
      public function set ellipseWidth(param1:int) : void
      {
         if(param1 == this._ellipseWidth)
         {
            return;
         }
         this._ellipseWidth = param1;
         onPropertiesChanged(P_ellipseWidth);
      }
      
      public function get ellipseHeight() : int
      {
         return this._ellipseHeight;
      }
      
      public function set ellipseHeight(param1:int) : void
      {
         if(param1 == this._ellipseHeight)
         {
            return;
         }
         this._ellipseHeight = param1;
         onPropertiesChanged(P_ellipseHeight);
      }
      
      override protected function onProppertiesUpdate() : void
      {
         this._drawImage();
         super.onProppertiesUpdate();
      }
      
      private function _drawImage() : void
      {
         (_display as Shape).graphics.clear();
         (_display as Shape).graphics.beginFill(this.color,this.imageAlpha);
         switch(this.imageStyle)
         {
            case this.CIRCLE:
               this._buildCircle();
               break;
            case this.RECT:
               this._buildRect();
         }
      }
      
      private function _buildCircle() : void
      {
         (_display as Shape).graphics.drawEllipse(0,0,width,height);
         (_display as Shape).graphics.endFill();
      }
      
      private function _buildRect() : void
      {
         (_display as Shape).graphics.drawRoundRect(0,0,width,height,this.ellipseWidth,this.ellipseHeight);
         (_display as Shape).graphics.endFill();
      }
   }
}
