package farm.viewx.shop
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import petsBag.controller.PetBagController;
   import trainer.data.ArrowType;
   
   public class FarmShopView extends Frame
   {
      
      public static const SEEDTYPE:int = 0;
      
      public static const PETEGGTYPE:int = 1;
      
      public static var CURRENT_PAGE:int = 1;
      
      public static const SHOP_ITEM_NUM:uint = 10;
       
      
      private var _goodItems:Vector.<FarmShopItem>;
      
      private var _currentType:int = 88;
      
      private var _seedBtn:SelectedButton;
      
      private var _petEggBtn:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _firstPage:BaseButton;
      
      private var _prePageBtn:BaseButton;
      
      private var _nextPageBtn:BaseButton;
      
      private var _endPageBtn:BaseButton;
      
      private var _currentPageTxt:FilterFrameText;
      
      private var _goodItemContainerAll:SimpleTileList;
      
      private var _titleShop:DisplayObject;
      
      private var _pageInputBg:DisplayObject;
      
      public function FarmShopView()
      {
         super();
         this._goodItems = new Vector.<FarmShopItem>();
         this.initView();
         this.initEvent();
         escEnable = true;
      }
      
      private function initView() : void
      {
         this._titleShop = ComponentFactory.Instance.creat("assets.farmShop.title");
         addToContent(this._titleShop);
         this._pageInputBg = ComponentFactory.Instance.creat("farm.farmShopView.fontBG");
         addToContent(this._pageInputBg);
         this._seedBtn = ComponentFactory.Instance.creatComponentByStylename("farmShop.button.seed");
         addToContent(this._seedBtn);
         this._firstPage = ComponentFactory.Instance.creat("farmshop.btnFirstPage");
         addToContent(this._firstPage);
         this._prePageBtn = ComponentFactory.Instance.creat("farmshop.btnPrePage");
         addToContent(this._prePageBtn);
         this._nextPageBtn = ComponentFactory.Instance.creat("farmshop.btnNextPage");
         addToContent(this._nextPageBtn);
         this._endPageBtn = ComponentFactory.Instance.creat("farmshop.btnEndPage");
         addToContent(this._endPageBtn);
         this._currentPageTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.shopCurrent");
         addToContent(this._currentPageTxt);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._seedBtn);
         if(ServerConfigManager.instance.petScoreEnable)
         {
            this._petEggBtn = ComponentFactory.Instance.creatComponentByStylename("farmShop.button.petEgg");
            addToContent(this._petEggBtn);
            this._btnGroup.addSelectItem(this._petEggBtn);
         }
         this._btnGroup.selectIndex = 0;
         this._goodItemContainerAll = ComponentFactory.Instance.creat("farm.simpleTileList.farmShop",[5]);
         addToContent(this._goodItemContainerAll);
         var _loc1_:int = 0;
         while(_loc1_ < SHOP_ITEM_NUM)
         {
            this._goodItems[_loc1_] = ComponentFactory.Instance.creatCustomObject("farmShop.farmShopItem");
            this._goodItemContainerAll.addChild(this._goodItems[_loc1_]);
            this._goodItems[_loc1_].addEventListener(ItemEvent.ITEM_CLICK,this.__itemClick);
            _loc1_++;
         }
         if(PetBagController.instance().petModel.IsFinishTask5)
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.OPEN_FARM_SHOP);
            PetBagController.instance().petModel.IsFinishTask5 = false;
         }
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._firstPage.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
      }
      
      private function removeEvent() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._firstPage.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
      }
      
      private function __itemClick(param1:ItemEvent) : void
      {
         var _loc2_:FarmShopItem = param1.currentTarget as FarmShopItem;
      }
      
      private function __changeHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         switch(this._btnGroup.selectIndex)
         {
            case SEEDTYPE:
               this._currentType = ShopType.FARM_SEED_TYPE;
               break;
            case PETEGGTYPE:
               this._currentType = ShopType.FARM_PETEGG_TYPE;
         }
         CURRENT_PAGE = 1;
         this.loadList();
      }
      
      private function __pageBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._firstPage:
               if(CURRENT_PAGE != 1)
               {
                  CURRENT_PAGE = 1;
               }
               break;
            case this._prePageBtn:
               if(CURRENT_PAGE == 1)
               {
                  CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType(),10) + 1;
               }
               --CURRENT_PAGE;
               break;
            case this._nextPageBtn:
               if(CURRENT_PAGE == ShopManager.Instance.getResultPages(this.getType(),10))
               {
                  CURRENT_PAGE = 0;
               }
               ++CURRENT_PAGE;
               break;
            case this._endPageBtn:
               if(CURRENT_PAGE != ShopManager.Instance.getResultPages(this.getType(),10))
               {
                  CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType(),10);
               }
         }
         this.loadList();
      }
      
      public function loadList() : void
      {
         this.setList(ShopManager.Instance.getValidSortedGoodsByType(this.getType(),CURRENT_PAGE,10));
      }
      
      public function setList(param1:Vector.<ShopItemInfo>) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < SHOP_ITEM_NUM)
         {
            if(_loc2_ < param1.length && param1[_loc2_])
            {
               this._goodItems[_loc2_].shopItemInfo = param1[_loc2_];
            }
            else
            {
               this._goodItems[_loc2_].shopItemInfo = null;
            }
            this._goodItems[_loc2_].shopType = this.getType();
            _loc2_++;
         }
         this._currentPageTxt.text = CURRENT_PAGE + "/" + ShopManager.Instance.getResultPages(this.getType(),10);
      }
      
      private function getType() : int
      {
         return int(this._currentType);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.loadList();
      }
      
      override public function dispose() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < SHOP_ITEM_NUM)
         {
            this._goodItems[_loc1_].removeEventListener(ItemEvent.ITEM_CLICK,this.__itemClick);
            this._goodItems[_loc1_].dispose();
            this._goodItems[_loc1_] = null;
            _loc1_++;
         }
         this._goodItems.splice(0,this._goodItems.length);
         if(this._goodItemContainerAll)
         {
            ObjectUtils.disposeObject(this._goodItemContainerAll);
            this._goodItemContainerAll = null;
         }
         if(this._endPageBtn)
         {
            ObjectUtils.disposeObject(this._endPageBtn);
            this._endPageBtn = null;
         }
         if(this._currentPageTxt)
         {
            ObjectUtils.disposeObject(this._currentPageTxt);
            this._currentPageTxt = null;
         }
         if(this._nextPageBtn)
         {
            ObjectUtils.disposeObject(this._nextPageBtn);
            this._nextPageBtn = null;
         }
         if(this._prePageBtn)
         {
            ObjectUtils.disposeObject(this._prePageBtn);
            this._prePageBtn = null;
         }
         if(this._firstPage)
         {
            ObjectUtils.disposeObject(this._firstPage);
            this._firstPage = null;
         }
         if(this._btnGroup)
         {
            ObjectUtils.disposeObject(this._btnGroup);
            this._btnGroup = null;
         }
         if(this._seedBtn)
         {
            ObjectUtils.disposeObject(this._seedBtn);
            this._seedBtn = null;
         }
         if(this._petEggBtn)
         {
            ObjectUtils.disposeObject(this._petEggBtn);
            this._petEggBtn = null;
         }
         if(this._titleShop)
         {
            ObjectUtils.disposeObject(this._titleShop);
            this._titleShop = null;
         }
         if(this._pageInputBg)
         {
            ObjectUtils.disposeObject(this._pageInputBg);
            this._pageInputBg = null;
         }
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
