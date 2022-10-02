package email.view
{
   import ddt.manager.LanguageMgr;
   import email.data.EmailInfoOfSended;
   import email.data.EmailType;
   
   public class EmailStripSended extends EmailStrip
   {
       
      
      public function EmailStripSended()
      {
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
         _checkBox.visible = false;
         _payImg.visible = false;
         _unReadImg.visible = false;
         _deleteBtn.visible = false;
         _emailType.visible = false;
      }
      
      override public function update() : void
      {
         _topicTxt.text = _info.Title;
         _payIMGII.visible = _info.Type == 101;
         if(_info.Type == EmailType.CONSORTION_EMAIL)
         {
            _senderTxt.text = LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripSended.sender_txtMember");
         }
         else
         {
            _senderTxt.text = LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripSended.sender_txt") + (_info as EmailInfoOfSended).Receiver;
         }
         if(_isReading)
         {
            _emailStripBg.setFrame(2);
         }
         else
         {
            _emailStripBg.setFrame(1);
         }
         _cell.centerMC.visible = true;
         _cell.centerMC.setFrame(5);
      }
   }
}
