package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import pet.date.PetInfo;
   import petsBag.view.PetHappyBar;
   
   public class PetHappyTip extends BaseTip
   {
       
      
      private var _happyValueLbl:FilterFrameText;
      
      private var _happyValueTxt:FilterFrameText;
      
      private var _happyHeartLbl:FilterFrameText;
      
      private var _happyHeartTxt:FilterFrameText;
      
      private var _happyDesc:FilterFrameText;
      
      private var _splitImg:ScaleBitmapImage;
      
      protected var _bg:ScaleBitmapImage;
      
      private var _container:Sprite;
      
      private var _info:PetInfo;
      
      private var LEADING:int = 5;
      
      public function PetHappyTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initView();
      }
      
      private function initView() : void
      {
         this._happyValueLbl = ComponentFactory.Instance.creatComponentByStylename("petsBag.petHappyTip.happyValueLbl");
         this._happyValueLbl.text = LanguageMgr.GetTranslation("ddt.pets.petHapyyStatus");
         this._happyValueTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.petHappyTip.happyValueTxt");
         this._happyHeartLbl = ComponentFactory.Instance.creatComponentByStylename("petsBag.petHappyTip.happyHeartLbl");
         this._happyHeartLbl.text = LanguageMgr.GetTranslation("ddt.pets.petHapyyheart");
         this._happyHeartTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.petHappyTip.happyHeartTxt");
         this._happyDesc = ComponentFactory.Instance.creatComponentByStylename("petsBag.petHappyTip.happyDesc");
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._splitImg = ComponentFactory.Instance.creatComponentByStylename("petTips.line");
         this._container = new Sprite();
         this._container.addChild(this._happyValueLbl);
         this._container.addChild(this._happyValueTxt);
         this._container.addChild(this._happyHeartLbl);
         this._container.addChild(this._happyHeartTxt);
         this._container.addChild(this._happyDesc);
         this._container.addChild(this._splitImg);
         super.init();
         this.tipbackgound = this._bg;
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
      
      override public function set tipData(param1:Object) : void
      {
         this._info = param1 as PetInfo;
         this.updateView();
      }
      
      override public function get tipData() : Object
      {
         return this._info;
      }
      
      private function updateView() : void
      {
         this._happyValueTxt.text = this.happyPercent().toPrecision(3) + "%";
         this._happyHeartTxt.text = this.getPetStatusArray()[this._info.PetHappyStar];
         this._happyDesc.text = this._info.PetHappyStar > 0 ? LanguageMgr.GetTranslation("ddt.pets.petHappyDesc",PetHappyBar.petPercentArray[this._info.PetHappyStar]) : LanguageMgr.GetTranslation("ddt.pets.petUnFight");
         this.fixPos();
         this._bg.width = this._container.width + 10;
         this._bg.height = this._container.height + 20;
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      private function fixPos() : void
      {
         this._happyValueTxt.x = this._happyValueLbl.x + this._happyValueLbl.textWidth + this.LEADING;
         this._happyValueTxt.y = this._happyValueLbl.y;
         this._happyHeartLbl.x = this._happyValueLbl.x;
         this._happyHeartLbl.y = this._happyValueLbl.y + this._happyValueLbl.textHeight + this.LEADING;
         this._happyHeartTxt.x = this._happyHeartLbl.x + this._happyHeartLbl.textWidth + this.LEADING;
         this._happyHeartTxt.y = this._happyHeartLbl.y;
         this._splitImg.y = this._happyHeartLbl.y + this._happyHeartLbl.textHeight + this.LEADING * 2;
         this._happyDesc.y = this._splitImg.y + this._splitImg.height + this.LEADING * 2;
         this._happyDesc.x = this._happyValueLbl.x;
      }
      
      private function getPetStatusArray() : Array
      {
         return LanguageMgr.GetTranslation("ddt.petsBag.petStatus").split("||");
      }
      
      private function happyPercent() : Number
      {
         var _loc1_:Number = 0;
         if(this._info)
         {
            _loc1_ = this._info.Hunger / PetHappyBar.fullHappyValue * 100;
         }
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         this._info = null;
         if(this._happyValueLbl)
         {
            ObjectUtils.disposeObject(this._happyValueLbl);
            this._happyValueLbl = null;
         }
         if(this._happyValueTxt)
         {
            ObjectUtils.disposeObject(this._happyValueTxt);
            this._happyValueTxt = null;
         }
         if(this._happyHeartLbl)
         {
            ObjectUtils.disposeObject(this._happyHeartLbl);
            this._happyHeartLbl = null;
         }
         if(this._happyHeartTxt)
         {
            ObjectUtils.disposeObject(this._happyHeartTxt);
            this._happyHeartTxt = null;
         }
         if(this._happyDesc)
         {
            ObjectUtils.disposeObject(this._happyDesc);
            this._happyDesc = null;
         }
         if(this._splitImg)
         {
            ObjectUtils.disposeObject(this._splitImg);
            this._splitImg = null;
         }
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(this._container)
         {
            ObjectUtils.disposeObject(this._container);
            this._container = null;
         }
         super.dispose();
      }
   }
}
