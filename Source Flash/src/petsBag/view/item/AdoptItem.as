package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.ItemManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.BaseLayer;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import pet.date.PetInfo;
   import petsBag.event.PetItemEvent;
   
   public class AdoptItem extends Component
   {
      
      public static const ADOPT_PET_ITEM_WIDTH:int = 64;
       
      
      protected var _bg:DisplayObject;
      
      protected var _info:PetInfo;
      
      protected var _petMovieItem:PetBigItem;
      
      protected var _icon:Bitmap;
      
      protected var _isSelect:Boolean = false;
      
      protected var _shiner:DisplayObject;
      
      protected var _star:StarBar;
      
      protected var _goodBitmap:DisplayObject;
      
      protected var _goodTemplateId:int;
      
      private var _isGoodItem:Boolean = false;
      
      private var _goodItem:ItemTemplateInfo;
      
      private var _itemPlace:int = -1;
      
      private var _itemAmount:int = 0;
      
      private var _amountTxt:FilterFrameText;
      
      public function AdoptItem(param1:PetInfo)
      {
         super();
         this._info = param1;
         this.initView();
         this.initEvent();
         if(this._info)
         {
            this.tipData = this._info;
         }
         tipDirctions = "6,7,4,5";
      }
      
      public function get info() : PetInfo
      {
         return this._info;
      }
      
      public function set info(param1:PetInfo) : void
      {
         this._info = param1;
         if(this._info)
         {
            this.tipData = this._info;
         }
      }
      
      public function set place(param1:int) : void
      {
         this._itemPlace = param1;
      }
      
      public function get place() : int
      {
         return this._itemPlace;
      }
      
      public function set itemAmount(param1:int) : void
      {
         this._itemAmount = param1;
      }
      
      public function set itemTemplateId(param1:int) : void
      {
         if(param1 == this._goodTemplateId)
         {
            return;
         }
         this._goodTemplateId = param1;
         this._goodItem = ItemManager.Instance.getTemplateById(this._goodTemplateId);
         this._isGoodItem = true;
         this.refreshView();
      }
      
      public function get isGoodItem() : Boolean
      {
         return this._isGoodItem;
      }
      
      public function get itemInfo() : ItemTemplateInfo
      {
         return this._goodItem;
      }
      
      private function refreshView() : void
      {
         ObjectUtils.disposeObject(this._bg);
         ObjectUtils.disposeObject(this._shiner);
         ObjectUtils.disposeObject(this._petMovieItem);
         ObjectUtils.disposeObject(this._star);
         this._bg = ComponentFactory.Instance.creatBitmap("assets.farm.petPnlBg");
         addChild(this._bg);
         this._shiner = ComponentFactory.Instance.creat("assets.farm.petPnlBg2");
         addChild(this._shiner);
         this._shiner.visible = this._isSelect;
         var _loc1_:String = PathManager.solveGoodsPath(this._goodItem.CategoryID,this._goodItem.Pic,PlayerManager.Instance.Self.Sex,BaseLayer.ICON);
         var _loc2_:Rectangle = ComponentFactory.Instance.creatCustomObject("farm.adoptItem.goodBitmapSize");
         this._goodBitmap = new BitmapLoaderProxy(_loc1_,_loc2_);
         PositionUtils.setPos(this._goodBitmap,"assets.farm.itemPos");
         addChild(this._goodBitmap);
         this._amountTxt = ComponentFactory.Instance.creatComponentByStylename("farm.adoptItemTxt");
         this._amountTxt.text = this._itemAmount.toString();
         addChild(this._amountTxt);
         var _loc3_:GoodTipInfo = new GoodTipInfo();
         _loc3_.itemInfo = this._goodItem;
         this.tipData = _loc3_;
      }
      
      protected function initView() : void
      {
         this.buttonMode = true;
         if(this._info && this._info.StarLevel == 4)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("assets.farm.unSelectpetPnlBgFourStar");
            addChild(this._bg);
            this._shiner = ComponentFactory.Instance.creat("assets.farm.SelectpetPnlBgFourStar");
            addChild(this._shiner);
         }
         else
         {
            this._bg = ComponentFactory.Instance.creatBitmap("assets.farm.petPnlBg");
            addChild(this._bg);
            this._shiner = ComponentFactory.Instance.creat("assets.farm.petPnlBg2");
            addChild(this._shiner);
         }
         this._shiner.visible = this._isSelect;
         if(this._info)
         {
            this._petMovieItem = ComponentFactory.Instance.creat("petsBag.petMovieItem");
            this._petMovieItem.info = this._info;
            addChild(this._petMovieItem);
            this._star = ComponentFactory.Instance.creat("farm.starBar.petStar");
            addChild(this._star);
            this._star.starNum(this._info.StarLevel,"assets.farm.star");
         }
      }
      
      protected function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__selectPet);
      }
      
      protected function __selectPet(param1:MouseEvent) : void
      {
         dispatchEvent(new PetItemEvent(PetItemEvent.ITEM_CLICK,this,true));
         this.isSelect = true;
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__selectPet);
      }
      
      override public function get tipStyle() : String
      {
         if(this._isGoodItem)
         {
            return "ddt.view.tips.GoodTip";
         }
         return "petsBag.view.item.PetTip";
      }
      
      public function set isSelect(param1:Boolean) : void
      {
         this._isSelect = param1;
         this._shiner.visible = this._isSelect;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._shiner)
         {
            ObjectUtils.disposeObject(this._shiner);
            this._shiner = null;
         }
         if(this._star)
         {
            ObjectUtils.disposeObject(this._star);
            this._star = null;
         }
         if(this._icon)
         {
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
         }
         if(this._petMovieItem)
         {
            ObjectUtils.disposeObject(this._petMovieItem);
            this._petMovieItem = null;
         }
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         this._info = null;
         if(this._goodBitmap && this._goodBitmap.parent)
         {
            this._goodBitmap.parent.removeChild(this._goodBitmap);
         }
         this._goodBitmap = null;
         ObjectUtils.disposeObject(this._amountTxt);
         this._amountTxt = null;
         super.dispose();
      }
   }
}
