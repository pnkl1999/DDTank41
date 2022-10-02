package com.pickgliss.ui.image
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class TiledImage extends Image
   {
       
      
      private var _imageLink:String;
      
      private var _image:BitmapData;
      
      public function TiledImage()
      {
         super();
      }
      
      override protected function resetDisplay() : void
      {
         this.removeImages();
         this.creatImages();
      }
      
      private function creatImages() : void
      {
         this._image = ComponentFactory.Instance.creatBitmapData(_resourceLink);
      }
      
      override protected function updateSize() : void
      {
         if(_changedPropeties[Component.P_width] || _changedPropeties[Component.P_height])
         {
            this.drawImage();
         }
      }
      
      private function drawImage() : void
      {
         graphics.clear();
         var _loc1_:Matrix = new Matrix();
         _loc1_.tx = 0;
         _loc1_.ty = 0;
         graphics.beginBitmapFill(this._image,_loc1_);
         graphics.drawRect(0,0,width,height);
         graphics.endFill();
      }
      
      private function removeImages() : void
      {
         if(this._image == null)
         {
            return;
         }
         graphics.clear();
         ObjectUtils.disposeObject(this._image);
      }
      
      override public function dispose() : void
      {
         graphics.clear();
         this.removeImages();
         this._image = null;
         super.dispose();
      }
   }
}
