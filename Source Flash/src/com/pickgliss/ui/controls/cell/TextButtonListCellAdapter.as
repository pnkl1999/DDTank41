package com.pickgliss.ui.controls.cell
{
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.list.List;
   
   public class TextButtonListCellAdapter extends TextButton implements IListCell
   {
       
      
      public function TextButtonListCellAdapter()
      {
         super();
      }
      
      public function getCellValue() : *
      {
         return _text;
      }
      
      public function setCellValue(param1:*) : void
      {
         text = param1;
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
   }
}
