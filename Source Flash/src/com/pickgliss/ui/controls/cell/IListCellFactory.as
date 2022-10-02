package com.pickgliss.ui.controls.cell
{
   public interface IListCellFactory
   {
       
      
      function createNewCell() : IListCell;
      
      function getCellHeight() : int;
      
      function getViewWidthNoCount() : int;
      
      function isAllCellHasSameHeight() : Boolean;
      
      function isShareCells() : Boolean;
   }
}
