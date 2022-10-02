package fightLib.view
{
   import ddt.view.bossbox.BoxAwardsCell;
   
   public class AwardCell extends BoxAwardsCell
   {
       
      
      public function AwardCell()
      {
         super();
      }
      
      override public function set count(param1:int) : void
      {
         count_txt.parent.removeChild(count_txt);
         addChild(count_txt);
         if(param1 <= 1)
         {
            count_txt.text = "";
            return;
         }
         count_txt.text = String(param1);
      }
   }
}
