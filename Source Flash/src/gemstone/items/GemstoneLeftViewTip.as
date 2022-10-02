package gemstone.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.text.TextFormat;
   import gemstone.info.GemstoneTipVO;
   
   public class GemstoneLeftViewTip extends BaseTip
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _tempData:Object;
      
      private var _titleTxt:FilterFrameText;
      
      private var _curPropertyTxt:FilterFrameText;
      
      private var _nextTxt:FilterFrameText;
      
      private var _nextPropertyTxt:FilterFrameText;
      
      private var _line1:Image;
      
      private var _line2:Image;
      
      public function GemstoneLeftViewTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("gemstone.tipBG");
         this.tipbackgound = this._bg;
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("gemstone.tipTxt1");
         addChild(this._titleTxt);
         this._line1 = ComponentFactory.Instance.creatComponentByStylename("gemstone.line1");
         addChild(this._line1);
         this._curPropertyTxt = ComponentFactory.Instance.creatComponentByStylename("gemstone.tipTxt2");
         addChild(this._curPropertyTxt);
         this._line2 = ComponentFactory.Instance.creatComponentByStylename("gemstone.line2");
         addChild(this._line2);
         this._nextTxt = ComponentFactory.Instance.creatComponentByStylename("gemstone.nextTxt");
         this._nextTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.nextLevel");
         addChild(this._nextTxt);
         this._nextPropertyTxt = ComponentFactory.Instance.creatComponentByStylename("gemstone.tipTxt3");
         addChild(this._nextPropertyTxt);
      }
      
      override public function set tipData(param1:Object) : void
      {
         this._tempData = param1;
         if(!this._tempData)
         {
            return;
         }
         this.updateView();
      }
      
      override public function get tipData() : Object
      {
         return this._tempData;
      }
      
      private function updateView() : void
      {
         var tempTextFormat:* = null;
         var tempTextFormat2:* = null;
         var tempData:GemstoneTipVO = _tempData as GemstoneTipVO;
         var addAttackStr:String = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.GoldenAddAttack");
         var rdcDamageStr:String = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.GoldenReduceDamage");
         switch(int(tempData.gemstoneType) - 1)
         {
            case 0:
               tempTextFormat = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF5");
               tempTextFormat2 = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF5");
               if(tempData.level == 6)
               {
                  _titleTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstone");
                  _curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.AtcAdd",tempData.increase + addAttackStr);
               }
               else
               {
                  _titleTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.redGemstoneAtc2",tempData.level);
                  _curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.AtcAdd",tempData.increase);
               }
               if(tempData.level + 1 == 6)
               {
                  _nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.AtcAdd",tempData.nextIncrease + addAttackStr);
               }
               else
               {
                  _nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.AtcAdd",tempData.nextIncrease);
               }
               break;
            case 1:
               tempTextFormat = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF6");
               tempTextFormat2 = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF6");
               if(tempData.level == 6)
               {
                  _titleTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstone");
                  _curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.DefAdd",tempData.increase + rdcDamageStr);
               }
               else
               {
                  _titleTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.bluGemstoneDef2",tempData.level);
                  _curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.DefAdd",tempData.increase);
               }
               if(tempData.level + 1 == 6)
               {
                  _nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.DefAdd",tempData.nextIncrease + rdcDamageStr);
               }
               else
               {
                  _nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.DefAdd",tempData.nextIncrease);
               }
               break;
            case 2:
               tempTextFormat = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF7");
               tempTextFormat2 = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF7");
               if(tempData.level == 6)
               {
                  _titleTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstone");
                  _curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.AgiAdd",tempData.increase + addAttackStr);
               }
               else
               {
                  _titleTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.greGemstoneAgi2",tempData.level);
                  _curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.AgiAdd",tempData.increase);
               }
               if(tempData.level + 1 == 6)
               {
                  _nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.AgiAdd",tempData.nextIncrease + addAttackStr);
               }
               else
               {
                  _nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.AgiAdd",tempData.nextIncrease);
               }
               break;
            case 3:
               tempTextFormat = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF8");
               tempTextFormat2 = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF8");
               if(tempData.level == 6)
               {
                  _titleTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstone");
                  _curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.LukAdd",tempData.increase + rdcDamageStr);
               }
               else
               {
                  _titleTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.yelGemstoneLuk2",tempData.level);
                  _curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.LukAdd",tempData.increase);
               }
               if(tempData.level + 1 == 6)
               {
                  _nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.LukAdd",tempData.nextIncrease + rdcDamageStr);
               }
               else
               {
                  _nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.LukAdd",tempData.nextIncrease);
               }
               break;
            case 4:
               tempTextFormat = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF8_1");
               tempTextFormat2 = ComponentFactory.Instance.model.getSet("gemstone.Tip.TF8_1");
               if(tempData.level == 6)
               {
                  _titleTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstone");
                  _curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.BloodAdd",tempData.increase + rdcDamageStr);
               }
               else
               {
                  _titleTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.purpleGemstoneLuk2",tempData.level);
                  _curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.BloodAdd",tempData.increase);
               }
               if(tempData.level + 1 == 6)
               {
                  _nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.BloodAdd",tempData.nextIncrease + rdcDamageStr);
                  break;
               }
               _nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.BloAdd",tempData.nextIncrease);
               break;
         }
         if(tempData.level == 0)
         {
            _curPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.inactive");
         }
         if(tempData.level >= 6)
         {
            _nextPropertyTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.fullLevel");
         }
         _titleTxt.setTextFormat(tempTextFormat);
         _curPropertyTxt.setTextFormat(tempTextFormat);
         _nextPropertyTxt.setTextFormat(tempTextFormat2);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._titleTxt);
         this._titleTxt = null;
         ObjectUtils.disposeObject(this._curPropertyTxt);
         this._curPropertyTxt = null;
         ObjectUtils.disposeObject(this._nextTxt);
         this._nextTxt = null;
         ObjectUtils.disposeObject(this._nextPropertyTxt);
         this._nextPropertyTxt = null;
         ObjectUtils.disposeObject(this._line1);
         this._line1 = null;
         ObjectUtils.disposeObject(this._line2);
         this._line2 = null;
         super.dispose();
      }
   }
}
