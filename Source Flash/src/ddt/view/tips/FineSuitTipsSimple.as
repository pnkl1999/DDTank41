package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import ddt.data.store.FineSuitVo;
   import ddt.manager.FineSuitManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   
   public class FineSuitTipsSimple extends BaseTip
   {
       
      
      private var _icon:ScaleFrameImage;
      
      private var _typeText:FilterFrameText;
      
      private var _typeNameArr:Array;
      
      private var _title:FilterFrameText;
      
      private var _defenceTxt:FilterFrameText;
      
      private var _luckTxt:FilterFrameText;
      
      private var _magicDefTxt:FilterFrameText;
      
      private var _armorTxt:FilterFrameText;
      
      private var _agilityTxt:FilterFrameText;
      
      private var _healthTxt:FilterFrameText;
      
      private var _detail:FilterFrameText;
      
      public function FineSuitTipsSimple()
      {
         this._typeNameArr = ["Trang phục đá","Trang phục đồng","Trang phục bạc","Trang phục vàng","Trang phục ngọc","Trang phục ngọc"];
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         tipbackgound = ComponentFactory.Instance.creat("core.simpleSuitTipsBg");
         this._icon = ComponentFactory.Instance.creatComponentByStylename("fineSuit.tips.image");
         PositionUtils.setPos(this._icon,"suitTip.iconImg.Pos");
         addChild(this._icon);
         this._typeText = ComponentFactory.Instance.creat("storeFine.simpleTip.typeText");
         PositionUtils.setPos(this._typeText,"suitTip.iconTxt.Pos");
         addChild(this._typeText);
         this._title = ComponentFactory.Instance.creat("storeFine.simpleTip.titleText");
         PositionUtils.setPos(this._title,"suitTip.title.Pos");
         this._title.text = "Tiền thưởng";
         addChild(this._title);
         this._defenceTxt = ComponentFactory.Instance.creat("storeFine.simpleTip.propertyText");
         PositionUtils.setPos(this._defenceTxt,"suitTip.por0.Pos");
         addChild(this._defenceTxt);
         this._luckTxt = ComponentFactory.Instance.creat("storeFine.simpleTip.propertyText");
         PositionUtils.setPos(this._luckTxt,"suitTip.por1.Pos");
         addChild(this._luckTxt);
         this._magicDefTxt = ComponentFactory.Instance.creat("storeFine.simpleTip.propertyText");
         PositionUtils.setPos(this._magicDefTxt,"suitTip.por2.Pos");
         addChild(this._magicDefTxt);
         this._armorTxt = ComponentFactory.Instance.creat("storeFine.simpleTip.propertyText");
         PositionUtils.setPos(this._armorTxt,"suitTip.por3.Pos");
         addChild(this._armorTxt);
         this._agilityTxt = ComponentFactory.Instance.creat("storeFine.simpleTip.propertyText");
         PositionUtils.setPos(this._agilityTxt,"suitTip.por4.Pos");
         addChild(this._agilityTxt);
         this._healthTxt = ComponentFactory.Instance.creat("storeFine.simpleTip.propertyText");
         PositionUtils.setPos(this._healthTxt,"suitTip.por5.Pos");
         addChild(this._healthTxt);
         this._detail = ComponentFactory.Instance.creat("storeFine.simpleTip.propertyText");
         PositionUtils.setPos(this._detail,"storeFine.detailPos");
         this._detail.width = 162;
         this._detail.height = 75;
         this._detail.wordWrap = true;
         this._detail.text = LanguageMgr.GetTranslation("storeFine.forge.detail");
         addChild(this._detail);
      }
      
      override public function set tipData(param1:Object) : void
      {
         var _loc2_:FineSuitVo = FineSuitManager.Instance.getFineSuitPropertyByExp(int(param1));
         var _loc3_:FineSuitVo = FineSuitManager.Instance.getSuitVoByExp(int(param1));
         var _loc4_:int = _loc3_.level / 14;
         var _loc5_:int = _loc3_.level % 14 + 1;
         this._icon.setFrame(Math.min(_loc4_ + 1,5));
         if(_loc4_ == 5)
         {
            this._typeText.text = "[" + this._typeNameArr[_loc4_] + "]";
         }
         else
         {
            this._typeText.text = "[" + this._typeNameArr[_loc4_] + "] " + _loc5_ + "/14";
         }
         this._typeText.textFormatStyle = "finesuit.simpleTip.tf" + _loc4_.toString();
         this._typeText.filterString = "finesuit.simpleTip.gf" + _loc4_.toString();
         this._defenceTxt.htmlText = "Phòng thủ <font color=\'#76ff80\'>+" + _loc2_.Defence + "</font>";
         this._luckTxt.htmlText = "May mắn <font color=\'#76ff80\'>+" + _loc2_.Luck + "</font>";
         this._magicDefTxt.htmlText = "Ma Kháng <font color=\'#76ff80\'>+" + _loc2_.MagicDefence + "</font>";
         this._armorTxt.htmlText = "Hộ giáp <font color=\'#76ff80\'>+" + _loc2_.Armor + "</font>";
         this._agilityTxt.htmlText = "Nhanh nhẹn <font color=\'#76ff80\'>+" + _loc2_.Agility + "</font>";
         this._healthTxt.htmlText = "HP <font color=\'#76ff80\'>+" + _loc2_.hp + "</font>";
      }
   }
}
