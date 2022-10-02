package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import pet.date.PetInfo;
   
   public class PetGrowUpTip extends BaseTip
   {
       
      
      protected var _name:FilterFrameText;
      
      protected var _attackLbl:FilterFrameText;
      
      protected var _attackTxt:FilterFrameText;
      
      protected var _defenceLbl:FilterFrameText;
      
      protected var _defenceTxt:FilterFrameText;
      
      protected var _HPLbl:FilterFrameText;
      
      protected var _HPTxt:FilterFrameText;
      
      protected var _agilitykLbl:FilterFrameText;
      
      protected var _agilityTxt:FilterFrameText;
      
      protected var _luckLbl:FilterFrameText;
      
      protected var _luckTxt:FilterFrameText;
      
      private var _splitImg:ScaleBitmapImage;
      
      protected var _bg:ScaleBitmapImage;
      
      protected var _container:Sprite;
      
      protected var _info:PetInfo;
      
      private var LEADING:int = 5;
      
      public function PetGrowUpTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._name = ComponentFactory.Instance.creat("petbags.text.petName");
         this._attackLbl = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipName");
         this._attackLbl.text = LanguageMgr.GetTranslation("attack") + ":";
         this._attackTxt = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipValue");
         this._defenceLbl = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipName");
         this._defenceLbl.text = LanguageMgr.GetTranslation("defence") + ":";
         this._defenceTxt = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipValue");
         this._HPLbl = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipName");
         this._HPLbl.text = LanguageMgr.GetTranslation("MaxHp") + ":";
         this._HPTxt = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipValue");
         this._agilitykLbl = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipName");
         this._agilitykLbl.text = LanguageMgr.GetTranslation("agility") + ":";
         this._agilityTxt = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipValue");
         this._luckLbl = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipName");
         this._luckLbl.text = LanguageMgr.GetTranslation("luck") + ":";
         this._luckTxt = ComponentFactory.Instance.creat("petbags.text.petGrowUpTipValue");
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._splitImg = ComponentFactory.Instance.creatComponentByStylename("petGrowUpTips.line");
         this._container = new Sprite();
         this._container.addChild(this._name);
         this._container.addChild(this._attackLbl);
         this._container.addChild(this._attackTxt);
         this._container.addChild(this._defenceLbl);
         this._container.addChild(this._defenceTxt);
         this._container.addChild(this._HPLbl);
         this._container.addChild(this._HPTxt);
         this._container.addChild(this._agilitykLbl);
         this._container.addChild(this._agilityTxt);
         this._container.addChild(this._luckLbl);
         this._container.addChild(this._luckTxt);
         this._container.addChild(this._splitImg);
         super.init();
         this.tipbackgound = this._bg;
      }
      
      protected function fixPos() : void
      {
         this._splitImg.y = this._name.y + this._name.textHeight + this.LEADING * 1.5;
         this._HPLbl.y = this._splitImg.y + this._splitImg.height + this.LEADING;
         this._HPTxt.y = this._HPLbl.y;
         this._HPTxt.x = this._HPLbl.x + this._HPLbl.textWidth + this.LEADING;
         this._attackLbl.y = this._HPLbl.y + this._HPLbl.textHeight + this.LEADING;
         this._attackTxt.x = this._attackLbl.x + this._attackLbl.textWidth + this.LEADING;
         this._attackTxt.y = this._attackLbl.y;
         this._defenceLbl.y = this._attackLbl.y + this._agilitykLbl.textHeight + this.LEADING;
         this._defenceTxt.y = this._defenceLbl.y;
         this._defenceTxt.x = this._defenceLbl.x + this._defenceLbl.textWidth + this.LEADING;
         this._agilitykLbl.y = this._defenceLbl.y + this._defenceLbl.textHeight + this.LEADING;
         this._agilityTxt.y = this._agilitykLbl.y;
         this._agilityTxt.x = this._agilitykLbl.x + this._agilitykLbl.textWidth + this.LEADING;
         this._luckLbl.y = this._agilitykLbl.y + this._agilitykLbl.textHeight + this.LEADING;
         this._luckTxt.y = this._luckLbl.y;
         this._luckTxt.x = this._luckLbl.x + this._luckLbl.textWidth + this.LEADING;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._container);
         this._container.mouseEnabled = false;
         this._container.mouseChildren = false;
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
      
      override public function get tipData() : Object
      {
         return this._info;
      }
      
      override public function set tipData(param1:Object) : void
      {
         this._info = param1 as PetInfo;
         if(this._info)
         {
            this.updateView();
         }
      }
      
      protected function updateView() : void
      {
         this._name.text = this._info.Name;
         var _loc1_:Number = PetconfigAnalyzer.PetCofnig.PropertiesRate;
         var _loc2_:Number = this._info.AttackGrow / _loc1_;
         this._attackTxt.text = this._info.Attack > 0 ? "(" + _loc2_.toFixed(1) + ")" : "";
         var _loc3_:Number = this._info.DefenceGrow / _loc1_;
         this._defenceTxt.text = this._info.Defence > 0 ? "(" + _loc3_.toFixed(1) + ")" : "";
         var _loc4_:Number = this._info.AgilityGrow / _loc1_;
         this._agilityTxt.text = this._info.Agility > 0 ? "(" + _loc4_.toFixed(1) + ")" : "";
         this._HPTxt.text = this._info.Blood > 0 ? "(" + (this._info.BloodGrow / _loc1_).toFixed(1) + ")" : "";
         var _loc5_:Number = this._info.LuckGrow / _loc1_;
         this._luckTxt.text = this._info.Luck > 0 ? "(" + _loc5_.toFixed(1) + ")" : "";
         this.fixPos();
         this._bg.width = this._container.width + 10;
         this._bg.height = this._container.height + 20;
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      override public function dispose() : void
      {
         this._info = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(this._luckTxt)
         {
            ObjectUtils.disposeObject(this._luckTxt);
            this._luckTxt = null;
         }
         if(this._splitImg)
         {
            ObjectUtils.disposeObject(this._splitImg);
            this._splitImg = null;
         }
         if(this._container)
         {
            ObjectUtils.disposeObject(this._container);
            this._container = null;
         }
         if(this._luckLbl)
         {
            ObjectUtils.disposeObject(this._luckLbl);
            this._luckLbl = null;
         }
         if(this._agilityTxt)
         {
            ObjectUtils.disposeObject(this._agilityTxt);
            this._agilityTxt = null;
         }
         if(this._agilitykLbl)
         {
            ObjectUtils.disposeObject(this._agilitykLbl);
            this._agilitykLbl = null;
         }
         if(this._HPLbl)
         {
            ObjectUtils.disposeObject(this._HPLbl);
            this._HPLbl = null;
         }
         if(this._HPTxt)
         {
            ObjectUtils.disposeObject(this._HPTxt);
            this._HPTxt = null;
         }
         if(this._defenceTxt)
         {
            ObjectUtils.disposeObject(this._defenceTxt);
            this._defenceTxt = null;
         }
         if(this._defenceLbl)
         {
            ObjectUtils.disposeObject(this._defenceLbl);
            this._defenceLbl = null;
         }
         if(this._attackTxt)
         {
            ObjectUtils.disposeObject(this._attackTxt);
            this._attackTxt = null;
         }
         if(this._attackLbl)
         {
            ObjectUtils.disposeObject(this._attackLbl);
            this._attackLbl = null;
         }
         if(this._name)
         {
            ObjectUtils.disposeObject(this._name);
            this._name = null;
         }
         super.dispose();
      }
   }
}
