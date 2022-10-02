package cardSystem.view
{
   import cardSystem.elements.CardCell;
   import com.pickgliss.ui.ComponentFactory;
   
   public class ResetCardCell extends CardCell
   {
       
      
      public function ResetCardCell()
      {
         super(ComponentFactory.Instance.creatBitmap("asset.cardSystem.reset.CardBack"));
         setContentSize(98,140);
      }
   }
}
