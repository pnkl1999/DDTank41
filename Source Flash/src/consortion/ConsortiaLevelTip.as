package consortion
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   
   public class ConsortiaLevelTip extends BaseTip
   {
       
      
      private var _tempData:Vector.<String>;
      
      private var _bg:ScaleBitmapImage;
      
      private var _explainText:FilterFrameText;
      
      private var _explainText2:FilterFrameText;
      
      private var _nextLevelText:FilterFrameText;
      
      private var _nextLevelText2:FilterFrameText;
      
      private var _requirementsText:FilterFrameText;
      
      private var _requirementsText2:FilterFrameText;
      
      private var _consumptionText:FilterFrameText;
      
      private var _consumptionText2:FilterFrameText;
      
      private var _explain:String;
      
      private var _nextLevel:String;
      
      private var _requirements:String;
      
      private var _consumption:String;
      
      public function ConsortiaLevelTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._explainText = ComponentFactory.Instance.creatComponentByStylename("consortia.tipText1");
         this._explainText2 = ComponentFactory.Instance.creatComponentByStylename("consortia.tipText2");
         this._nextLevelText = ComponentFactory.Instance.creatComponentByStylename("consortia.tipText1");
         this._nextLevelText2 = ComponentFactory.Instance.creatComponentByStylename("consortia.tipText2");
         this._requirementsText = ComponentFactory.Instance.creatComponentByStylename("consortia.tipText1");
         this._requirementsText2 = ComponentFactory.Instance.creatComponentByStylename("consortia.tipText2");
         this._consumptionText = ComponentFactory.Instance.creatComponentByStylename("consortia.tipText1");
         this._consumptionText2 = ComponentFactory.Instance.creatComponentByStylename("consortia.tipText2");
         this._explainText.text = LanguageMgr.GetTranslation("ddt.consortion.levelTip.explain");
         this._nextLevelText.text = LanguageMgr.GetTranslation("ddt.consortion.levelTip.nextLevel");
         this._requirementsText.text = LanguageMgr.GetTranslation("ddt.consortion.levelTip.requirements");
         this._consumptionText.text = LanguageMgr.GetTranslation("ddt.consortion.levelTip.consumption");
         this.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         mouseChildren = false;
         mouseEnabled = false;
         addChild(this._explainText);
         addChild(this._explainText2);
         addChild(this._nextLevelText);
         addChild(this._nextLevelText2);
         addChild(this._requirementsText);
         addChild(this._requirementsText2);
         addChild(this._consumptionText);
         addChild(this._consumptionText2);
      }
      
      override public function get tipData() : Object
      {
         return this._tempData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         this._tempData = param1 as Vector.<String>;
         this._explainText2.text = param1[0] == null ? "" : param1[0];
         this._nextLevelText.y = this._nextLevelText2.y = this._explainText2.y + this._explainText2.textHeight + 5;
         this._nextLevelText2.text = param1[1] == null ? "" : param1[1];
         this._requirementsText.y = this._requirementsText2.y = this._nextLevelText2.y + this._nextLevelText2.textHeight + 5;
         this._requirementsText2.htmlText = param1[2] == null ? "" : param1[2];
         this._consumptionText.y = this._consumptionText2.y = this._requirementsText2.y + this._requirementsText2.textHeight + 5;
         this._consumptionText2.htmlText = param1[3] == null ? "" : param1[3];
         this.drawBG();
      }
      
      private function reset() : void
      {
         this._bg.height = 0;
         this._bg.width = 0;
      }
      
      private function drawBG(param1:int = 0) : void
      {
         this.reset();
         this._bg.width = 286;
         this._bg.height = this._consumptionText2.y + this._consumptionText2.textHeight + 10;
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._tempData = null;
         this._bg = null;
         this._explainText = null;
         this._explainText2 = null;
         this._nextLevelText = null;
         this._nextLevelText2 = null;
         this._requirementsText = null;
         this._requirementsText2 = null;
         this._consumptionText = null;
         this._consumptionText2 = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
