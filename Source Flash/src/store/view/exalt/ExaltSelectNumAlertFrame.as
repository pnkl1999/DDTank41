package store.view.exalt
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import store.view.strength.StrengthSelectNumAlertFrame;
   
   public class ExaltSelectNumAlertFrame extends StrengthSelectNumAlertFrame
   {
       
      
      public function ExaltSelectNumAlertFrame()
      {
         super();
      }
      
      override protected function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         _alertInfo = new AlertInfo(LanguageMgr.GetTranslation("store.Exalt.autoSplit.inputNumber"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         _alertInfo.moveEnable = false;
         info = _alertInfo;
         this.escEnable = true;
         _btn1 = ComponentFactory.Instance.creat("ddtstore.SellLeftAlerBt1");
         _btn2 = ComponentFactory.Instance.creat("ddtstore.SellLeftAlerBt2");
         _btn2.x = 237;
         _btn2.y = 88;
         _txtExplain = ComponentFactory.Instance.creatBitmap("asset.ddtstore.exaltRockNum");
         PositionUtils.setPos(_txtExplain,"asset.ddtstore.strengthNumTxtPos");
         _inputBg = ComponentFactory.Instance.creat("ddtstore.SellLeftAlerInputTextBG");
         _inputText = ComponentFactory.Instance.creat("ddtstore.SellLeftAlerInputText");
         _inputText.restrict = "0-9";
         addToContent(_txtExplain);
         addToContent(_inputBg);
         addToContent(_btn1);
         addToContent(_btn2);
         addToContent(_inputText);
      }
   }
}
