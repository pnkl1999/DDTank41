package giftSystem.view
{
   import com.pickgliss.effect.AlphaShinerAnimation;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ShopType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import giftSystem.GiftController;
   import giftSystem.GiftEvent;
   import giftSystem.element.TurnPage;
   
   public class GiftShopView extends Sprite implements Disposeable
   {
      
      public static const HOT_GOODS:int = 0;
      
      public static const FLOWER:int = 1;
      
      public static const DESSERT:int = 2;
      
      public static const TOY:int = 3;
      
      public static const RARE:int = 4;
      
      public static const FESTIVAL:int = 5;
      
      public static const WEDDING:int = 6;
       
      
      private var _title:Bitmap;
      
      private var _BG1:Scale9CornerImage;
      
      private var _BG2:Scale9CornerImage;
      
      private var _BG3:Scale9CornerImage;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _hotGoodsBtn:SelectedButton;
      
      private var _flowerBtn:SelectedButton;
      
      private var _dessertBtn:SelectedButton;
      
      private var _toyBtn:SelectedButton;
      
      private var _rareBtn:SelectedButton;
      
      private var _festivalBtn:SelectedButton;
      
      private var _weddingBtn:SelectedButton;
      
      private var _prompt:FilterFrameText;
      
      private var _turnPage:TurnPage;
      
      private var _goodsList:GiftGoodsListView;
      
      private var _thisShine:IEffect;
      
      private var container:Sprite;
      
      private var time:Timer;
      
      public function GiftShopView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.container = new Sprite();
         this._BG1 = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.BG1");
         this._BG2 = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.BG2");
         this._BG3 = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.BG3");
         this._title = ComponentFactory.Instance.creatBitmap("asset.giftShop.title");
         this._hotGoodsBtn = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.hotGoods");
         this._flowerBtn = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.flower");
         this._dessertBtn = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.dessert");
         this._toyBtn = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.toy");
         this._rareBtn = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.rare");
         this._festivalBtn = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.festival");
         this._weddingBtn = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.wedding");
         this._prompt = ComponentFactory.Instance.creatComponentByStylename("GiftShopView.prompt");
         this._turnPage = ComponentFactory.Instance.creatCustomObject("turnPage");
         this._goodsList = ComponentFactory.Instance.creatCustomObject("giftGoodListView");
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._hotGoodsBtn);
         this._btnGroup.addSelectItem(this._flowerBtn);
         this._btnGroup.addSelectItem(this._dessertBtn);
         this._btnGroup.addSelectItem(this._toyBtn);
         this._btnGroup.addSelectItem(this._rareBtn);
         this._btnGroup.addSelectItem(this._festivalBtn);
         this._btnGroup.addSelectItem(this._weddingBtn);
         if(GiftController.Instance.inChurch)
         {
            this._btnGroup.selectIndex = 6;
         }
         else
         {
            this._btnGroup.selectIndex = 0;
         }
         addChild(this.container);
         this.container.addChild(this._BG1);
         addChild(this._BG2);
         this.container.addChild(this._title);
         addChild(this._hotGoodsBtn);
         addChild(this._flowerBtn);
         addChild(this._dessertBtn);
         addChild(this._toyBtn);
         addChild(this._rareBtn);
         addChild(this._festivalBtn);
         addChild(this._weddingBtn);
         addChild(this._BG3);
         addChild(this._prompt);
         addChild(this._turnPage);
         addChild(this._goodsList);
         var _loc1_:Object = new Object();
         _loc1_[AlphaShinerAnimation.BLUR_WIDTH] = 12;
         _loc1_[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
         this._thisShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this.container,_loc1_);
         this._thisShine.stop();
         this._prompt.text = LanguageMgr.GetTranslation("ddt.giftSystem.GiftShopView.chooseGiftForFriend");
         this.__changeHandler(null);
      }
      
      private function initEvent() : void
      {
         this._hotGoodsBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._flowerBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._dessertBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._toyBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._rareBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._festivalBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._weddingBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._turnPage.addEventListener(TurnPage.CURRENTPAGE_CHANGE,this.__upView);
         GiftController.Instance.addEventListener(GiftEvent.REBACK_GIFT,this.__showLight);
      }
      
      private function __showLight(param1:GiftEvent) : void
      {
         this._thisShine.play();
         this.time = new Timer(4500,1);
         this.time.start();
         this.time.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timeOver);
      }
      
      private function __timeOver(param1:TimerEvent) : void
      {
         this.time.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timeOver);
         this._thisShine.stop();
      }
      
      private function __changeHandler(param1:Event) : void
      {
         this._turnPage.current = 1;
         this._turnPage.total = ShopManager.Instance.getResultPages(this.getType(),6);
         this.__upView(null);
      }
      
      private function __upView(param1:Event) : void
      {
         this._goodsList.setList(ShopManager.Instance.getValidSortedGoodsByType(this.getType(),this._turnPage.current,6));
      }
      
      private function removeEvent() : void
      {
         this._hotGoodsBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._flowerBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._dessertBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._toyBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._rareBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._festivalBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._weddingBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._turnPage.removeEventListener(TurnPage.CURRENTPAGE_CHANGE,this.__upView);
         GiftController.Instance.removeEventListener(GiftEvent.REBACK_GIFT,this.__showLight);
         if(this.time)
         {
            this.time.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timeOver);
         }
      }
      
      private function getType() : int
      {
         switch(this._btnGroup.selectIndex)
         {
            case HOT_GOODS:
               return ShopType.HOT_GOODS;
            case FLOWER:
               return ShopType.FLOWER;
            case DESSERT:
               return ShopType.DESSERT;
            case TOY:
               return ShopType.TOYS;
            case RARE:
               return ShopType.RARE;
            case FESTIVAL:
               return ShopType.FESTIVAL;
            case WEDDING:
               return ShopType.WEDDING;
            default:
               return -1;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.time = null;
         if(this.container)
         {
            ObjectUtils.disposeObject(this.container);
         }
         this.container = null;
         if(this._title)
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(this._BG1)
         {
            ObjectUtils.disposeObject(this._BG1);
         }
         this._BG1 = null;
         if(this._BG2)
         {
            ObjectUtils.disposeObject(this._BG2);
         }
         this._BG2 = null;
         if(this._BG3)
         {
            ObjectUtils.disposeObject(this._BG3);
         }
         this._BG3 = null;
         if(this._hotGoodsBtn)
         {
            ObjectUtils.disposeObject(this._hotGoodsBtn);
         }
         this._hotGoodsBtn = null;
         if(this._flowerBtn)
         {
            ObjectUtils.disposeObject(this._flowerBtn);
         }
         this._flowerBtn = null;
         if(this._dessertBtn)
         {
            ObjectUtils.disposeObject(this._dessertBtn);
         }
         this._dessertBtn = null;
         if(this._toyBtn)
         {
            ObjectUtils.disposeObject(this._toyBtn);
         }
         this._toyBtn = null;
         if(this._rareBtn)
         {
            ObjectUtils.disposeObject(this._rareBtn);
         }
         this._rareBtn = null;
         if(this._festivalBtn)
         {
            ObjectUtils.disposeObject(this._festivalBtn);
         }
         this._festivalBtn = null;
         if(this._weddingBtn)
         {
            ObjectUtils.disposeObject(this._weddingBtn);
         }
         this._weddingBtn = null;
         if(this._prompt)
         {
            ObjectUtils.disposeObject(this._prompt);
         }
         this._prompt = null;
         if(this._btnGroup)
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
         if(this._thisShine)
         {
            EffectManager.Instance.removeEffect(this._thisShine);
         }
         this._thisShine = null;
         if(this._goodsList)
         {
            ObjectUtils.disposeObject(this._goodsList);
         }
         this._goodsList = null;
         if(this._turnPage)
         {
            ObjectUtils.disposeObject(this._turnPage);
         }
         this._turnPage = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function __soundPlay(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
   }
}
