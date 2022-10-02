package com.greensock.plugins
{
   import com.greensock.core.PropTween;
   import flash.filters.BitmapFilter;
   
   public class FilterPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 2.03;
      
      public static const API:Number = 1;
       
      
      protected var _target:Object;
      
      protected var _type:Class;
      
      protected var _filter:BitmapFilter;
      
      protected var _index:int;
      
      protected var _remove:Boolean;
      
      public function FilterPlugin()
      {
         super();
      }
      
      protected function initFilter(param1:Object, param2:BitmapFilter, param3:Array) : void
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:HexColorsPlugin = null;
         var _loc4_:Array = this._target.filters;
         var _loc8_:Object = param1 is BitmapFilter ? {} : param1;
         this._index = -1;
         if(_loc8_.index != null)
         {
            this._index = _loc8_.index;
         }
         else
         {
            _loc6_ = _loc4_.length;
            while(_loc6_--)
            {
               if(_loc4_[_loc6_] is this._type)
               {
                  this._index = _loc6_;
                  break;
               }
            }
         }
         if(this._index == -1 || _loc4_[this._index] == null || _loc8_.addFilter == true)
         {
            this._index = _loc8_.index != null ? int(int(_loc8_.index)) : int(int(_loc4_.length));
            _loc4_[this._index] = param2;
            this._target.filters = _loc4_;
         }
         this._filter = _loc4_[this._index];
         if(_loc8_.remove == true)
         {
            this._remove = true;
            this.onComplete = this.onCompleteTween;
         }
         _loc6_ = param3.length;
         while(_loc6_--)
         {
            _loc5_ = param3[_loc6_];
            if(_loc5_ in param1 && this._filter[_loc5_] != param1[_loc5_])
            {
               if(_loc5_ == "color" || _loc5_ == "highlightColor" || _loc5_ == "shadowColor")
               {
                  _loc7_ = new HexColorsPlugin();
                  _loc7_.initColor(this._filter,_loc5_,this._filter[_loc5_],param1[_loc5_]);
                  _tweens[_tweens.length] = new PropTween(_loc7_,"changeFactor",0,1,_loc5_,false);
               }
               else if(_loc5_ == "quality" || _loc5_ == "inner" || _loc5_ == "knockout" || _loc5_ == "hideObject")
               {
                  this._filter[_loc5_] = param1[_loc5_];
               }
               else
               {
                  addTween(this._filter,_loc5_,this._filter[_loc5_],param1[_loc5_],_loc5_);
               }
            }
         }
      }
      
      public function onCompleteTween() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         if(this._remove)
         {
            _loc1_ = this._target.filters;
            if(!(_loc1_[this._index] is this._type))
            {
               _loc2_ = _loc1_.length;
               while(_loc2_--)
               {
                  if(_loc1_[_loc2_] is this._type)
                  {
                     _loc1_.splice(_loc2_,1);
                     break;
                  }
               }
            }
            else
            {
               _loc1_.splice(this._index,1);
            }
            this._target.filters = _loc1_;
         }
      }
      
      override public function set changeFactor(param1:Number) : void
      {
         var _loc3_:PropTween = null;
         var _loc2_:int = _tweens.length;
         var _loc4_:Array = this._target.filters;
         while(_loc2_--)
         {
            _loc3_ = _tweens[_loc2_];
            _loc3_.target[_loc3_.property] = _loc3_.start + _loc3_.change * param1;
         }
         if(!(_loc4_[this._index] is this._type))
         {
            _loc2_ = this._index = _loc4_.length;
            while(_loc2_--)
            {
               if(_loc4_[_loc2_] is this._type)
               {
                  this._index = _loc2_;
                  break;
               }
            }
         }
         _loc4_[this._index] = this._filter;
         this._target.filters = _loc4_;
      }
   }
}
