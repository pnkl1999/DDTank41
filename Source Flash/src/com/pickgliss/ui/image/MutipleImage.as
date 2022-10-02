package com.pickgliss.ui.image
{
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class MutipleImage extends Image
   {
      
      public static const P_imageRect:String = "imagesRect";
       
      
      private var _imageLinks:Array;
      
      private var _imageRectString:String;
      
      private var _images:Vector.<DisplayObject>;
      
      private var _imagesRect:Vector.<InnerRectangle>;
      
      public function MutipleImage()
      {
         super();
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         if(this._images)
         {
            _loc1_ = 0;
            while(_loc1_ < this._images.length)
            {
               ObjectUtils.disposeObject(this._images[_loc1_]);
               _loc1_++;
            }
         }
         this._images = null;
         this._imagesRect = null;
         super.dispose();
      }
      
      public function set imageRectString(param1:String) : void
      {
         if(this._imageRectString == param1)
         {
            return;
         }
         this._imagesRect = new Vector.<InnerRectangle>();
         this._imageRectString = param1;
         var _loc2_:Array = ComponentFactory.parasArgs(this._imageRectString);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(String(_loc2_[_loc3_]) == "")
            {
               this._imagesRect.push(null);
            }
            else
            {
               this._imagesRect.push(ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,String(_loc2_[_loc3_]).split("|")));
            }
            _loc3_++;
         }
         onPropertiesChanged(P_imageRect);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._images == null)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._images.length)
         {
            Sprite(_display).addChild(this._images[_loc1_]);
            _loc1_++;
         }
      }
      
      override protected function init() : void
      {
         _display = new Sprite();
         super.init();
      }
      
      override protected function resetDisplay() : void
      {
         this._imageLinks = ComponentFactory.parasArgs(_resourceLink);
         this.removeImages();
         this.creatImages();
      }
      
      override protected function updateSize() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Rectangle = null;
         _loc1_ = 0;
         _loc2_ = null;
         if(this._images == null)
         {
            return;
         }
         if(_changedPropeties[Component.P_width] || _changedPropeties[Component.P_height] || _changedPropeties[P_imageRect])
         {
            _loc1_ = 0;
            while(_loc1_ < this._images.length)
            {
               if(this._imagesRect && this._imagesRect[_loc1_])
               {
                  _loc2_ = this._imagesRect[_loc1_].getInnerRect(_width,_height);
                  this._images[_loc1_].x = _loc2_.x;
                  this._images[_loc1_].y = _loc2_.y;
                  this._images[_loc1_].height = _loc2_.height;
                  this._images[_loc1_].width = _loc2_.width;
               }
               else
               {
                  this._images[_loc1_].width = _width;
                  this._images[_loc1_].height = _height;
               }
               _loc1_++;
            }
         }
      }
      
      private function creatImages() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Array = null;
         this._images = new Vector.<DisplayObject>();
         var _loc1_:int = 0;
         while(_loc1_ < this._imageLinks.length)
         {
            _loc3_ = String(this._imageLinks[_loc1_]).split("|");
            _loc2_ = ComponentFactory.Instance.creat(_loc3_[0]);
            this._images.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function removeImages() : void
      {
         if(this._images == null)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._images.length)
         {
            ObjectUtils.disposeObject(this._images[_loc1_]);
            _loc1_++;
         }
      }
   }
}
