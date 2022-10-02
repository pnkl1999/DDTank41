package com.pickgliss.effect
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.DisplayObject;
   
   public interface IEffect extends Disposeable
   {
       
      
      function initEffect(param1:DisplayObject, param2:Array) : void;
      
      function stop() : void;
      
      function play() : void;
      
      function get target() : DisplayObject;
      
      function get id() : int;
      
      function set id(param1:int) : void;
   }
}
