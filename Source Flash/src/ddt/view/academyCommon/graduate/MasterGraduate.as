package ddt.view.academyCommon.graduate
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   
   public class MasterGraduate extends ApprenticeGraduate implements Disposeable
   {
       
      
      private var _name:String;
      
      public function MasterGraduate()
      {
         super();
      }
      
      override protected function initContent() : void
      {
         _alertInfo = new AlertInfo();
         _alertInfo.title = LanguageMgr.GetTranslation("ddt.view.academyCommon.graduate.MasterGraduate");
         _alertInfo.submitLabel = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyRequestApprenticeFrame.submitLabel");
         _alertInfo.showCancel = false;
         info = _alertInfo;
         _textBG = ComponentFactory.Instance.creatBitmap("asset.academyCommon.Graduate.graduateTitle");
         addToContent(_textBG);
         _tieleText = ComponentFactory.Instance.creatComponentByStylename("academyCommon.graduate.ApprenticeGraduate.titleText");
         addToContent(_tieleText);
         _explainText = ComponentFactory.Instance.creatComponentByStylename("academyCommon.graduate.MasterGraduate.explainText");
         addToContent(_explainText);
         _nameLabel = ComponentFactory.Instance.model.getSet("academyCommon.graduate.ApprenticeGraduate.explainTextLabelTF");
      }
      
      public function setName(param1:String) : void
      {
         this._name = param1;
         this.update();
      }
      
      override protected function update() : void
      {
         _tieleText.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.graduate.MasterGraduate.title",this._name);
         _explainText.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.graduate.MasterGraduate.explain");
         _tieleText.setTextFormat(_nameLabel,6,this._name.length + 6);
         _explainText.setTextFormat(_nameLabel,5,9);
         _explainText.setTextFormat(_nameLabel,16,17);
      }
   }
}
