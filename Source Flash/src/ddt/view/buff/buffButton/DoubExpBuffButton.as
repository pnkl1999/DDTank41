package ddt.view.buff.buffButton
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.data.BuffInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import flash.events.MouseEvent;
   
   public class DoubExpBuffButton extends BuffButton
   {
       
      
      public function DoubExpBuffButton()
      {
         super("asset.core.doubleExpAsset");
         info = new BuffInfo(BuffInfo.DOUBEL_EXP);
      }
      
      override protected function __onclick(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         if(Setting)
         {
            return;
         }
         ShowTipManager.Instance.removeCurrentTip();
         super.__onclick(param1);
         if(PlayerManager.Instance.Self.Money >= ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue)
         {
            if(!checkBagLocked())
            {
               return;
            }
            if(!(_info && _info.IsExist))
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("tank.view.buff.doubleExp",ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue),"",LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            }
            else
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("tank.view.buff.addPrice",ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue),"",LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            }
            Setting = true;
            _loc2_.addEventListener(FrameEvent.RESPONSE,__onBuyResponse);
         }
         else
         {
            LeavePageManager.showFillFrame();
         }
      }
      
      override public function dispose() : void
      {
         Setting = false;
      }
   }
}
