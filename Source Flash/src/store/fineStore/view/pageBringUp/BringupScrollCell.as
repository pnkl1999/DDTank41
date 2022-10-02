package store.fineStore.view.pageBringUp
{
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class BringupScrollCell extends Sprite implements Disposeable, IListCell
   {
      
      public static var _bringupContent:Sprite;
       
      
      private var _data:Object;
      
      public function BringupScrollCell()
      {
         if(_bringupContent != null)
         {
            addChild(_bringupContent);
         }
         super();
      }
      
      public function dispose() : void
      {
      }
      
      public function getCellValue() : *
      {
         return {};
      }
      
      public function setCellValue(param1:*) : void
      {
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
         addChild(_bringupContent);
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
