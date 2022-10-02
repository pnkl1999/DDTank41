package com.pickgliss.ui.controls
{
   import flash.display.IDisplayObject;
   
   [Event(name="click",type="flash.events.MouseEvent")]
   public interface ISelectable extends IDisplayObject
   {
       
      
      function set autoSelect(param1:Boolean) : void;
      
      function get selected() : Boolean;
      
      function set selected(param1:Boolean) : void;
   }
}
