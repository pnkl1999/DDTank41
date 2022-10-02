package com.pickgliss.ui.image
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.StringUtils;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class ScaleFrameImage extends Image
   {
      
      public static const P_fillAlphaRect:String = "fillAlphaRect";
       
      
      private var _currentFrame:uint;
      
      private var _fillAlphaRect:Boolean;
      
      private var _imageLinks:Array;
      
      private var _images:Vector.<DisplayObject>;
      
      public function ScaleFrameImage()
      {
         super();
      }
      
      override public function dispose() : void
      {
         this.removeImages();
         this._images = null;
         this._imageLinks = null;
         super.dispose();
      }
      
      public function set fillAlphaRect(param1:Boolean) : void
      {
         if(this._fillAlphaRect == param1)
         {
            return;
         }
         this._fillAlphaRect = param1;
         onPropertiesChanged(P_fillAlphaRect);
      }
      
      public function get getFrame() : uint
      {
         return this._currentFrame;
      }
      
      override public function setFrame(param1:int) : void
      {
         super.setFrame(param1);
         this._currentFrame = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._images.length)
         {
            if(this._images[_loc2_] != null)
            {
               if(param1 - 1 == _loc2_)
               {
                  addChild(this._images[_loc2_]);
                  if(this._images[_loc2_] is MovieImage)
                  {
                     ((this._images[_loc2_] as MovieImage).display as MovieClip).gotoAndPlay(1);
                  }
                  if(_width != Math.round(this._images[_loc2_].width))
                  {
                     _width = Math.round(this._images[_loc2_].width);
                     _changedPropeties[Component.P_width] = true;
                  }
               }
               else if(this._images[_loc2_] && this._images[_loc2_].parent)
               {
                  removeChild(this._images[_loc2_]);
               }
            }
            _loc2_++;
         }
         this.fillRect();
      }
      
      private function fillRect() : void
      {
         if(this._fillAlphaRect)
         {
            graphics.beginFill(16711935,0);
            graphics.drawRect(0,0,_width,_height);
            graphics.endFill();
         }
      }
      
      override protected function init() : void
      {
         super.init();
      }
      
      override protected function resetDisplay() : void
      {
         this._imageLinks = ComponentFactory.parasArgs(_resourceLink);
         this.removeImages();
         this.fillImages();
         this.creatFrameImage(0);
      }
      
      override protected function updateSize() : void
      {
         var _loc1_:int = 0;
         if(this._images == null)
         {
            return;
         }
         if(_changedPropeties[Component.P_width] || _changedPropeties[Component.P_height])
         {
            _loc1_ = 0;
            while(_loc1_ < this._images.length)
            {
               if(this._images[_loc1_] != null)
               {
                  this._images[_loc1_].width = _width;
                  this._images[_loc1_].height = _height;
               }
               _loc1_++;
            }
         }
      }
      
      private function fillImages() : void
      {
         this._images = new Vector.<DisplayObject>();
         var _loc1_:int = 0;
         while(_loc1_ < this._imageLinks.length)
         {
            this._images.push(null);
            _loc1_++;
         }
      }
      
      public function creatFrameImage(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         _loc2_ = 0;
         _loc3_ = null;
         _loc2_ = 0;
         while(_loc2_ < this._imageLinks.length)
         {
            if(!StringUtils.isEmpty(this._imageLinks[_loc2_]) && this._images[_loc2_] == null)
            {
               _loc3_ = ComponentFactory.Instance.creat(this._imageLinks[_loc2_]);
               _width = Math.max(_width,_loc3_.width);
               _height = Math.max(_height,_loc3_.height);
               this._images[_loc2_] = _loc3_;
               addChild(_loc3_);
            }
            _loc2_++;
         }
      }
      
      public function getFrameImage(param1:int) : DisplayObject
      {
         return this._images[param1];
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
      
      public function get totalFrames() : int
      {
         return this._images.length;
      }
   }
}
