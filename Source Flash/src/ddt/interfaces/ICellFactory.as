package ddt.interfaces
{
   import ddt.data.goods.ItemTemplateInfo;
   
   public interface ICellFactory
   {
       
      
      function createBagCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true) : ICell;
      
      function createPersonalInfoCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true) : ICell;
   }
}
