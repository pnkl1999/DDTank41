package com.pickgliss.ui.tip
{
   import flash.display.IDisplayObject;
   
   public interface ITip extends IDisplayObject
   {
       
      
      function get tipData() : Object;
      
      function set tipData(param1:Object) : void;
   }
}
