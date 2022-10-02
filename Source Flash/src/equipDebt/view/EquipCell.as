package equipDebt.view
{
   import bagAndInfo.cell.BaseCell;
   import flash.display.Shape;
   
   public class EquipCell extends BaseCell
   {
       
      
      public function EquipCell()
      {
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,50,50);
         _loc1_.graphics.endFill();
         super(_loc1_);
      }
   }
}
