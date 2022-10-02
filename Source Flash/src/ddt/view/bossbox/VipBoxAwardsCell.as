package ddt.view.bossbox
{
   import com.pickgliss.ui.ComponentFactory;
   
   public class VipBoxAwardsCell extends BoxAwardsCell
   {
       
      
      public function VipBoxAwardsCell()
      {
         super();
      }
      
      override protected function initII() : void
      {
         var _loc1_:* = ComponentFactory.Instance.creat("asset.vip.cellBG");
         addChild(_loc1_);
         _itemName = ComponentFactory.Instance.creat("roulette.GoodsCellName");
         _itemName.mouseEnabled = false;
         _itemName.multiline = true;
         _itemName.wordWrap = true;
         addChild(_itemName);
         count_txt = ComponentFactory.Instance.creat("bossbox.boxCellCount");
         addChild(count_txt);
      }
   }
}
