package com.pickgliss.effect
{
   import flash.display.DisplayObject;
   
   public class BaseEffect implements IEffect
   {
       
      
      protected var _target:DisplayObject;
      
      private var _id:int;
      
      public function BaseEffect(param1:int)
      {
         super();
         this._id = param1;
      }
      
      public function dispose() : void
      {
         this._target = null;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function initEffect(param1:DisplayObject, param2:Array) : void
      {
         this._target = param1;
      }
      
      public function play() : void
      {
      }
      
      public function stop() : void
      {
      }
      
      public function get target() : DisplayObject
      {
         return this._target;
      }
   }
}
