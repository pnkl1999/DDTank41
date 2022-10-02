package com.pickgliss.ui.controls.list
{
   import flash.display.IDisplayObject;
   
   public interface IDropListTarget extends IDisplayObject
   {
       
      
      function setCursor(param1:int) : void;
      
      function get caretIndex() : int;
      
      function setValue(param1:*) : void;
      
      function getValueLength() : int;
   }
}
