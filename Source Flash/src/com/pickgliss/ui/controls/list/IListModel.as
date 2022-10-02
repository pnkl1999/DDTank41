package com.pickgliss.ui.controls.list
{
   public interface IListModel
   {
       
      
      function addListDataListener(param1:ListDataListener) : void;
      
      function getElementAt(param1:int) : *;
      
      function getSize() : int;
      
      function removeListDataListener(param1:ListDataListener) : void;
      
      function indexOf(param1:*) : int;
      
      function getCellPosFromIndex(param1:int) : Number;
      
      function getAllCellHeight() : Number;
      
      function getStartIndexByPosY(param1:Number) : int;
   }
}
