package com.pickgliss.ui.image
{
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class CloneImage extends Image
   {
      
      public static const P_direction:String = "direction";
      
      public static const P_gape:String = "gape";
       
      
      protected var _brush:BitmapData;
      
      protected var _direction:int = -1;
      
      protected var _gape:int = 0;
      
      private var _brushHeight:Number;
      
      private var _brushWidth:Number;
      
      public function CloneImage()
      {
         super();
      }
      
      public function set direction(param1:int) : void
      {
         if(this._direction == param1)
         {
            return;
         }
         this._direction = param1;
         onPropertiesChanged(P_direction);
      }
      
      override public function dispose() : void
      {
         graphics.clear();
         ObjectUtils.disposeObject(this._brush);
         this._brush = null;
         super.dispose();
      }
      
      public function set gape(param1:int) : void
      {
         if(this._gape == param1)
         {
            return;
         }
         this._gape = param1;
         onPropertiesChanged(P_gape);
      }
      
      override protected function resetDisplay() : void
      {
         graphics.clear();
         this._brushWidth = _width;
         this._brushHeight = _height;
         this._brush = ClassUtils.CreatInstance(_resourceLink,[0,0]);
      }
      
      override protected function updateSize() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Matrix = null;
         var _loc3_:int = 0;
         if(_changedPropeties[Component.P_width] || _changedPropeties[Component.P_height] || _changedPropeties[P_direction] || _changedPropeties[P_gape])
         {
            _loc1_ = 0;
            if(this._direction != -1)
            {
               if(this._direction == 1)
               {
                  _loc1_ = _height / this._brush.height;
               }
               else
               {
                  _loc1_ = _width / this._brush.width;
               }
            }
            graphics.clear();
            graphics.beginBitmapFill(this._brush);
            _loc2_ = new Matrix();
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               if(this._direction == 1)
               {
                  graphics.drawRect(0,_loc3_ * this._brush.height + this._gape,this._brush.width,this._brush.height);
               }
               else if(this._direction > 1)
               {
                  graphics.drawRect(_loc3_ * this._brush.width + this._gape,0,this._brush.width,this._brush.height);
               }
               else
               {
                  graphics.drawRect(0,0,this._brush.width,this._brush.height);
               }
               _loc3_++;
            }
            graphics.endFill();
         }
      }
   }
}
