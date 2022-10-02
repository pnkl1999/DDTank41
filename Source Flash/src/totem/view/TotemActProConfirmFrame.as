package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.SimpleAlert;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   
   public class TotemActProConfirmFrame extends SimpleAlert
   {
       
      
      private var _scb:SelectedCheckButton;
      
      public function TotemActProConfirmFrame()
      {
         super();
      }
      
      public function get isNoPrompt() : Boolean
      {
         return this._scb.selected;
      }
      
      override public function set info(param1:AlertInfo) : void
      {
         super.info = param1;
         this._scb = ComponentFactory.Instance.creatComponentByStylename("totem.activateProtect.scb");
         addToContent(this._scb);
         this._scb.text = LanguageMgr.GetTranslation("ddt.consortiaBattle.buyConfirm.noAlertTxt");
         _seleContent.y += 28;
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(!_seleContent)
         {
            return;
         }
         _backgound.width = Math.max(_width,_seleContent.width + 14);
         _backgound.height = _height + 44;
         _submitButton.y += 44;
         _cancelButton.y += 44;
      }
   }
}
