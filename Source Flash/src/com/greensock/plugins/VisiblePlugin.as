package com.greensock.plugins
{
   import com.greensock.TweenLite;
   
   public class VisiblePlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
       
      
      protected var _target:Object;
      
      protected var _tween:TweenLite;
      
      protected var _visible:Boolean;
      
      protected var _initVal:Boolean;
      
      public function VisiblePlugin()
      {
         super();
         this.propName = "visible";
         this.overwriteProps = ["visible"];
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         this._target = param1;
         this._tween = param3;
         this._initVal = this._target.visible;
         this._visible = Boolean(param2);
         return true;
      }
      
      override public function set changeFactor(param1:Number) : void
      {
         if(param1 == 1 && (this._tween.cachedDuration == this._tween.cachedTime || this._tween.cachedTime == 0))
         {
            this._target.visible = this._visible;
         }
         else
         {
            this._target.visible = this._initVal;
         }
      }
   }
}
