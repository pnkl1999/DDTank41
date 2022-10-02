package ddt.interfaces
{
   import bagAndInfo.cell.DragEffect;
   
   public interface IDragable
   {
       
      
      function getSource() : IDragable;
      
      function dragStop(param1:DragEffect) : void;
   }
}
