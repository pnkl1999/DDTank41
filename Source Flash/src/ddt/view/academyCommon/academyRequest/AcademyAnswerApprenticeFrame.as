package ddt.view.academyCommon.academyRequest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import flash.geom.Point;
   
   public class AcademyAnswerApprenticeFrame extends AcademyAnswerMasterFrame implements Disposeable
   {
       
      
      public function AcademyAnswerApprenticeFrame()
      {
         super();
      }
      
      override protected function initContent() : void
      {
         var _loc1_:Point = null;
         _loc1_ = null;
         _alertInfo = new AlertInfo();
         _alertInfo.title = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyRequestMasterFrame.title");
         _alertInfo.showCancel = _alertInfo.showSubmit = _alertInfo.enterEnable = this.enterEnable = false;
         info = _alertInfo;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("AcademyAnswerMasterFrame.inputPos");
         _inputBG = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.inputBg");
         addToContent(_inputBG);
         _inputBG.y = _loc1_.x;
         _messageText = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyRequest.MessageText");
         addToContent(_messageText);
         _messageText.y = _loc1_.y;
         _explainText = ComponentFactory.Instance.creat("academyCommon.academyRequest.explainText1");
         addToContent(_explainText);
         _nameLabel = ComponentFactory.Instance.model.getSet("academyCommon.academyRequest.explainNameTextTF");
         _lookBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyAnswerApprenticeFrame.LookButton");
         addToContent(_lookBtn);
         _cancelBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyAnswerApprenticeFrame.submitButton");
         addToContent(_cancelBtn);
      }
      
      override protected function update() : void
      {
         _messageText.text = _message;
         _explainText.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyAnswerApprenticeFrame.AnswerApprentice",_name);
         _explainText.setTextFormat(_nameLabel,BINGIN_INDEX,_name.length + BINGIN_INDEX);
      }
      
      override protected function submit() : void
      {
         SocketManager.Instance.out.sendAcademyApprenticeConfirm(true,_uid);
         dispose();
      }
      
      override protected function hide() : void
      {
         SocketManager.Instance.out.sendAcademyApprenticeConfirm(false,_uid);
         dispose();
      }
   }
}
