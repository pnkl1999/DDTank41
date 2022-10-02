package labyrinth.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class LabyrinthShopFrame extends BaseAlerFrame
   {
      
      public static const SHOP_ITEM_NUM:uint = 8;
      
      public static var CURRENT_MONEY_TYPE:int = 1;
      
      public static var CURRENT_PAGE:int = 1;
       
      
      private var _goodItems:Vector.<LabyrinthShopItem>;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _rightItemLightMc:MovieClip;
      
      protected var _goodItemContainerBg:Image;
      
      private var _firstPage:BaseButton;
      
      private var _prePageBtn:BaseButton;
      
      private var _nextPageBtn:BaseButton;
      
      private var _endPageBtn:BaseButton;
      
      private var _currentPageTxt:FilterFrameText;
      
      private var _currentPageInput:Bitmap;
      
      private var _navigationBarContainer:Sprite;
      
      private var _coinNumBG:Bitmap;
      
      private var _coinText:FilterFrameText;
      
      private var _coinNumText:FilterFrameText;
      
      private var _lable:FilterFrameText;
      
      private var _bg:Bitmap;
      
      public function LabyrinthShopFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc2_:String = null;
         var _loc6_:int = 0;
         var _loc1_:String = null;
         _loc2_ = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         super.init();
         this._bg = ComponentFactory.Instance.creatBitmap("ddt.labyrinth.shopBG");
         addToContent(this._bg);
         _loc1_ = LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthShopFrame.title");
         _loc2_ = LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthShopFrame.text2");
         _loc3_ = LanguageMgr.GetTranslation("dt.labyrinth.LabyrinthShopFrame.text1");
         _loc4_ = PlayerManager.Instance.Self.hardCurrency.toString();
         var _loc5_:AlertInfo = new AlertInfo(_loc1_,"",LanguageMgr.GetTranslation("tank.calendar.Activity.BackButtonText"),false);
         info = _loc5_;
         this._goodItems = new Vector.<LabyrinthShopItem>();
         this._rightItemLightMc = ComponentFactory.Instance.creatCustomObject("labyrinth.LabyrinthShopFrame.RightItemLightMc");
         this._goodItemContainerAll = ComponentFactory.Instance.creatCustomObject("labyrinth.LabyrinthShopFrame.GoodItemContainerAll");
         this._goodItemContainerBg = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthShopFrame.GoodItemContainerBg");
         this._navigationBarContainer = ComponentFactory.Instance.creatCustomObject("labyrinth.LabyrinthShopFrame.navigationBarContainer");
         this._currentPageInput = UICreatShortcut.creatAndAdd("ddt.labyrinth.fenyeBG",this._navigationBarContainer);
         this._prePageBtn = UICreatShortcut.creatAndAdd("shop.BtnPrePage",this._navigationBarContainer);
         this._nextPageBtn = UICreatShortcut.creatAndAdd("shop.BtnNextPage",this._navigationBarContainer);
         this._currentPageTxt = UICreatShortcut.creatAndAdd("shop.CurrentPage",this._navigationBarContainer);
         this._coinNumBG = ComponentFactory.Instance.creatBitmap("ddt.labyrinth.jinbiBG");
         this._coinText = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthShopFrame.coinText");
         this._coinText.text = _loc3_;
         this._coinNumText = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthShopFrame.coinNumText");
         this._coinNumText.text = _loc4_;
         this._lable = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthShopFrame.lable");
         this._lable.text = _loc2_;
         addToContent(this._goodItemContainerBg);
         addToContent(this._goodItemContainerAll);
         addToContent(this._navigationBarContainer);
         addToContent(this._coinNumBG);
         addToContent(this._coinText);
         addToContent(this._coinNumText);
         addToContent(this._lable);
         _loc6_ = 0;
         while(_loc6_ < SHOP_ITEM_NUM)
         {
            this._goodItems[_loc6_] = ComponentFactory.Instance.creatCustomObject("labyrinth.view.labyrinthShopItem");
            _loc7_ = this._goodItems[_loc6_].width;
            _loc8_ = this._goodItems[_loc6_].height;
            _loc7_ *= int(_loc6_ % 2);
            _loc8_ *= int(_loc6_ / 2);
            if((_loc6_ + 1) % 2 == 0)
            {
               this._goodItems[_loc6_].x = _loc7_ - 5;
            }
            else
            {
               this._goodItems[_loc6_].x = _loc7_;
            }
            this._goodItems[_loc6_].y = _loc8_ + _loc6_ / 2 * 2;
            this._goodItemContainerAll.addChild(this._goodItems[_loc6_]);
            this._goodItems[_loc6_].setItemLight(this._rightItemLightMc);
            _loc6_++;
         }
         this.loadList();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onUpdate);
      }
      
      public function removeEvent() : void
      {
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onUpdate);
      }
      
      protected function __onUpdate(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["hardCurrency"] == true)
         {
            this._coinNumText.text = PlayerManager.Instance.Self.hardCurrency.toString();
         }
      }
      
      private function clearitems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < SHOP_ITEM_NUM)
         {
            this._goodItems[_loc1_].shopItemInfo = null;
            _loc1_++;
         }
      }
      
      public function loadList() : void
      {
         this.setList(ShopManager.Instance.getValidSortedGoodsByType(this.getType(),CURRENT_PAGE));
      }
      
      public function setList(param1:Vector.<ShopItemInfo>) : void
      {
         this.clearitems();
         var _loc2_:int = 0;
         while(_loc2_ < SHOP_ITEM_NUM)
         {
            this._goodItems[_loc2_].selected = false;
            if(!param1)
            {
               break;
            }
            if(_loc2_ < param1.length && param1[_loc2_])
            {
               this._goodItems[_loc2_].shopItemInfo = param1[_loc2_];
            }
            _loc2_++;
         }
         this._currentPageTxt.text = CURRENT_PAGE + "/" + ShopManager.Instance.getResultPages(this.getType());
      }
      
      private function __pageBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ShopManager.Instance.getResultPages(this.getType()) == 0)
         {
            return;
         }
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
                  CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType()) + 1;
               }
               --CURRENT_PAGE;
               break;
            case this._nextPageBtn:
               if(CURRENT_PAGE == ShopManager.Instance.getResultPages(this.getType()))
               {
                  CURRENT_PAGE = 0;
               }
               ++CURRENT_PAGE;
               break;
            case this._endPageBtn:
               if(CURRENT_PAGE != ShopManager.Instance.getResultPages(this.getType()))
               {
                  CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType());
               }
         }
         this.loadList();
      }
      
      public function getType() : int
      {
         return 94;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function disposeItems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._goodItems.length)
         {
            ObjectUtils.disposeObject(this._goodItems[_loc1_]);
            this._goodItems[_loc1_] = null;
            _loc1_++;
         }
         this._goodItems = null;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.disposeItems();
         ObjectUtils.disposeObject(this._goodItemContainerAll);
         this._goodItemContainerAll = null;
         ObjectUtils.disposeObject(this._rightItemLightMc);
         this._rightItemLightMc = null;
         ObjectUtils.disposeObject(this._goodItemContainerBg);
         this._goodItemContainerBg = null;
         ObjectUtils.disposeObject(this._firstPage);
         this._firstPage = null;
         ObjectUtils.disposeObject(this._prePageBtn);
         this._prePageBtn = null;
         ObjectUtils.disposeObject(this._nextPageBtn);
         this._nextPageBtn = null;
         ObjectUtils.disposeObject(this._endPageBtn);
         this._endPageBtn = null;
         ObjectUtils.disposeObject(this._currentPageTxt);
         this._currentPageTxt = null;
         ObjectUtils.disposeObject(this._currentPageInput);
         this._currentPageInput = null;
         ObjectUtils.disposeObject(this._navigationBarContainer);
         this._navigationBarContainer = null;
         ObjectUtils.disposeObject(this._coinNumBG);
         this._coinNumBG = null;
         ObjectUtils.disposeObject(this._coinText);
         this._coinText = null;
         ObjectUtils.disposeObject(this._coinNumText);
         this._coinNumText = null;
         ObjectUtils.disposeObject(this._lable);
         this._lable = null;
         super.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
