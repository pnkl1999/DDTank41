package newChickenBox.view
{
   import bagAndInfo.cell.BaseCell;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class NewChickenBoxCell extends BaseCell
   {
       
      
      public function NewChickenBoxCell(param1:DisplayObject, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:Boolean = true)
      {
         super(param1,param2,param3,param4);
         var _loc5_:Point = new Point(2,2);
         PicPos = _loc5_;
      }
   }
}
