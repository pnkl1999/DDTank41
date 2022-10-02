package texpSystem.view
{
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.manager.ItemManager;
   import ddt.view.tips.GoodTipInfo;
   
   public class TexpBuyButton extends BaseButton
   {
       
      
      private var _itemID:int;
      
      public function TexpBuyButton()
      {
         super();
      }
      
      public function setup(param1:int) : void
      {
         this._itemID = param1;
         this.initTip();
      }
      
      private function initTip() : void
      {
         var _loc1_:GoodTipInfo = new GoodTipInfo();
         _loc1_.itemInfo = ItemManager.Instance.getTemplateById(this._itemID);
         _loc1_.isBalanceTip = false;
         _loc1_.typeIsSecond = false;
         tipData = _loc1_;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
