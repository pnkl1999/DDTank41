package changeColor.view
{
   import bagAndInfo.cell.LinkedBagCell;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ColorEditCell extends LinkedBagCell
   {
       
      
      public function ColorEditCell(param1:Sprite)
      {
         super(param1);
         super.DoubleClickEnabled = false;
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
         if(this.itemInfo != null)
         {
            SoundManager.instance.play("008");
            if(_bagCell.itemInfo && _bagCell.itemInfo.lock)
            {
               if(_bagCell.itemInfo.BagType == 0)
               {
                  PlayerManager.Instance.Self.Bag.unlockItem(_bagCell.itemInfo);
               }
               else
               {
                  PlayerManager.Instance.Self.PropBag.unlockItem(_bagCell.itemInfo);
               }
            }
            bagCell.locked = false;
            bagCell = null;
         }
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
      }
   }
}
