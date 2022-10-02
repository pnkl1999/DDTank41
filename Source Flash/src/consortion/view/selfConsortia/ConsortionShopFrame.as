package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaAssetLevelOffer;
   import consortion.event.ConsortionEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ConsortionShopFrame extends Frame
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _bg2:MutipleImage;
      
      private var _gold:FilterFrameText;
      
      private var _money:FilterFrameText;
      
      private var _offer:FilterFrameText;
      
      private var _ttoffer:FilterFrameText;
      
      private var _level1:SelectedButton;
      
      private var _level2:SelectedButton;
      
      private var _level3:SelectedButton;
      
      private var _level4:SelectedButton;
      
      private var _level5:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _list:ConsortionShopList;
      
      public function ConsortionShopFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopView.titleText");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.bg");
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.bg2");
         this._gold = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.gold");
         this._money = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.money");
         this._offer = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.offer");
         this._ttoffer = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.ttoffer");
         this._level1 = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.level1");
         this._level2 = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.level2");
         this._level3 = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.level3");
         this._level4 = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.level4");
         this._level5 = ComponentFactory.Instance.creatComponentByStylename("consortion.shop.level5");
         this._btnGroup = new SelectedButtonGroup();
         this._list = ComponentFactory.Instance.creatCustomObject("consortionShopList");
         addToContent(this._bg);
         addToContent(this._bg2);
         addToContent(this._gold);
         addToContent(this._money);
         addToContent(this._offer);
         addToContent(this._ttoffer);
         addToContent(this._level1);
         addToContent(this._level2);
         addToContent(this._level3);
         addToContent(this._level4);
         addToContent(this._level5);
         addToContent(this._list);
         this._btnGroup.addSelectItem(this._level1);
         this._btnGroup.addSelectItem(this._level2);
         this._btnGroup.addSelectItem(this._level3);
         this._btnGroup.addSelectItem(this._level4);
         this._btnGroup.addSelectItem(this._level5);
         this._btnGroup.selectIndex = 0;
         this._gold.text = String(PlayerManager.Instance.Self.Gold);
         this._money.text = String(PlayerManager.Instance.Self.Money);
         this._offer.text = String(PlayerManager.Instance.Self.Offer);
         this._ttoffer.text = String(PlayerManager.Instance.Self.UseOffer);
         this.showLevel(this._btnGroup.selectIndex + 1);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__groupChange);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.USE_CONDITION_CHANGE,this.__useChangeHandler);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propChangeHandler);
      }
      
      protected function __useChangeHandler(param1:Event) : void
      {
         this.showLevel(this._btnGroup.selectIndex + 1);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__groupChange);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.USE_CONDITION_CHANGE,this.__useChangeHandler);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propChangeHandler);
      }
      
      private function __propChangeHandler(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Offer"])
         {
            this._offer.text = String(PlayerManager.Instance.Self.Offer);
         }
         if(param1.changedProperties["Money"])
         {
            this._money.text = String(PlayerManager.Instance.Self.Money);
         }
         if(param1.changedProperties["Gold"])
         {
            this._gold.text = String(PlayerManager.Instance.Self.Gold);
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __groupChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.showLevel(this._btnGroup.selectIndex + 1);
      }
      
      private function showLevel(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Boolean = PlayerManager.Instance.Self.consortiaInfo.ShopLevel >= param1 ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         var _loc3_:Vector.<ConsortiaAssetLevelOffer> = ConsortionModelControl.Instance.model.useConditionList;
         if(_loc3_ == null || _loc3_.length == 0)
         {
            _loc4_ = 100;
         }
         else
         {
            _loc4_ = ConsortionModelControl.Instance.model.useConditionList[param1 - 1].Riches;
         }
         this._list.list(ShopManager.Instance.consortiaShopLevelTemplates(param1),param1,_loc4_,_loc2_);
      }
      
      private function __managerClickHandler(param1:MouseEvent) : void
      {
         ConsortionModelControl.Instance.alertManagerFrame();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._bg2 = null;
         this._gold = null;
         this._money = null;
         this._offer = null;
         this._ttoffer = null;
         this._level1 = null;
         this._level2 = null;
         this._level3 = null;
         this._level4 = null;
         this._level5 = null;
         this._btnGroup = null;
         this._list = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
