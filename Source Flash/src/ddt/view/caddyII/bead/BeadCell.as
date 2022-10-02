package ddt.view.caddyII.bead
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class BeadCell extends BaseCell
   {
       
      
      public function BeadCell()
      {
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("bead.beadCellSize");
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(0,1);
         _loc2_.graphics.drawRoundRect(0,0,_loc1_.x,_loc1_.y,12);
         _loc2_.graphics.endFill();
         super(_loc2_,null,false,false);
      }
      
      override protected function updateSize(param1:Sprite) : void
      {
         if(param1)
         {
            param1.width = _contentWidth;
            param1.height = _contentHeight;
            if(_picPos != null)
            {
               param1.x = _picPos.x;
            }
            else
            {
               param1.x = Math.abs(param1.width - _contentWidth) / 2;
            }
            if(_picPos != null)
            {
               param1.y = _picPos.y;
            }
            else
            {
               param1.y = Math.abs(param1.height - _contentHeight) / 2;
            }
         }
      }
   }
}
