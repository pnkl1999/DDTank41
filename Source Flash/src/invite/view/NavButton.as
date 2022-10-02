package invite.view
{
   import com.pickgliss.ui.controls.BaseButton;
   
   public class NavButton extends BaseButton
   {
       
      
      private var _selected:Boolean = false;
      
      public function NavButton()
      {
         super();
         mouseChildren = false;
      }
      
      override protected function addEvent() : void
      {
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected != param1)
         {
            this._selected = param1;
            if(this._selected)
            {
               setFrame(2);
            }
            else
            {
               setFrame(1);
            }
         }
      }
   }
}
