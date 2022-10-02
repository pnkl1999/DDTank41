package com.greensock.plugins
{
   import com.greensock.TweenLite;
   
   public class EndArrayPlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
       
      
      protected var _a:Array;
      
      protected var _info:Array;
      
      public function EndArrayPlugin()
      {
         this._info = [];
         super();
         this.propName = "endArray";
         this.overwriteProps = ["endArray"];
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         if(!(param1 is Array) || !(param2 is Array))
         {
            return false;
         }
         this.init(param1 as Array,param2);
         return true;
      }
      
      public function init(param1:Array, param2:Array) : void
      {
         this._a = param1;
         var _loc3_:int = param2.length;
         while(_loc3_--)
         {
            if(param1[_loc3_] != param2[_loc3_] && param1[_loc3_] != null)
            {
               this._info[this._info.length] = new ArrayTweenInfo(_loc3_,this._a[_loc3_],param2[_loc3_] - this._a[_loc3_]);
            }
         }
      }
      
      override public function set changeFactor(param1:Number) : void
      {
         var _loc3_:ArrayTweenInfo = null;
         var _loc4_:Number = NaN;
         var _loc2_:int = this._info.length;
         if(this.round)
         {
            while(_loc2_--)
            {
               _loc3_ = this._info[_loc2_];
               _loc4_ = _loc3_.start + _loc3_.change * param1;
               if(_loc4_ > 0)
               {
                  this._a[_loc3_.index] = _loc4_ + 0.5 >> 0;
               }
               else
               {
                  this._a[_loc3_.index] = _loc4_ - 0.5 >> 0;
               }
            }
         }
         else
         {
            while(_loc2_--)
            {
               _loc3_ = this._info[_loc2_];
               this._a[_loc3_.index] = _loc3_.start + _loc3_.change * param1;
            }
         }
      }
   }
}

class ArrayTweenInfo
{
    
   
   public var index:uint;
   
   public var start:Number;
   
   public var change:Number;
   
   function ArrayTweenInfo(param1:uint, param2:Number, param3:Number)
   {
      super();
      this.index = param1;
      this.start = param2;
      this.change = param3;
   }
}
