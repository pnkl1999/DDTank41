package com.pickgliss.ui.image
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class Scale9CornerImage extends Image
   {
       
      
      private var _imageLinks:Array;
      
      private var _images:Vector.<BitmapData>;
      
      public function Scale9CornerImage()
      {
         super();
      }
      
      override public function dispose() : void
      {
         graphics.clear();
         this.removeImages();
         this._images = null;
         this._imageLinks = null;
         super.dispose();
      }
      
      override protected function resetDisplay() : void
      {
         this._imageLinks = ComponentFactory.parasArgs(_resourceLink);
         this.removeImages();
         this.creatImages();
      }
      
      override protected function updateSize() : void
      {
         if(_changedPropeties[Component.P_width] || _changedPropeties[Component.P_height])
         {
            this.drawImage();
         }
      }
      
      private function creatImages() : void
      {
         this._images = new Vector.<BitmapData>();
         var _loc1_:int = 0;
         while(_loc1_ < this._imageLinks.length)
         {
            this._images.push(ComponentFactory.Instance.creatBitmapData(this._imageLinks[_loc1_]));
            _loc1_++;
         }
      }
      
      private function drawImage() : void
      {
         graphics.clear();
         var _loc1_:Matrix = new Matrix();
         _loc1_.tx = 0;
         _loc1_.ty = 0;
         graphics.beginBitmapFill(this._images[0],_loc1_);
         graphics.drawRect(0,0,this._images[0].width,this._images[0].height);
         _loc1_.tx = this._images[0].width;
         _loc1_.ty = 0;
         graphics.beginBitmapFill(this._images[1],_loc1_);
         graphics.drawRect(this._images[0].width,0,_width - this._images[0].width - this._images[2].width,this._images[1].height);
         _loc1_.tx = _width - this._images[2].width;
         _loc1_.ty = 0;
         graphics.beginBitmapFill(this._images[2],_loc1_);
         graphics.drawRect(_width - this._images[2].width,0,this._images[2].width,this._images[2].height);
         _loc1_.tx = 0;
         _loc1_.ty = this._images[0].height;
         graphics.beginBitmapFill(this._images[3],_loc1_);
         graphics.drawRect(0,this._images[0].height,this._images[3].width,_height - this._images[0].height - this._images[6].height);
         _loc1_.tx = this._images[0].width;
         _loc1_.ty = this._images[0].height;
         graphics.beginBitmapFill(this._images[4],_loc1_);
         graphics.drawRect(this._images[0].width,this._images[0].height,_width - this._images[0].width - this._images[2].width,_height - this._images[0].height - this._images[6].height);
         _loc1_.tx = _width - this._images[5].width;
         _loc1_.ty = this._images[2].height;
         graphics.beginBitmapFill(this._images[5],_loc1_);
         graphics.drawRect(_width - this._images[5].width,this._images[2].height,this._images[5].width,_height - this._images[2].height - this._images[8].height);
         _loc1_.tx = 0;
         _loc1_.ty = _height - this._images[6].height;
         graphics.beginBitmapFill(this._images[6],_loc1_);
         graphics.drawRect(0,_height - this._images[6].height,this._images[6].width,this._images[6].height);
         _loc1_.tx = this._images[6].width;
         _loc1_.ty = _height - this._images[7].height;
         graphics.beginBitmapFill(this._images[7],_loc1_);
         graphics.drawRect(this._images[6].width,_height - this._images[7].height,_width - this._images[6].width - this._images[8].width,this._images[7].height);
         _loc1_.tx = _width - this._images[8].width;
         _loc1_.ty = _height - this._images[8].height;
         graphics.beginBitmapFill(this._images[8],_loc1_);
         graphics.drawRect(_width - this._images[8].width,_height - this._images[8].height,this._images[8].width,this._images[8].height);
         graphics.endFill();
      }
      
      private function removeImages() : void
      {
         if(this._images == null)
         {
            return;
         }
         graphics.clear();
         var _loc1_:int = 0;
         while(_loc1_ < this._images.length)
         {
            ObjectUtils.disposeObject(this._images[_loc1_]);
            _loc1_++;
         }
      }
   }
}
