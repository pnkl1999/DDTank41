package game.gametrainer.view
{
   import bagAndInfo.cell.DragEffect;
   import bagAndInfo.cell.LinkedBagCell;
   import com.pickgliss.events.InteractiveEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DropCell extends LinkedBagCell
   {
       
      
      public function DropCell()
      {
         super(null);
         this.allowDrag = false;
         removeEventListener(InteractiveEvent.CLICK,__doubleClickHandler);
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.CHANGE));
         super.onMouseOver(param1);
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
         super.onMouseOut(param1);
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
      }
      
      override protected function createContentComplete() : void
      {
         super.createContentComplete();
         _pic.width = 45;
         _pic.height = 46;
      }
   }
}
