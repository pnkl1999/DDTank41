package shop.view
{
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.TweenProxy;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import shop.ShopController;
   import shop.manager.ShopBuyManager;
   import shop.manager.ShopGiftsManager;
   
   public class ShopRankingView extends Sprite implements Disposeable
   {
       
      
      private var _controller:ShopController;
      
      private var _shopSearchBg:Bitmap;
      
      private var _rankingBackBg:ScaleBitmapImage;
      
      private var _rankingFrontBg:ScaleBitmapImage;
      
      private var _shopSearchBtn:BaseButton;
      
      private var _shopSearchText:FilterFrameText;
      
      private var _rankinGroup:SelectedButtonGroup;
      
      private var _praiseRankingBtn:SelectedButton;
      
      private var _popularityRankingBtn:SelectedButton;
      
      private var _vBox:VBox;
      
      private var _rankingItems:Vector.<ShopRankingCellItem>;
      
      private var _rankingLightMc:MovieClip;
      
      private var _currentShopSearchText:String;
      
      private var _currentList:Vector.<ShopItemInfo>;
      
      public function ShopRankingView()
      {
         super();
      }
      
      public function setup(param1:ShopController) : void
      {
         this._controller = param1;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._shopSearchBg = ComponentFactory.Instance.creatBitmap("asset.shop.ShopSearchBg");
         addChild(this._shopSearchBg);
         this._rankingBackBg = ComponentFactory.Instance.creatComponentByStylename("shop.RankingBackBg");
         addChild(this._rankingBackBg);
         this._rankingFrontBg = ComponentFactory.Instance.creatComponentByStylename("shop.RankingFrontBg");
         addChild(this._rankingFrontBg);
         this._shopSearchBtn = ComponentFactory.Instance.creatComponentByStylename("shop.ShopSearchBtn");
         addChild(this._shopSearchBtn);
         this._shopSearchText = ComponentFactory.Instance.creatComponentByStylename("shop.ShopSearchText");
         this._shopSearchText.text = LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText");
         addChild(this._shopSearchText);
         this._rankinGroup = new SelectedButtonGroup();
         this._popularityRankingBtn = ComponentFactory.Instance.creatComponentByStylename("shop.PopularityRankingBtn");
         addChild(this._popularityRankingBtn);
         this._rankinGroup.addSelectItem(this._popularityRankingBtn);
         this._praiseRankingBtn = ComponentFactory.Instance.creatComponentByStylename("shop.PraiseRankingBtn");
         addChild(this._praiseRankingBtn);
         this._rankinGroup.addSelectItem(this._praiseRankingBtn);
         this._praiseRankingBtn.visible = false;
         this._rankinGroup.selectIndex = 0;
         this._rankingItems = new Vector.<ShopRankingCellItem>();
         this._vBox = new VBox();
         this._vBox.x = 11;
         this._vBox.y = 98;
         this._vBox.spacing = 2;
         addChild(this._vBox);
         this._rankingLightMc = ComponentFactory.Instance.creatCustomObject("shop.RankingLightMc");
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this._rankingItems[_loc1_] = ComponentFactory.Instance.creatCustomObject("shop.ShopRankingCellItem");
            this._rankingItems[_loc1_].itemCellBtn.addEventListener(MouseEvent.CLICK,this.__itemClick);
            this._rankingItems[_loc1_].itemCellBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__rankingItemsMouseOver);
            this._rankingItems[_loc1_].itemCellBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__rankingItemsMouseOut);
            this._rankingItems[_loc1_].itemBg.addEventListener(MouseEvent.MOUSE_OVER,this.__rankingItemsMouseOver);
            this._rankingItems[_loc1_].itemBg.addEventListener(MouseEvent.MOUSE_OUT,this.__rankingItemsMouseOut);
            this._rankingItems[_loc1_].payPaneGivingBtn.addEventListener(MouseEvent.CLICK,this.__payPaneGivingBtnClick);
            this._rankingItems[_loc1_].payPaneBuyBtn.addEventListener(MouseEvent.CLICK,this.__payPaneBuyBtnClick);
            this._vBox.addChild(this._rankingItems[_loc1_]);
            _loc1_++;
         }
         this.loadList();
      }
      
      private function addEvent() : void
      {
         this._shopSearchText.addEventListener(FocusEvent.FOCUS_IN,this.__shopSearchTextFousIn);
         this._shopSearchText.addEventListener(FocusEvent.FOCUS_OUT,this.__shopSearchTextFousOut);
         this._shopSearchText.addEventListener(KeyboardEvent.KEY_DOWN,this.__shopSearchTextKeyDown);
         this._shopSearchBtn.addEventListener(MouseEvent.CLICK,this.__shopSearchBtnClick);
         this._popularityRankingBtn.addEventListener(MouseEvent.CLICK,this.__rankingBtnClick);
         this._praiseRankingBtn.addEventListener(MouseEvent.CLICK,this.__rankingBtnClick);
      }
      
      private function removeEvent() : void
      {
         this._shopSearchText.removeEventListener(FocusEvent.FOCUS_IN,this.__shopSearchTextFousIn);
         this._shopSearchText.removeEventListener(FocusEvent.FOCUS_OUT,this.__shopSearchTextFousOut);
         this._shopSearchText.removeEventListener(KeyboardEvent.KEY_DOWN,this.__shopSearchTextKeyDown);
         this._shopSearchBtn.removeEventListener(MouseEvent.CLICK,this.__shopSearchBtnClick);
         this._popularityRankingBtn.removeEventListener(MouseEvent.CLICK,this.__rankingBtnClick);
         this._praiseRankingBtn.removeEventListener(MouseEvent.CLICK,this.__rankingBtnClick);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this._rankingItems[_loc1_].itemCellBtn.removeEventListener(MouseEvent.CLICK,this.__itemClick);
            this._rankingItems[_loc1_].itemCellBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__rankingItemsMouseOver);
            this._rankingItems[_loc1_].itemCellBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__rankingItemsMouseOut);
            this._rankingItems[_loc1_].itemBg.removeEventListener(MouseEvent.MOUSE_OVER,this.__rankingItemsMouseOver);
            this._rankingItems[_loc1_].itemBg.removeEventListener(MouseEvent.MOUSE_OUT,this.__rankingItemsMouseOut);
            this._rankingItems[_loc1_].payPaneGivingBtn.removeEventListener(MouseEvent.CLICK,this.__payPaneGivingBtnClick);
            this._rankingItems[_loc1_].payPaneBuyBtn.removeEventListener(MouseEvent.CLICK,this.__payPaneBuyBtnClick);
            _loc1_++;
         }
      }
      
      private function __payPaneGivingBtnClick(param1:Event) : void
      {
         var _loc3_:ISelectable = null;
         param1.stopImmediatePropagation();
         var _loc2_:ShopRankingCellItem = param1.currentTarget.parent as ShopRankingCellItem;
         if(_loc2_.shopItemInfo && _loc2_.shopItemInfo.LimitCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
            return;
         }
         if(_loc2_.shopItemInfo != null)
         {
            SoundManager.instance.play("008");
            ShopGiftsManager.Instance.buy(_loc2_.shopItemInfo.GoodsID);
            for each(_loc3_ in this._rankingItems)
            {
               _loc3_.selected = false;
            }
            _loc2_.selected = true;
         }
      }
      
      private function __payPaneBuyBtnClick(param1:Event) : void
      {
         var _loc3_:ISelectable = null;
         param1.stopImmediatePropagation();
         var _loc2_:ShopRankingCellItem = param1.currentTarget.parent as ShopRankingCellItem;
         if(_loc2_.shopItemInfo && _loc2_.shopItemInfo.LimitCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
            return;
         }
         if(_loc2_.shopItemInfo != null)
         {
            SoundManager.instance.play("008");
            ShopBuyManager.Instance.buy(_loc2_.shopItemInfo.GoodsID);
            for each(_loc3_ in this._rankingItems)
            {
               _loc3_.selected = false;
            }
            _loc2_.selected = true;
         }
      }
      
      protected function __shopSearchTextKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            this.__shopSearchBtnClick();
         }
      }
      
      protected function __rankingBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.loadList();
      }
      
      protected function __shopSearchTextFousIn(param1:FocusEvent) : void
      {
         if(this._shopSearchText.text == LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText"))
         {
            this._shopSearchText.text = "";
         }
      }
      
      protected function __shopSearchTextFousOut(param1:FocusEvent) : void
      {
         if(this._shopSearchText.text.length == 0)
         {
            this._shopSearchText.text = LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText");
         }
      }
      
      protected function __shopSearchBtnClick(param1:MouseEvent = null) : void
      {
         var _loc2_:Vector.<ShopItemInfo> = null;
         var _loc3_:Array = null;
         SoundManager.instance.play("008");
         if(this._shopSearchText.text == LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText") || this._shopSearchText.text.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.ShopRankingView.PleaseEnterTheKeywords"));
            return;
         }
         if(this._currentShopSearchText != this._shopSearchText.text)
         {
            this._currentShopSearchText = this._shopSearchText.text;
            _loc3_ = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,63,64,65,66,67,68,69,70];
            _loc2_ = ShopManager.Instance.getDesignatedAllShopItem(_loc3_);
            _loc2_ = ShopManager.Instance.fuzzySearch(_loc2_,this._currentShopSearchText);
            this._currentList = _loc2_;
         }
         else
         {
            _loc2_ = this._currentList;
         }
         if(_loc2_.length > 0)
         {
            this._controller.rightView.searchList(_loc2_);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.ShopRankingView.NoSearchResults"));
         }
      }
      
      public function loadList() : void
      {
         this.setList(ShopManager.Instance.getValidSortedGoodsByType(this.getType(),1,5));
      }
      
      private function getType() : int
      {
         var _loc1_:Array = [ShopType.M_POPULARITY_RANKING,ShopType.F_POPULARITY_RANKING];
         var _loc2_:Array = [ShopType.M_PRAISE_RANKING,ShopType.F_PRAISE_RANKING];
         var _loc3_:Array = this._rankinGroup.selectIndex == 0 ? _loc1_ : _loc2_;
         var _loc4_:int = this._controller.rightView.genderGroup.selectIndex;
         return int(_loc3_[_loc4_]);
      }
      
      public function setList(param1:Vector.<ShopItemInfo>) : void
      {
         this.clearitems();
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            if(_loc2_ < param1.length && param1[_loc2_])
            {
               this._rankingItems[_loc2_].shopItemInfo = param1[_loc2_];
            }
            _loc2_++;
         }
      }
      
      private function clearitems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this._rankingItems[_loc1_].shopItemInfo = null;
            _loc1_++;
         }
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         var _loc3_:ISelectable = null;
         var _loc4_:ISelectable = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:ShopCarItemInfo = null;
         var _loc2_:ShopRankingCellItem = param1.currentTarget.parent as ShopRankingCellItem;
         if(!_loc2_.shopItemInfo)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(_loc2_.shopItemInfo.LimitCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
            return;
         }
         if(this._controller.model.isOverCount(_loc2_.shopItemInfo))
         {
            for each(_loc3_ in this._rankingItems)
            {
               _loc3_.selected = _loc3_ == _loc2_;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.GoodsNumberLimit"));
            return;
         }
         if(_loc2_.shopItemInfo && _loc2_.shopItemInfo.TemplateInfo)
         {
            for each(_loc4_ in this._rankingItems)
            {
               _loc4_.selected = _loc4_ == _loc2_;
            }
            if(EquipType.dressAble(_loc2_.shopItemInfo.TemplateInfo))
            {
               _loc7_ = _loc2_.shopItemInfo.TemplateInfo.NeedSex != 2 ? int(int(0)) : int(int(1));
               if(_loc2_.shopItemInfo.TemplateInfo.NeedSex != 0 && this._controller.rightView.genderGroup.selectIndex != _loc7_)
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
      
      protected function __rankingItemsMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:ShopRankingCellItem = param1.currentTarget.parent as ShopRankingCellItem;
         _loc2_.setItemLight(this._rankingLightMc);
         _loc2_.mouseOver();
      }
      
      protected function __rankingItemsMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:ShopRankingCellItem = param1.currentTarget.parent as ShopRankingCellItem;
         _loc2_.mouseOut();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._rankingLightMc);
         this._rankingLightMc = null;
         ObjectUtils.disposeObject(this._shopSearchBg);
         this._shopSearchBg = null;
         ObjectUtils.disposeObject(this._rankingBackBg);
         this._rankingBackBg = null;
         ObjectUtils.disposeObject(this._rankingFrontBg);
         this._rankingFrontBg = null;
         ObjectUtils.disposeObject(this._rankingBackBg);
         this._rankingBackBg = null;
         ObjectUtils.disposeObject(this._shopSearchBtn);
         this._shopSearchBtn = null;
         ObjectUtils.disposeObject(this._shopSearchText);
         this._shopSearchText = null;
         ObjectUtils.disposeObject(this._rankinGroup);
         this._rankinGroup = null;
         ObjectUtils.disposeObject(this._popularityRankingBtn);
         this._popularityRankingBtn = null;
         ObjectUtils.disposeObject(this._praiseRankingBtn);
         this._praiseRankingBtn = null;
         ObjectUtils.disposeObject(this._vBox);
         this._vBox = null;
      }
   }
}
