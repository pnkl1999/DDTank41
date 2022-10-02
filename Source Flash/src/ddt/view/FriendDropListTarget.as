package ddt.view
{
   import com.pickgliss.ui.controls.SimpleDropListTarget;
   
   public class FriendDropListTarget extends SimpleDropListTarget
   {
       
      
      public function FriendDropListTarget()
      {
         super();
      }
      
      override public function setValue(param1:*) : void
      {
         if(param1)
         {
            text = param1.NickName;
         }
      }
   }
}
