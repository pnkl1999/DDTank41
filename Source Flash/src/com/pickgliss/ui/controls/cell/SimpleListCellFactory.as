package com.pickgliss.ui.controls.cell
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.StringUtils;
   
   public class SimpleListCellFactory implements IListCellFactory
   {
       
      
      private var _ViewWidthNoCount:int;
      
      private var _allCellHasSameHeight:Boolean;
      
      private var _cellHeight:int;
      
      private var _cellStyle:String;
      
      private var _shareCells:Boolean;
      
      public function SimpleListCellFactory(param1:String, param2:int, param3:int = -1, param4:String = "true", param5:String = "true")
      {
         super();
         this._cellStyle = param1;
         this._allCellHasSameHeight = StringUtils.converBoolean(param4);
         this._shareCells = StringUtils.converBoolean(param5);
         this._cellHeight = param2;
         this._ViewWidthNoCount = param3;
      }
      
      public function createNewCell() : IListCell
      {
         return ComponentFactory.Instance.creat(this._cellStyle);
      }
      
      public function getCellHeight() : int
      {
         return this._cellHeight;
      }
      
      public function getViewWidthNoCount() : int
      {
         return this._ViewWidthNoCount;
      }
      
      public function isAllCellHasSameHeight() : Boolean
      {
         return this._allCellHasSameHeight;
      }
      
      public function isShareCells() : Boolean
      {
         return this._shareCells;
      }
   }
}
