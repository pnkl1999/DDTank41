package email.view
{
   import ddt.data.goods.InventoryItemInfo;
   
   public class DiamondOfStrip extends DiamondBase
   {
       
      
      public function DiamondOfStrip()
      {
         super();
         countTxt.visible = false;
         diamondBg.visible = false;
      }
      
      override protected function update() : void
      {
         var annex:* = undefined;
         annex = undefined;
         annex = undefined;
         annex = _info.getAnnexByIndex(index);
         if(annex && annex is String)
         {
            _cell.visible = false;
            centerMC.visible = true;
            mouseEnabled = true;
            if(annex == "gold")
            {
               centerMC.setFrame(3);
               countTxt.text = String(_info.Gold);
            }
            else if(annex == "money")
            {
               centerMC.setFrame(2);
               countTxt.text = String(_info.Money);
            }
            else if(annex == "gift")
            {
               centerMC.setFrame(6);
               countTxt.text = String(_info.GiftToken);
            }
         }
         else if(annex)
         {
            _cell.visible = true;
            centerMC.visible = false;
            _cell.info = annex as InventoryItemInfo;
            mouseEnabled = true;
         }
         else
         {
            centerMC.visible = true;
            _cell.visible = false;
            if(_info.IsRead)
            {
               centerMC.setFrame(5);
            }
            else
            {
               centerMC.setFrame(4);
            }
            mouseEnabled = false;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
