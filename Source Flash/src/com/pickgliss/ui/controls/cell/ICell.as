package com.pickgliss.ui.controls.cell
{
   import flash.display.IDisplayObject;
   
   public interface ICell extends IDisplayObject
   {
       
      
      function getCellValue() : *;
      
      function setCellValue(param1:*) : void;
   }
}
