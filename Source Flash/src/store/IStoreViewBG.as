package store
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.core.Disposeable;
   import flash.utils.Dictionary;
   
   public interface IStoreViewBG extends Disposeable
   {
       
      
      function dragDrop(param1:BagCell) : void;
      
      function refreshData(param1:Dictionary) : void;
      
      function updateData() : void;
      
      function hide() : void;
      
      function show() : void;
   }
}
