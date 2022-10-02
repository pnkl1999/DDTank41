package bagAndInfo.bag
{
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.events.CellEvent;
   import ddt.interfaces.IPageChange;
   
   public class BagPageButton extends BaseButton implements IPageChange
   {
       
      
      public function BagPageButton()
      {
         super();
      }
      
      public function drawStop(param1:DragEffect) : void
      {
         BagAndInfoManager.Instance.dispatchEvent(new CellEvent("bagpage",param1));
      }
   }
}
