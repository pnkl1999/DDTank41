package im
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   
   public class AddBlackFrame extends AddFriendFrame implements Disposeable
   {
       
      
      public function AddBlackFrame()
      {
         super();
      }
      
      override protected function initContainer() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         _alertInfo = new AlertInfo();
         _alertInfo.title = LanguageMgr.GetTranslation("tank.view.im.AddBlackListFrame.titleText");
         _alertInfo.submitEnabled = false;
         info = _alertInfo;
         _inputText = ComponentFactory.Instance.creat("textinput");
         _inputText.maxChars = MAX_CHAES;
         addToContent(_inputText);
         _explainText = ComponentFactory.Instance.creat("IM.TextStyle");
         _explainText.text = LanguageMgr.GetTranslation("tank.view.im.AddFriendFrame.name");
         addToContent(_explainText);
         _hintText = ComponentFactory.Instance.creat("IM.TextStyleII");
         _hintText.text = LanguageMgr.GetTranslation("tank.view.im.AddBlackListFrame.chat");
         addToContent(_hintText);
      }
      
      override protected function submit() : void
      {
         if(_name == "" || _name == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IMControl.addNullFriend"));
            return;
         }
         hide();
         IMController.Instance.addBlackList(_name);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
