package com.pickgliss.ui.controls.list
{
   public interface ListDataListener
   {
       
      
      function intervalAdded(param1:ListDataEvent) : void;
      
      function intervalRemoved(param1:ListDataEvent) : void;
      
      function contentsChanged(param1:ListDataEvent) : void;
   }
}
