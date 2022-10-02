package com.pickgliss.ui.controls.list
{
   public interface IMutableListModel extends IListModel
   {
       
      
      function insertElementAt(param1:*, param2:int) : void;
      
      function removeElementAt(param1:int) : void;
   }
}
