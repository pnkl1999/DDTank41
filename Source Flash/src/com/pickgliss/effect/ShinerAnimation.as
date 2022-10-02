package com.pickgliss.effect
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.utils.EffectUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.GradientType;
   import flash.display.InterpolationMethod;
   import flash.display.Shape;
   import flash.display.SpreadMethod;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Matrix;
   
   public class ShinerAnimation extends BaseEffect
   {
      
      public static const SPEED:String = "speed";
      
      public static const INTENSITY:String = "intensity";
      
      public static const WIDTH:String = "width";
      
      public static const EFFECT:String = "effect";
      
      public static const COLOR:String = "color";
      
      public static const BLUR_WIDTH:String = "blurWidth";
      
      public static const IS_LOOP:String = "isLoop";
       
      
      private var _addGlowEffect:Boolean = true;
      
      private var _alphas:Array;
      
      private var _colors:Array;
      
      private var _currentPosition:Number;
      
      private var _endPosition:Number;
      
      private var _isFinish:Boolean;
      
      private var _glowBlurWidth:Number = 3;
      
      private var _glowColorName:String = "blue";
      
      private var _isLoop:Boolean = true;
      
      private var _maskHeight:Number;
      
      private var _maskShape:Shape;
      
      private var _maskWidth:Number;
      
      private var _percent:Array;
      
      private var _shineAnimationContainer:Sprite;
      
      private var _sourceBitmap:Bitmap;
      
      private var _shineBitmapContainer:Sprite;
      
      private var _shineIntensity:Number = 30;
      
      private var _shineMoveSpeed:Number = 15;
      
      private var _shineWidth:Number = 100;
      
      private var _startPosition:Number;
      
      public function ShinerAnimation(param1:int)
      {
         this._maskShape = new Shape();
         super(param1);
      }
      
      override public function dispose() : void
      {
         StageReferance.stage.removeEventListener(Event.ENTER_FRAME,this.onRenderAnimation);
         ObjectUtils.disposeObject(this._shineAnimationContainer);
         ObjectUtils.disposeObject(this._sourceBitmap);
         ObjectUtils.disposeObject(this._shineBitmapContainer);
         this._shineAnimationContainer = null;
         this._sourceBitmap = null;
         this._shineBitmapContainer = null;
         super.dispose();
      }
      
      override public function initEffect(param1:DisplayObject, param2:Array) : void
      {
         super.initEffect(param1,param2);
         var _loc3_:Object = param2[0];
         if(_loc3_)
         {
            if(_loc3_[SPEED])
            {
               this._shineMoveSpeed = _loc3_[SPEED];
            }
            if(_loc3_[INTENSITY])
            {
               this._shineIntensity = _loc3_[INTENSITY];
            }
            if(_loc3_[WIDTH])
            {
               this._shineWidth = _loc3_[WIDTH];
            }
            if(_loc3_[EFFECT])
            {
               this._addGlowEffect = _loc3_[EFFECT];
            }
            if(_loc3_[COLOR])
            {
               this._glowColorName = _loc3_[COLOR];
            }
            if(_loc3_[BLUR_WIDTH])
            {
               this._glowBlurWidth = _loc3_[BLUR_WIDTH];
            }
            if(_loc3_[IS_LOOP])
            {
               this._isLoop = _loc3_[IS_LOOP];
            }
         }
         this.image_shiner(this._shineMoveSpeed,this._shineIntensity,this._shineWidth,this._addGlowEffect,this._glowColorName,this._glowBlurWidth,this._isLoop);
      }
      
      override public function play() : void
      {
         super.play();
         DisplayObjectContainer(target).addChild(this._shineAnimationContainer);
         StageReferance.stage.addEventListener(Event.ENTER_FRAME,this.onRenderAnimation);
      }
      
      override public function stop() : void
      {
         super.stop();
         if(!this._shineAnimationContainer.parent)
         {
            return;
         }
         this._shineAnimationContainer.parent.removeChild(this._shineAnimationContainer);
         StageReferance.stage.removeEventListener(Event.ENTER_FRAME,this.onRenderAnimation);
      }
      
      private function image_shiner(param1:Number, param2:Number, param3:Number, param4:Boolean, param5:String, param6:Number, param7:Boolean) : void
      {
         this._shineAnimationContainer = new Sprite();
         this._shineBitmapContainer = new Sprite();
         this._sourceBitmap = EffectUtils.creatMcToBitmap(target,16711680);
         this._shineBitmapContainer.addChild(this._sourceBitmap);
         this._shineAnimationContainer.addChild(this._shineBitmapContainer);
         EffectUtils.imageShiner(this._shineAnimationContainer,param2);
         EffectUtils.imageGlower(this._shineBitmapContainer,1,param6,15,param5);
         this.linear_fade(param3,param1,60);
      }
      
      private function linear_fade(param1:Number, param2:Number, param3:Number) : void
      {
         this._maskShape.cacheAsBitmap = true;
         this._shineAnimationContainer.cacheAsBitmap = true;
         this._shineAnimationContainer.mask = this._maskShape;
         this._maskWidth = this._shineAnimationContainer.width + param3;
         this._maskHeight = this._shineAnimationContainer.height + param3;
         this._maskShape.x = this._shineAnimationContainer.x - param3 / 2;
         this._maskShape.y = this._shineAnimationContainer.y - param3 / 2;
         this._colors = [16777215,16777215,16777215];
         this._alphas = [0,100,0];
         this._percent = [0,127,255];
         this._startPosition = -(param1 + param3);
         this._currentPosition = this._startPosition;
         this._endPosition = this._shineAnimationContainer.width + param1 + param3;
         this._shineAnimationContainer.addChild(this._maskShape);
      }
      
      private function onRenderAnimation(param1:Event) : void
      {
         this._maskShape.graphics.clear();
         var _loc2_:Matrix = new Matrix();
         _loc2_.createGradientBox(this._shineWidth,this._maskHeight,EffectUtils.toRadian(45),this._currentPosition,0);
         this._maskShape.graphics.beginGradientFill(GradientType.LINEAR,this._colors,this._alphas,this._percent,_loc2_,SpreadMethod.PAD,InterpolationMethod.LINEAR_RGB);
         this._maskShape.graphics.drawRect(0,0,this._maskWidth,this._maskHeight);
         this._maskShape.graphics.endFill();
         if(this._endPosition > this._currentPosition)
         {
            this._currentPosition += this._shineMoveSpeed;
         }
         else
         {
            this._isFinish = true;
            if(this._isLoop)
            {
               this._currentPosition = this._startPosition;
            }
            else
            {
               StageReferance.stage.removeEventListener(Event.ENTER_FRAME,this.onRenderAnimation);
            }
         }
      }
   }
}
