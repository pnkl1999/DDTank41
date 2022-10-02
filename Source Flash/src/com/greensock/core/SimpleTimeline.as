package com.greensock.core
{
   public class SimpleTimeline extends TweenCore
   {
       
      
      protected var _firstChild:TweenCore;
      
      protected var _lastChild:TweenCore;
      
      public var autoRemoveChildren:Boolean;
      
      public function SimpleTimeline(param1:Object = null)
      {
         super(0,param1);
      }
      
      public function insert(param1:TweenCore, param2:* = 0) : TweenCore
      {
         if(!param1.cachedOrphan && param1.timeline)
         {
            param1.timeline.remove(param1,true);
         }
         param1.timeline = this;
         param1.cachedStartTime = Number(param2) + param1.delay;
         if(param1.gc)
         {
            param1.setEnabled(true,true);
         }
         if(param1.cachedPaused)
         {
            param1.cachedPauseTime = param1.cachedStartTime + (this.rawTime - param1.cachedStartTime) / param1.cachedTimeScale;
         }
         if(this._lastChild)
         {
            this._lastChild.nextNode = param1;
         }
         else
         {
            this._firstChild = param1;
         }
         param1.prevNode = this._lastChild;
         this._lastChild = param1;
         param1.nextNode = null;
         param1.cachedOrphan = false;
         return param1;
      }
      
      public function remove(param1:TweenCore, param2:Boolean = false) : void
      {
         if(param1.cachedOrphan)
         {
            return;
         }
         if(!param2)
         {
            param1.setEnabled(false,true);
         }
         if(param1.nextNode)
         {
            param1.nextNode.prevNode = param1.prevNode;
         }
         else if(this._lastChild == param1)
         {
            this._lastChild = param1.prevNode;
         }
         if(param1.prevNode)
         {
            param1.prevNode.nextNode = param1.nextNode;
         }
         else if(this._firstChild == param1)
         {
            this._firstChild = param1.nextNode;
         }
         param1.cachedOrphan = true;
      }
      
      override public function renderTime(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:TweenCore = null;
         var _loc4_:TweenCore = this._firstChild;
         this.cachedTotalTime = param1;
         this.cachedTime = param1;
         while(_loc4_)
         {
            _loc6_ = _loc4_.nextNode;
            if(_loc4_.active || param1 >= _loc4_.cachedStartTime && !_loc4_.cachedPaused && !_loc4_.gc)
            {
               if(!_loc4_.cachedReversed)
               {
                  _loc4_.renderTime((param1 - _loc4_.cachedStartTime) * _loc4_.cachedTimeScale,param2,false);
               }
               else
               {
                  _loc5_ = !!_loc4_.cacheIsDirty ? Number(Number(_loc4_.totalDuration)) : Number(Number(_loc4_.cachedTotalDuration));
                  _loc4_.renderTime(_loc5_ - (param1 - _loc4_.cachedStartTime) * _loc4_.cachedTimeScale,param2,false);
               }
            }
            _loc4_ = _loc6_;
         }
      }
      
      public function get rawTime() : Number
      {
         return this.cachedTotalTime;
      }
   }
}
