package shop.view
{
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.TweenProxy;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SelectedIconButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import shop.ShopController;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class ShopRightView extends Sprite implements Disposeable
   {
      
      public static const SUB_GIFT:uint = 0;
      
      public static const SUB_MEDAL:uint = 1;
      
      public static const SUB_RECOMMEND:uint = 0;
      
      public static const TOP_RECOMMEND:uint = 0;
      
      public static const TOP_WEAPON:uint = 1;
      
      public static const TOP_CLOTH:uint = 2;
      
      public static const TOP_BEAUTYUP:uint = 3;
      
      public static const TOP_PROP:uint = 4;
      
      public static const TOP_GIFT:uint = 5;
      
      public static const TOP_MEDAL:uint = 6;
      
      public static const TOP_FREE:uint = 7;
      
      public static const SHOP_ITEM_NUM:uint = 8;
      
      public static var CURRENT_GENDER:int = -1;
      
      public static var CURRENT_PAGE:int = 1;
      
      public static var SUB_TYPE:int = 2;
      
      public static var TOP_TYPE:int = 0;
      
      private static var EXCHANGE_TYPE:int = -1;
       
      
      private var _bg:Bitmap;
      
      private var _bg1:Bitmap;
      
      private var _controller:ShopController;
      
      private var _currentPageTxt:FilterFrameText;
      
      private var _femaleBtn:SelectedButton;
      
      private var _genderContainer:HBox;
      
      private var _genderGroup:SelectedButtonGroup;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _goodItemGroup:SelectedButtonGroup;
      
      private var _goodItems:Vector.<ShopGoodItem>;
      
      private var _maleBtn:SelectedButton;
      
      private var _firstPage:BaseButton;
      
      private var _prePageBtn:BaseButton;
      
      private var _nextPageBtn:BaseButton;
      
      private var _endPageBtn:BaseButton;
      
      private var _subBtns:Vector.<SelectedIconButton>;
      
      private var _subBtnsContainers:Vector.<HBox>;
      
      private var _subBtnsGroups:Vector.<SelectedButtonGroup>;
      
      private var _topBtns:Vector.<SelectedButton>;
      
      private var _topBtnsContainer:HBox;
      
      private var _topBtnsGroup:SelectedButtonGroup;
      
      private var _shopExchangeBox:Sprite;
      
      private var _shopExchangeBoxBg:Bitmap;
      
      private var _shopExchangeGroup:SelectedButtonGroup;
      
      private var _shopExchangeMedalBtn:SelectedCheckButton;
      
      private var _shopExchangeGiftBtn:SelectedCheckButton;
      
      private var _shopSearchBox:Sprite;
      
      private var _shopSearchEndBtnBg:Bitmap;
      
      private var _shopSearchColseBtn:BaseButton;
      
      private var _rightItemLightMc:MovieClip;
      
      private var _tempTopType:int = -1;
      
      private var _tempCurrentPage:int = -1;
      
      private var _tempSubBtnHBox:HBox;
      
      private var _isSearch:Boolean;
      
      private var _searchShopItemList:Vector.<ShopItemInfo>;
      
      private var _searchItemTotalPage:int;
      
      private var _giftShine:MovieClip;
      
      private var _giftTip:MovieClip;
      
      public function ShopRightView()
      {
         super();
      }
      
      public function get genderGroup() : SelectedButtonGroup
      {
         return this._genderGroup;
      }
      
      public function setup(param1:ShopController) : void
      {
         this._controller = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.shop.RightViewBg");
         addChild(this._bg);
         this._bg1 = ComponentFactory.Instance.creat("asset.shop.RightViewBg1");
         this._bg1.x = 196;
         this._bg1.y = 490;
         addChild(this._bg1);
         this.initBtns();
         this.initEvent();
         if(CURRENT_GENDER < 0)
         {
            this.setCurrentSex(!!PlayerManager.Instance.Self.Sex ? int(int(1)) : int(int(2)));
         }
      }
      
      private function initBtns() : void
      {
         var _loc2_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc1_:uint = 0;
         _loc2_ = 0;
         this._topBtns = new Vector.<SelectedButton>();
         this._topBtnsGroup = new SelectedButtonGroup();
         this._subBtns = new Vector.<SelectedIconButton>();
         this._subBtnsContainers = new Vector.<HBox>();
         this._subBtnsGroups = new Vector.<SelectedButtonGroup>();
         this._genderGroup = new SelectedButtonGroup();
         this._goodItems = new Vector.<ShopGoodItem>();
         this._goodItemGroup = new SelectedButtonGroup();
         this._firstPage = ComponentFactory.Instance.creat("shop.BtnFirstPage");
         this._prePageBtn = ComponentFactory.Instance.creat("shop.BtnPrePage");
         this._nextPageBtn = ComponentFactory.Instance.creat("shop.BtnNextPage");
         this._endPageBtn = ComponentFactory.Instance.creat("shop.BtnEndPage");
         this._currentPageTxt = ComponentFactory.Instance.creatComponentByStylename("shop.CurrentPage");
         this._topBtnsContainer = ComponentFactory.Instance.creat("shop.TopBtnContainer");
         this._topBtns.push(ComponentFactory.Instance.creat("shop.TopBtnRecommend"));
         this._topBtns.push(ComponentFactory.Instance.creat("shop.TopBtnEquipment"));
         this._topBtns.push(ComponentFactory.Instance.creat("shop.TopBtnBeautyup"));
         this._topBtns.push(ComponentFactory.Instance.creat("shop.TopBtnProp"));
         this._topBtns.push(ComponentFactory.Instance.creat("shop.TopBtnExchange"));
         this._topBtns.push(ComponentFactory.Instance.creat("shop.TopBtnFree"));
         this._genderContainer = ComponentFactory.Instance.creat("shop.GenderBtnContainer");
         this._maleBtn = ComponentFactory.Instance.creat("shop.GenderBtnMale");
         this._femaleBtn = ComponentFactory.Instance.creat("shop.GenderBtnFemale");
         this._rightItemLightMc = ComponentFactory.Instance.creatCustomObject("shop.RightItemLightMc");
         this._goodItemContainerAll = new Sprite();
         this._goodItemContainerAll.x = 23;
         this._goodItemContainerAll.y = 104;
         _loc2_ = 0;
         while(_loc2_ < SHOP_ITEM_NUM)
         {
            this._goodItems[_loc2_] = ComponentFactory.Instance.creatCustomObject("shop.GoodItem");
            _loc4_ = this._goodItems[_loc2_].width;
            _loc5_ = this._goodItems[_loc2_].height;
            _loc4_ *= int(_loc2_ % 2);
            _loc5_ *= int(_loc2_ / 2);
            this._goodItems[_loc2_].x = _loc4_;
            this._goodItems[_loc2_].y = _loc5_;
            this._goodItemContainerAll.addChild(this._goodItems[_loc2_]);
            this._goodItems[_loc2_].setItemLight(this._rightItemLightMc);
            this._goodItems[_loc2_].addEventListener(ItemEvent.ITEM_CLICK,this.__itemClick);
            this._goodItems[_loc2_].addEventListener(ItemEvent.ITEM_SELECT,this.__itemSelect);
            _loc2_++;
         }
         this._femaleBtn.displacement = false;
         this._maleBtn.displacement = false;
         this._genderContainer.addChild(this._maleBtn);
         this._genderContainer.addChild(this._femaleBtn);
         this._genderGroup.addSelectItem(this._maleBtn);
         this._genderGroup.addSelectItem(this._femaleBtn);
         _loc2_ = 0;
         while(_loc2_ < this._topBtns.length)
         {
            this._topBtns[_loc2_].addEventListener(MouseEvent.CLICK,this.__topBtnClick);
            this._topBtnsContainer.addChild(this._topBtns[_loc2_]);
            this._topBtnsGroup.addSelectItem(this._topBtns[_loc2_]);
            if(_loc2_ == 0)
            {
               this._topBtnsGroup.selectIndex = _loc2_;
            }
            this._subBtnsGroups[_loc2_] = new SelectedButtonGroup();
            _loc2_++;
         }
         this._subBtnsContainers.push(ComponentFactory.Instance.creat("shop.SubBtnContainerRecommnend"));
         this._subBtnsContainers.push(ComponentFactory.Instance.creat("shop.SubBtnContainerEquipment"));
         this._subBtnsContainers.push(ComponentFactory.Instance.creat("shop.SubBtnContainerBeautyup"));
         this._subBtnsContainers.push(ComponentFactory.Instance.creat("shop.SubBtnContainerProp"));
         this._subBtnsContainers.push(ComponentFactory.Instance.creat("shop.SubBtnContainerExchange"));
         this._subBtnsContainers.push(ComponentFactory.Instance.creat("shop.SubBtnContainerProp"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnHotSaleIcon"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnRecommend"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnDiscount"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnGiftMedalWeapon"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnCloth"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnHat"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnGlasses"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnRing"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnHair"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnEye"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnFace"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnSuit"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnWing"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnFunc"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnSpecial"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnGiftMedalAll"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnGiftMedalWeapon"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnGiftMedalCloth"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnGiftMedalBeautyup"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnGiftMedalProp"));
         this._subBtns.push(ComponentFactory.Instance.creat("shop.SubBtnFreeNyc"));
         var _loc3_:Array = [3,8,13,15,20,21];
         _loc1_ = 0;
         _loc2_ = 0;
         while(_loc2_ < this._subBtns.length)
         {
            if(_loc2_ == _loc3_[_loc1_])
            {
               _loc1_++;
            }
            if(this._subBtnsContainers[_loc1_] == null)
            {
               _loc1_++;
            }
            this._subBtns[_loc2_].addEventListener(MouseEvent.CLICK,this.__subBtnClick);
            this._subBtnsContainers[_loc1_].addChild(this._subBtns[_loc2_]);
            this._subBtnsGroups[_loc1_].addSelectItem(this._subBtns[_loc2_]);
            if(_loc2_ == 0)
            {
               this._subBtnsGroups[_loc1_].selectIndex = _loc2_;
            }
            _loc2_++;
         }
         addChild(this._firstPage);
         addChild(this._prePageBtn);
         addChild(this._nextPageBtn);
         addChild(this._endPageBtn);
         addChild(this._currentPageTxt);
         addChild(this._topBtnsContainer);
         addChild(this._genderContainer);
         addChild(this._goodItemContainerAll);
         _loc2_ = 0;
         while(_loc2_ < this._subBtnsContainers.length)
         {
            if(this._subBtnsContainers[_loc2_])
            {
               addChild(this._subBtnsContainers[_loc2_]);
               this._subBtnsContainers[_loc2_].visible = false;
               if(_loc2_ == 0)
               {
                  this._subBtnsContainers[_loc2_].visible = true;
               }
            }
            _loc2_++;
         }
         this._shopExchangeBox = new Sprite();
         this._shopExchangeBox.x = 424;
         this._shopExchangeBox.y = 44;
         this._shopExchangeBoxBg = ComponentFactory.Instance.creatBitmap("asset.shop.ShopExchangeBoxBg");
         this._shopExchangeBox.addChild(this._shopExchangeBoxBg);
         this._shopExchangeGroup = new SelectedButtonGroup();
         this._shopExchangeGiftBtn = ComponentFactory.Instance.creatComponentByStylename("shop.ShopExchangeGiftBtn");
         this._shopExchangeGroup.addSelectItem(this._shopExchangeGiftBtn);
         this._shopExchangeBox.addChild(this._shopExchangeGiftBtn);
         this._shopExchangeMedalBtn = ComponentFactory.Instance.creatComponentByStylename("shop.ShopExchangeMedalBtn");
         this._shopExchangeGroup.addSelectItem(this._shopExchangeMedalBtn);
         this._shopExchangeBox.addChild(this._shopExchangeMedalBtn);
         this._shopExchangeGroup.selectIndex = 0;
         addChild(this._shopExchangeBox);
         this._shopExchangeBox.visible = false;
         this._shopSearchBox = new Sprite();
         this._shopSearchBox.x = 22;
         this._shopSearchBox.y = 52;
         this._shopSearchEndBtnBg = ComponentFactory.Instance.creatBitmap("asset.shop.ShopSearchEndBtn");
         this._shopSearchBox.addChild(this._shopSearchEndBtnBg);
         this._shopSearchColseBtn = ComponentFactory.Instance.creatComponentByStylename("shop.ShopSearchColseBtn");
         this._shopSearchColseBtn.x = 430;
         this._shopSearchColseBtn.y = -10;
         this._shopSearchBox.addChild(this._shopSearchColseBtn);
         addChild(this._shopSearchBox);
         this._shopSearchBox.visible = false;
      }
      
      private function initEvent() : void
      {
         this._maleBtn.addEventListener(MouseEvent.CLICK,this.__genderClick);
         this._femaleBtn.addEventListener(MouseEvent.CLICK,this.__genderClick);
         this._firstPage.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._endPageBtn.addEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._shopExchangeGiftBtn.addEventListener(MouseEvent.CLICK,this.__shopExchangeBtnClick);
         this._shopExchangeMedalBtn.addEventListener(MouseEvent.CLICK,this.__shopExchangeBtnClick);
         this._shopSearchColseBtn.addEventListener(MouseEvent.CLICK,this.__shopSearchColseBtnClick);
         addEventListener(Event.ADDED_TO_STAGE,this.__userGuide);
      }
      
      private function __userGuide(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__userGuide);
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_SHOP) && PlayerManager.Instance.Self.Grade >= 9)
         {
            NewHandContainer.Instance.showArrow(ArrowType.SHOP_GIFT,150,"trainer.shopGiftArrowPos","asset.trainer.txtShopGift","trainer.shopGiftTipPos");
         }
      }
      
      protected function __shopSearchColseBtnClick(param1:MouseEvent) : void
      {
         this._isSearch = false;
         this._shopSearchBox.visible = false;
         TOP_TYPE = this._tempTopType;
         this._tempTopType = -1;
         this._topBtnsGroup.selectIndex = TOP_TYPE;
         if(!this._tempSubBtnHBox)
         {
            this._tempSubBtnHBox = this._subBtnsContainers[0];
         }
         this._tempSubBtnHBox.visible = true;
         CURRENT_PAGE = this._tempCurrentPage;
         this._tempCurrentPage = -1;
         if(TOP_TYPE == 4)
         {
            this._shopExchangeBox.visible = true;
         }
         this.loadList();
         SoundManager.instance.play("008");
      }
      
      public function loadList() : void
      {
         if(this._isSearch)
         {
            return;
         }
         this.setList(ShopManager.Instance.getValidSortedGoodsByType(this.getType(),CURRENT_PAGE));
      }
      
      private function getType() : int
      {
         var _loc1_:Array = CURRENT_GENDER == 1 ? ShopType.MALE_TYPE : ShopType.FEMALE_TYPE;
         var _loc2_:* = _loc1_[TOP_TYPE];
         if(_loc2_ is Array && SUB_TYPE > -1)
         {
            if(EXCHANGE_TYPE < 0)
            {
               _loc2_ = _loc2_[SUB_TYPE];
            }
            else
            {
               _loc2_ = _loc2_[EXCHANGE_TYPE][SUB_TYPE];
            }
         }
         return int(_loc2_);
      }
      
      public function setCurrentSex(param1:int) : void
      {
         CURRENT_GENDER = param1;
         this._genderGroup.selectIndex = CURRENT_GENDER - 1;
      }
      
      public function setList(param1:Vector.<ShopItemInfo>) : void
      {
         this.clearitems();
         var _loc2_:int = 0;
         while(_loc2_ < SHOP_ITEM_NUM)
         {
            this._goodItems[_loc2_].selected = false;
            if(_loc2_ < param1.length && param1[_loc2_])
            {
               this._goodItems[_loc2_].shopItemInfo = param1[_loc2_];
            }
            _loc2_++;
         }
         this._currentPageTxt.text = CURRENT_PAGE + "/" + ShopManager.Instance.getResultPages(this.getType());
      }
      
      public function searchList(param1:Vector.<ShopItemInfo>) : void
      {
         var _loc3_:HBox = null;
         if(this._searchShopItemList == param1 && this._isSearch)
         {
            return;
         }
         this._searchShopItemList = param1;
         if(!this._isSearch)
         {
            this._tempTopType = TOP_TYPE;
            this._tempCurrentPage = CURRENT_PAGE;
         }
         this._isSearch = true;
         TOP_TYPE = -1;
         this._topBtnsGroup.selectIndex = -1;
         CURRENT_PAGE = 1;
         var _loc2_:int = 0;
         while(_loc2_ < this._subBtnsContainers.length)
         {
            _loc3_ = this._subBtnsContainers[_loc2_] as HBox;
            if(_loc3_)
            {
               _loc3_.visible = false;
            }
            _loc2_++;
         }
         this._shopExchangeBox.visible = false;
         this._shopSearchBox.visible = true;
         this.runSearch();
      }
      
      private function runSearch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.clearitems();
         this._searchItemTotalPage = Math.ceil(this._searchShopItemList.length / 8);
         if(CURRENT_PAGE > 0 && CURRENT_PAGE <= this._searchItemTotalPage)
         {
            _loc1_ = 8 * (CURRENT_PAGE - 1);
            _loc2_ = Math.min(this._searchShopItemList.length - _loc1_,8);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this._goodItems[_loc3_].selected = false;
               if(this._searchShopItemList[_loc3_ + _loc1_])
               {
                  this._goodItems[_loc3_].shopItemInfo = this._searchShopItemList[_loc3_ + _loc1_];
               }
               _loc3_++;
            }
         }
         this._currentPageTxt.text = CURRENT_PAGE + "/" + this._searchItemTotalPage;
      }
      
      private function __genderClick(param1:MouseEvent) : void
      {
         var _loc2_:int = param1.currentTarget as SelectedButton == this._maleBtn ? int(int(1)) : int(int(2));
         if(CURRENT_GENDER == _loc2_)
         {
            return;
         }
         this.setCurrentSex(_loc2_);
         if(!this._isSearch)
         {
            CURRENT_PAGE = 1;
         }
         this._controller.setFittingModel(CURRENT_GENDER == 1);
         SoundManager.instance.play("008");
      }
      
      private function __itemSelect(param1:ItemEvent) : void
      {
         var _loc3_:ISelectable = null;
         param1.stopImmediatePropagation();
         var _loc2_:ShopGoodItem = param1.currentTarget as ShopGoodItem;
         for each(_loc3_ in this._goodItems)
         {
            _loc3_.selected = false;
         }
         _loc2_.selected = true;
      }
      
      private function __itemClick(param1:ItemEvent) : void
      {
         var _loc3_:ISelectable = null;
         var _loc4_:ISelectable = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:ShopCarItemInfo = null;
         var _loc2_:ShopGoodItem = param1.currentTarget as ShopGoodItem;
         if(this._controller.model.isOverCount(_loc2_.shopItemInfo))
         {
            for each(_loc3_ in this._goodItems)
            {
               _loc3_.selected = _loc3_ == _loc2_;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.GoodsNumberLimit"));
            return;
         }
         if(_loc2_.shopItemInfo && _loc2_.shopItemInfo.TemplateInfo)
         {
            for each(_loc4_ in this._goodItems)
            {
               _loc4_.selected = _loc4_ == _loc2_;
            }
            if(EquipType.dressAble(_loc2_.shopItemInfo.TemplateInfo))
            {
               _loc7_ = _loc2_.shopItemInfo.TemplateInfo.NeedSex != 2 ? int(int(0)) : int(int(1));
               if(_loc2_.shopItemInfo.TemplateInfo.NeedSex != 0 && this._genderGroup.selectIndex != _loc7_)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.sexAlert"));
                  return;
               }
               this._controller.addTempEquip(_loc2_.shopItemInfo);
            }
            else
            {
               _loc8_ = new ShopCarItemInfo(_loc2_.shopItemInfo.GoodsID,_loc2_.shopItemInfo.TemplateID);
               ObjectUtils.copyProperties(_loc8_,_loc2_.shopItemInfo);
               _loc5_ = this._controller.addToCar(_loc8_);
            }
            this.itemClick(_loc2_);
            _loc6_ = this._controller.leftView.getColorEditorVisble();
            if(_loc5_ && !_loc6_)
            {
               this.addCartEffects(_loc2_.itemCell);
            }
         }
      }
      
      private function addCartEffects(param1:DisplayObject) : void
      {
         var _loc4_:TweenProxy = null;
         var _loc5_:TimelineLite = null;
         var _loc6_:TweenLite = null;
         var _loc7_:TweenLite = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:BitmapData = new BitmapData(param1.width,param1.height,true,0);
         _loc2_.draw(param1);
         var _loc3_:Bitmap = new Bitmap(_loc2_,"auto",true);
         parent.addChild(_loc3_);
         _loc4_ = TweenProxy.create(_loc3_);
         _loc4_.registrationX = _loc4_.width / 2;
         _loc4_.registrationY = _loc4_.height / 2;
         var _loc8_:Point = DisplayUtils.localizePoint(parent,param1);
         _loc4_.x = _loc8_.x + _loc4_.width / 2;
         _loc4_.y = _loc8_.y + _loc4_.height / 2;
         _loc5_ = new TimelineLite();
         _loc5_.vars.onComplete = this.twComplete;
         _loc5_.vars.onCompleteParams = [_loc5_,_loc4_,_loc3_];
         _loc6_ = new TweenLite(_loc4_,0.3,{
            "x":220,
            "y":430
         });
         _loc7_ = new TweenLite(_loc4_,0.3,{
            "scaleX":0.1,
            "scaleY":0.1
         });
         _loc5_.append(_loc6_);
         _loc5_.append(_loc7_,-0.2);
      }
      
      private function twComplete(param1:TimelineLite, param2:TweenProxy, param3:Bitmap) : void
      {
         if(param1)
         {
            param1.kill();
         }
         if(param2)
         {
            param2.destroy();
         }
         if(param3.parent)
         {
            param3.parent.removeChild(param3);
            param3.bitmapData.dispose();
         }
         param2 = null;
         param3 = null;
         param1 = null;
      }
      
      private function itemClick(param1:ShopGoodItem) : void
      {
         if(param1.shopItemInfo.TemplateInfo != null)
         {
            if(CURRENT_GENDER != param1.shopItemInfo.TemplateInfo.NeedSex && param1.shopItemInfo.TemplateInfo.NeedSex != 0)
            {
               this.setCurrentSex(param1.shopItemInfo.TemplateInfo.NeedSex);
               this._controller.setFittingModel(CURRENT_GENDER == 1);
            }
         }
      }
      
      private function __pageBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._isSearch)
         {
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
         else
         {
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
                     CURRENT_PAGE = this._searchItemTotalPage + 1;
                  }
                  --CURRENT_PAGE;
                  break;
               case this._nextPageBtn:
                  if(CURRENT_PAGE == this._searchItemTotalPage)
                  {
                     CURRENT_PAGE = 0;
                  }
                  ++CURRENT_PAGE;
                  break;
               case this._endPageBtn:
                  if(CURRENT_PAGE != this._searchItemTotalPage)
                  {
                     CURRENT_PAGE = this._searchItemTotalPage;
                  }
            }
            this.runSearch();
         }
      }
      
      private function __subBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this._subBtnsContainers[TOP_TYPE].getChildIndex(param1.currentTarget as SelectedButton);
         if(_loc2_ != SUB_TYPE)
         {
            SUB_TYPE = _loc2_;
            CURRENT_PAGE = 1;
            this.loadList();
            SoundManager.instance.play("008");
         }
      }
      
      private function __topBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this._topBtns.indexOf(param1.currentTarget as SelectedButton);
         this._isSearch = false;
         this._shopSearchBox.visible = false;
         this._tempTopType = -1;
         this._tempCurrentPage = -1;
         if(_loc2_ != TOP_TYPE)
         {
            TOP_TYPE = _loc2_;
            SUB_TYPE = 0;
            CURRENT_PAGE = 1;
            this.showSubBtns(_loc2_);
            if(TOP_TYPE == 4)
            {
               EXCHANGE_TYPE = 0;
               this._shopExchangeGroup.selectIndex = 0;
               this._shopExchangeBox.visible = true;
               if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_SHOP) && PlayerManager.Instance.Self.Grade >= 9)
               {
                  NewHandContainer.Instance.clearArrowByID(ArrowType.SHOP_GIFT);
                  this._giftShine = ComponentFactory.Instance.creatCustomObject("trainer.shineGift");
                  LayerManager.Instance.addToLayer(this._giftShine,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.NONE_BLOCKGOUND);
                  this._giftTip = ClassUtils.CreatInstance("asset.trainer.txtGiftTip");
                  PositionUtils.setPos(this._giftTip,"trainer.giftTip");
                  LayerManager.Instance.addToLayer(this._giftTip,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.NONE_BLOCKGOUND);
                  SocketManager.Instance.out.syncWeakStep(Step.GUIDE_SHOP);
               }
            }
            else
            {
               EXCHANGE_TYPE = -1;
               this._shopExchangeBox.visible = false;
               this.disposeUserGuide();
            }
            this.loadList();
            SoundManager.instance.play("008");
         }
      }
      
      private function disposeUserGuide() : void
      {
         ObjectUtils.disposeObject(this._giftShine);
         ObjectUtils.disposeObject(this._giftTip);
         this._giftShine = null;
         this._giftTip = null;
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
      
      private function removeEvent() : void
      {
         this._maleBtn.removeEventListener(MouseEvent.CLICK,this.__genderClick);
         this._femaleBtn.removeEventListener(MouseEvent.CLICK,this.__genderClick);
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__pageBtnClick);
         var _loc1_:uint = 0;
         while(_loc1_ < SHOP_ITEM_NUM)
         {
            this._goodItems[_loc1_].removeEventListener(ItemEvent.ITEM_CLICK,this.__itemClick);
            this._goodItems[_loc1_].removeEventListener(ItemEvent.ITEM_SELECT,this.__itemSelect);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._topBtns.length)
         {
            this._topBtns[_loc1_].removeEventListener(MouseEvent.CLICK,this.__topBtnClick);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._subBtns.length)
         {
            this._subBtns[_loc1_].removeEventListener(MouseEvent.CLICK,this.__subBtnClick);
            _loc1_++;
         }
         this._shopExchangeGiftBtn.removeEventListener(MouseEvent.CLICK,this.__shopExchangeBtnClick);
         this._shopExchangeMedalBtn.removeEventListener(MouseEvent.CLICK,this.__shopExchangeBtnClick);
         removeEventListener(Event.ADDED_TO_STAGE,this.__userGuide);
         this._shopSearchColseBtn.removeEventListener(MouseEvent.CLICK,this.__shopSearchColseBtnClick);
      }
      
      protected function __shopExchangeBtnClick(param1:MouseEvent) : void
      {
         if(EXCHANGE_TYPE == this._shopExchangeGroup.selectIndex)
         {
            return;
         }
         SoundManager.instance.play("008");
         this.disposeUserGuide();
         EXCHANGE_TYPE = this._shopExchangeGroup.selectIndex;
         CURRENT_PAGE = 1;
         this.loadList();
      }
      
      private function showSubBtns(param1:int) : void
      {
         var _loc3_:HBox = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._subBtnsContainers.length)
         {
            _loc3_ = this._subBtnsContainers[_loc2_] as HBox;
            if(_loc3_)
            {
               _loc3_.visible = false;
            }
            _loc2_++;
         }
         if(this._subBtnsContainers[param1])
         {
            this._subBtnsContainers[param1].visible = true;
            this._tempSubBtnHBox = this._subBtnsContainers[param1];
            this._subBtnsGroups[param1].selectIndex = 0;
         }
      }
      
      public function gotoPage(param1:int = -1, param2:int = -1, param3:int = 1, param4:int = 1) : void
      {
         var _loc6_:HBox = null;
         if(param1 != -1)
         {
            TOP_TYPE = param1;
         }
         if(param2 != -1)
         {
            SUB_TYPE = param2;
         }
         CURRENT_PAGE = param3;
         CURRENT_GENDER = param4;
         this._topBtnsGroup.selectIndex = TOP_TYPE;
         this._subBtnsGroups[TOP_TYPE].selectIndex = SUB_TYPE;
         this._genderGroup.selectIndex = CURRENT_GENDER - 1;
         this.setCurrentSex(CURRENT_GENDER);
         this._currentPageTxt.text = CURRENT_PAGE + "/" + this._searchItemTotalPage;
         this._shopExchangeBox.visible = TOP_TYPE == 4;
         if(EXCHANGE_TYPE > 0)
         {
            this._shopExchangeGroup.selectIndex = EXCHANGE_TYPE;
         }
         var _loc5_:int = 0;
         while(_loc5_ < this._subBtnsContainers.length)
         {
            _loc6_ = this._subBtnsContainers[_loc5_] as HBox;
            if(_loc6_)
            {
               _loc6_.visible = false;
            }
            _loc5_++;
         }
         if(this._subBtnsContainers[TOP_TYPE])
         {
            this._subBtnsContainers[TOP_TYPE].visible = true;
            this._tempSubBtnHBox = this._subBtnsContainers[TOP_TYPE];
         }
         this.loadList();
      }
      
      public function dispose() : void
      {
         if(this._tempCurrentPage > -1)
         {
            CURRENT_PAGE = this._tempCurrentPage;
         }
         if(this._tempTopType > -1)
         {
            TOP_TYPE = this._tempTopType;
         }
         this.removeEvent();
         this.disposeUserGuide();
         ObjectUtils.disposeAllChildren(this);
         if(this._currentPageTxt)
         {
            this._currentPageTxt.dispose();
         }
         this._currentPageTxt = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._goodItems.length)
         {
            ObjectUtils.disposeObject(this._goodItems[_loc1_]);
            this._goodItems[_loc1_] = null;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._topBtns.length)
         {
            this._topBtns[_loc1_] = null;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._subBtns.length)
         {
            this._subBtns[_loc1_] = null;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._subBtnsGroups.length)
         {
            this._subBtnsGroups[_loc1_] = null;
            this._subBtnsContainers[_loc1_] = null;
            _loc1_++;
         }
         this._bg = null;
         this._bg1 = null;
         this._controller = null;
         this._femaleBtn = null;
         this._genderGroup = null;
         this._goodItemGroup = null;
         this._maleBtn = null;
         this._nextPageBtn = null;
         this._prePageBtn = null;
         this._topBtnsGroup = null;
         this._goodItems = null;
         this._genderContainer = null;
         this._goodItemContainerAll = null;
         this._topBtns = null;
         this._topBtnsContainer = null;
         this._subBtns = null;
         this._subBtnsGroups = null;
         this._subBtnsContainers = null;
         this._rightItemLightMc = null;
         this._tempSubBtnHBox = null;
         ObjectUtils.disposeObject(this._rightItemLightMc);
         this._rightItemLightMc = null;
         ObjectUtils.disposeObject(this._shopExchangeMedalBtn);
         this._shopExchangeMedalBtn = null;
         ObjectUtils.disposeObject(this._shopExchangeGiftBtn);
         this._shopExchangeGiftBtn = null;
         ObjectUtils.disposeObject(this._shopExchangeBoxBg);
         this._shopExchangeBoxBg = null;
         ObjectUtils.disposeObject(this._shopExchangeBox);
         this._shopExchangeBox = null;
         ObjectUtils.disposeObject(this._shopSearchEndBtnBg);
         this._shopSearchEndBtnBg = null;
         ObjectUtils.disposeObject(this._shopSearchColseBtn);
         this._shopSearchColseBtn = null;
         ObjectUtils.disposeObject(this._shopSearchBox);
         this._shopSearchBox = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
