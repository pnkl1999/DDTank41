package com.pickgliss.ui.image
{
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.BitmapData;
   import org.bytearray.display.ScaleBitmap;
   
   public class ScaleBitmapImage extends Image
   {
       
      
      private var _resource:BitmapData;
      
      public function ScaleBitmapImage()
      {
         super();
      }
      
      public function set resource(param1:BitmapData) : void
      {
         if(param1 == this._resource)
         {
            return;
         }
         this._resource = param1;
         onPropertiesChanged(Image.P_reourceLink);
      }
      
      public function get resource() : BitmapData
      {
         return this._resource;
      }
      
      override protected function resetDisplay() : void
      {
         ObjectUtils.disposeObject(_display);
         var _loc1_:BitmapData = this._resource == null ? ClassUtils.CreatInstance(_resourceLink,[_width,_height]) : this._resource;
         _display = new ScaleBitmap(_loc1_);
      }
   }
}
