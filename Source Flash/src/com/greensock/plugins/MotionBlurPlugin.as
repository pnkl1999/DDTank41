package com.greensock.plugins
{
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.BlurFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getDefinitionByName;
   
   public class MotionBlurPlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      private static const _DEG2RAD:Number = Math.PI / 180;
      
      private static const _RAD2DEG:Number = 180 / Math.PI;
      
      private static const _point:Point = new Point(0,0);
      
      private static const _ct:ColorTransform = new ColorTransform();
      
      private static const _blankArray:Array = [];
      
      private static var _classInitted:Boolean;
      
      private static var _isFlex:Boolean;
       
      
      protected var _target:DisplayObject;
      
      protected var _time:Number;
      
      protected var _xCurrent:Number;
      
      protected var _yCurrent:Number;
      
      protected var _bd:BitmapData;
      
      protected var _bitmap:Bitmap;
      
      protected var _strength:Number = 0.05;
      
      protected var _tween:TweenLite;
      
      protected var _blur:BlurFilter;
      
      protected var _matrix:Matrix;
      
      protected var _sprite:Sprite;
      
      protected var _rect:Rectangle;
      
      protected var _angle:Number;
      
      protected var _alpha:Number;
      
      protected var _xRef:Number;
      
      protected var _yRef:Number;
      
      protected var _mask:DisplayObject;
      
      protected var _parentMask:DisplayObject;
      
      protected var _padding:int;
      
      protected var _bdCache:BitmapData;
      
      protected var _rectCache:Rectangle;
      
      protected var _cos:Number;
      
      protected var _sin:Number;
      
      protected var _smoothing:Boolean;
      
      protected var _xOffset:Number;
      
      protected var _yOffset:Number;
      
      protected var _cached:Boolean;
      
      protected var _fastMode:Boolean;
      
      public function MotionBlurPlugin()
      {
         this._blur = new BlurFilter(0,0,2);
         this._matrix = new Matrix();
         super();
         this.propName = "motionBlur";
         this.overwriteProps = ["motionBlur"];
         this.onComplete = this.disable;
         this.onDisable = this.onTweenDisable;
         this.priority = -2;
         this.activeDisable = true;
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         var x:Number = NaN;
         var y:Number = NaN;
         var target:Object = param1;
         var value:* = param2;
         var tween:TweenLite = param3;
         if(!(target is DisplayObject))
         {
            throw new Error("motionBlur tweens only work for DisplayObjects.");
         }
         if(value == false)
         {
            this._strength = 0;
         }
         else if(typeof value == "object")
         {
            this._strength = (value.strength || 1) * 0.05;
            this._blur.quality = int(int(int(value.quality))) || int(int(2));
            this._fastMode = Boolean(value.fastMode == true);
         }
         if(!_classInitted)
         {
            try
            {
               _isFlex = Boolean(getDefinitionByName("mx.managers.SystemManager"));
            }
            catch(e:Error)
            {
               _isFlex = false;
            }
            _classInitted = true;
         }
         this._target = target as DisplayObject;
         this._tween = tween;
         this._time = 0;
         this._padding = "padding" in value ? int(int(int(value.padding))) : int(int(10));
         this._smoothing = Boolean(this._blur.quality > 1);
         this._xCurrent = this._xRef = this._target.x;
         this._yCurrent = this._yRef = this._target.y;
         this._alpha = this._target.alpha;
         if("x" in this._tween.propTweenLookup && "y" in this._tween.propTweenLookup && !this._tween.propTweenLookup.x.isPlugin && !this._tween.propTweenLookup.y.isPlugin)
         {
            this._angle = Math.PI - Math.atan2(this._tween.propTweenLookup.y.change,this._tween.propTweenLookup.x.change);
         }
         else if(this._tween.vars.x != null || this._tween.vars.y != null)
         {
            x = Number(Number(this._tween.vars.x)) || Number(Number(this._target.x));
            y = Number(Number(this._tween.vars.y)) || Number(Number(this._target.y));
            this._angle = Math.PI - Math.atan2(y - this._target.y,x - this._target.x);
         }
         else
         {
            this._angle = 0;
         }
         this._cos = Math.cos(this._angle);
         this._sin = Math.sin(this._angle);
         this._bd = new BitmapData(this._target.width + this._padding * 2,this._target.height + this._padding * 2,true,16777215);
         this._bdCache = this._bd.clone();
         this._bitmap = new Bitmap(this._bd);
         this._bitmap.smoothing = this._smoothing;
         this._sprite = !!_isFlex ? new getDefinitionByName("mx.core.UIComponent")() : new Sprite();
         this._sprite.mouseEnabled = this._sprite.mouseChildren = false;
         this._sprite.addChild(this._bitmap);
         this._rectCache = new Rectangle(0,0,this._bd.width,this._bd.height);
         this._rect = this._rectCache.clone();
         if(this._target.mask)
         {
            this._mask = this._target.mask;
         }
         if(this._target.parent && this._target.parent.mask)
         {
            this._parentMask = this._target.parent.mask;
         }
         return true;
      }
      
      private function disable() : void
      {
         if(this._strength != 0)
         {
            this._target.alpha = this._alpha;
         }
         if(this._sprite.parent)
         {
            if(_isFlex && this._sprite.parent.hasOwnProperty("removeElement"))
            {
               (this._sprite.parent as Object).removeElement(this._sprite);
            }
            else
            {
               this._sprite.parent.removeChild(this._sprite);
            }
         }
         if(this._mask)
         {
            this._target.mask = this._mask;
         }
      }
      
      private function onTweenDisable() : void
      {
         if(this._tween.cachedTime != this._tween.cachedDuration && this._tween.cachedTime != 0)
         {
            this.disable();
         }
      }
      
      override public function set changeFactor(param1:Number) : void
      {
         var _loc10_:Array = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         _loc10_ = null;
         var _loc11_:Boolean = false;
         var _loc12_:Rectangle = null;
         var _loc2_:Number = this._tween.cachedTime - this._time;
         if(_loc2_ < 0)
         {
            _loc2_ = -_loc2_;
         }
         if(_loc2_ < 1e-7)
         {
            return;
         }
         var _loc3_:Number = this._target.x - this._xCurrent;
         var _loc4_:Number = this._target.y - this._yCurrent;
         var _loc5_:Number = this._target.x - this._xRef;
         var _loc6_:Number = this._target.y - this._yRef;
         _changeFactor = param1;
         if(_loc5_ > 2 || _loc6_ > 2 || _loc5_ < -2 || _loc6_ < -2)
         {
            this._angle = Math.PI - Math.atan2(_loc6_,_loc5_);
            this._cos = Math.cos(this._angle);
            this._sin = Math.sin(this._angle);
            this._xRef = this._target.x;
            this._yRef = this._target.y;
         }
         this._blur.blurX = Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_) * this._strength / _loc2_;
         this._xCurrent = this._target.x;
         this._yCurrent = this._target.y;
         this._time = this._tween.cachedTime;
         if(param1 == 0 || this._target.parent == null)
         {
            this.disable();
            return;
         }
         if(this._sprite.parent != this._target.parent && this._target.parent)
         {
            if(_isFlex && this._target.parent.hasOwnProperty("addElement"))
            {
               (this._target.parent as Object).addElementAt(this._sprite,(this._target.parent as Object).getElementIndex(this._target));
            }
            else
            {
               this._target.parent.addChildAt(this._sprite,this._target.parent.getChildIndex(this._target));
            }
            if(this._mask)
            {
               this._sprite.mask = this._mask;
            }
         }
         if(!this._fastMode || !this._cached)
         {
            _loc10_ = this._target.parent.filters;
            if(_loc10_.length != 0)
            {
               this._target.parent.filters = _blankArray;
            }
            this._target.x = this._target.y = 20000;
            _loc11_ = this._target.visible;
            this._target.visible = true;
            _loc12_ = this._target.getBounds(this._target.parent);
            if(_loc12_.width + this._blur.blurX * 2 > 2870)
            {
               this._blur.blurX = _loc12_.width >= 2870 ? Number(Number(0)) : Number(Number((2870 - _loc12_.width) * 0.5));
            }
            this._xOffset = 20000 - _loc12_.x + this._padding;
            this._yOffset = 20000 - _loc12_.y + this._padding;
            _loc12_.width += this._padding * 2;
            _loc12_.height += this._padding * 2;
            if(_loc12_.height > this._bdCache.height || _loc12_.width > this._bdCache.width)
            {
               this._bdCache = new BitmapData(_loc12_.width,_loc12_.height,true,16777215);
               this._rectCache = new Rectangle(0,0,this._bdCache.width,this._bdCache.height);
            }
            this._matrix.tx = this._padding - _loc12_.x;
            this._matrix.ty = this._padding - _loc12_.y;
            this._matrix.a = this._matrix.d = 1;
            this._matrix.b = this._matrix.c = 0;
            _loc12_.x = _loc12_.y = 0;
            if(this._target.alpha == 0.00390625)
            {
               this._target.alpha = this._alpha;
            }
            else
            {
               this._alpha = this._target.alpha;
            }
            if(this._parentMask)
            {
               this._target.parent.mask = null;
            }
            this._bdCache.fillRect(this._rectCache,16777215);
            this._bdCache.draw(this._target.parent,this._matrix,_ct,"normal",_loc12_,this._smoothing);
            if(this._parentMask)
            {
               this._target.parent.mask = this._parentMask;
            }
            this._target.visible = _loc11_;
            this._target.x = this._xCurrent;
            this._target.y = this._yCurrent;
            if(_loc10_.length != 0)
            {
               this._target.parent.filters = _loc10_;
            }
            this._cached = true;
         }
         else if(this._target.alpha != 0.00390625)
         {
            this._alpha = this._target.alpha;
         }
         this._target.alpha = 0.00390625;
         this._matrix.tx = this._matrix.ty = 0;
         this._matrix.a = this._cos;
         this._matrix.b = this._sin;
         this._matrix.c = -this._sin;
         this._matrix.d = this._cos;
         if((_loc7_ = this._matrix.a * this._bdCache.width) < 0)
         {
            this._matrix.tx = -_loc7_;
            _loc7_ = -_loc7_;
         }
         if((_loc9_ = this._matrix.c * this._bdCache.height) < 0)
         {
            this._matrix.tx -= _loc9_;
            _loc7_ -= _loc9_;
         }
         else
         {
            _loc7_ += _loc9_;
         }
         if((_loc8_ = this._matrix.d * this._bdCache.height) < 0)
         {
            this._matrix.ty = -_loc8_;
            _loc8_ = -_loc8_;
         }
         if((_loc9_ = this._matrix.b * this._bdCache.width) < 0)
         {
            this._matrix.ty -= _loc9_;
            _loc8_ -= _loc9_;
         }
         else
         {
            _loc8_ += _loc9_;
         }
         _loc7_ += this._blur.blurX * 2;
         this._matrix.tx += this._blur.blurX;
         if(_loc7_ > this._bd.width || _loc8_ > this._bd.height)
         {
            this._bd = this._bitmap.bitmapData = new BitmapData(_loc7_,_loc8_,true,16777215);
            this._rect = new Rectangle(0,0,this._bd.width,this._bd.height);
            this._bitmap.smoothing = this._smoothing;
         }
         this._bd.fillRect(this._rect,16777215);
         this._bd.draw(this._bdCache,this._matrix,_ct,"normal",this._rect,this._smoothing);
         this._bd.applyFilter(this._bd,this._rect,_point,this._blur);
         this._bitmap.x = 0 - (this._matrix.a * this._xOffset + this._matrix.c * this._yOffset + this._matrix.tx);
         this._bitmap.y = 0 - (this._matrix.d * this._yOffset + this._matrix.b * this._xOffset + this._matrix.ty);
         this._matrix.b = -this._sin;
         this._matrix.c = this._sin;
         this._matrix.tx = this._xCurrent;
         this._matrix.ty = this._yCurrent;
         this._sprite.transform.matrix = this._matrix;
      }
   }
}
