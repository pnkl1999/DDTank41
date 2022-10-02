package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.bagStore.BagStore;
   import ddt.data.ConsortiaDutyType;
   import ddt.data.store.StoreState;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ConsortiaDutyManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BuildingManager extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _tax:BaseButton;
      
      private var _shop:BaseButton;
      
      private var _store:BaseButton;
      
      private var _bank:BaseButton;
      
      private var _skill:BaseButton;
      
      private var _chairmanChanel:BaseButton;
      
      private var _manager:BaseButton;
      
      private var _takeIn:BaseButton;
      
      private var _exit:BaseButton;
      
      private var _chairChannel:ChairmanChannelPanel;
      
      private var _chairChannelShow:Boolean = true;
      
      public function BuildingManager()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.building.bg");
         this._tax = ComponentFactory.Instance.creatComponentByStylename("buildingManager.tax");
         this._shop = ComponentFactory.Instance.creatComponentByStylename("buildingManager.shop");
         this._store = ComponentFactory.Instance.creatComponentByStylename("buildingManager.store");
         this._bank = ComponentFactory.Instance.creatComponentByStylename("buildingManager.bank");
         this._skill = ComponentFactory.Instance.creatComponentByStylename("buildingManager.skill");
         this._chairmanChanel = ComponentFactory.Instance.creatComponentByStylename("buildingManager.chairmanChanel");
         this._manager = ComponentFactory.Instance.creatComponentByStylename("buildingManager.manager");
         this._takeIn = ComponentFactory.Instance.creatComponentByStylename("buildingManager.takeIn");
         this._exit = ComponentFactory.Instance.creatComponentByStylename("buildingManager.exit");
         addChild(this._bg);
         addChild(this._tax);
         addChild(this._shop);
         addChild(this._store);
         addChild(this._bank);
         addChild(this._skill);
         addChild(this._chairmanChanel);
         addChild(this._manager);
         addChild(this._takeIn);
         addChild(this._exit);
         this.initRight();
      }
      
      private function initRight() : void
      {
         var _loc1_:int = PlayerManager.Instance.Self.Right;
         this._exit.enable = ConsortiaDutyManager.GetRight(_loc1_,ConsortiaDutyType._13_Exit);
         this._takeIn.enable = ConsortiaDutyManager.GetRight(_loc1_,ConsortiaDutyType._1_Ratify);
         this._chairmanChanel.enable = ConsortiaDutyManager.GetRight(_loc1_,ConsortiaDutyType._10_ChangeMan);
      }
      
      private function initEvent() : void
      {
         this._tax.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._shop.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._store.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._bank.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._chairmanChanel.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._manager.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._takeIn.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._exit.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._skill.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propChange);
      }
      
      private function removeEvent() : void
      {
         this._tax.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._shop.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._store.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._bank.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._chairmanChanel.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._manager.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._takeIn.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._exit.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         this._skill.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propChange);
      }
      
      private function __propChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Right"])
         {
            this.initRight();
         }
      }
      
      private function __onClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:ConsortionSkillFrame = null;
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._tax:
               ConsortionModelControl.Instance.alertTaxFrame();
               break;
            case this._shop:
               ConsortionModelControl.Instance.alertShopFrame();
               break;
            case this._store:
               BagStore.instance.show(StoreState.CONSORTIASTORE);
               break;
            case this._bank:
               ConsortionModelControl.Instance.alertBankFrame();
               break;
            case this._skill:
               _loc2_ = ComponentFactory.Instance.creatComponentByStylename("consortionSkillFrame");
               LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               break;
            case this._chairmanChanel:
               this.showChairmanChannel(param1);
               break;
            case this._manager:
               ConsortionModelControl.Instance.alertManagerFrame();
               break;
            case this._takeIn:
               ConsortionModelControl.Instance.alertTakeInFrame();
               break;
            case this._exit:
               ConsortionModelControl.Instance.alertQuitFrame();
         }
      }
      
      private function showChairmanChannel(param1:MouseEvent) : void
      {
         if(this._chairChannelShow)
         {
            param1.stopImmediatePropagation();
            if(!this._chairChannel)
            {
               this._chairChannel = ComponentFactory.Instance.creatCustomObject("chairmanChannelPanel");
               addChild(this._chairChannel);
            }
            this._chairChannel.visible = true;
            LayerManager.Instance.addToLayer(this._chairChannel,LayerManager.GAME_DYNAMIC_LAYER);
            stage.addEventListener(MouseEvent.CLICK,this.__closeChairChnnel);
         }
         else if(this._chairChannel)
         {
            this._chairChannel.visible = false;
         }
         this._chairChannelShow = !!this._chairChannelShow ? Boolean(Boolean(false)) : Boolean(Boolean(true));
      }
      
      private function __closeChairChnnel(param1:MouseEvent) : void
      {
         if(param1.target != this._chairChannel)
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__closeChairChnnel);
            if(this._chairChannel)
            {
               this._chairChannel.visible = false;
               this._chairChannelShow = true;
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._chairChannel = null;
         this._tax = null;
         this._shop = null;
         this._store = null;
         this._bank = null;
         this._skill = null;
         this._bg = null;
         this._chairmanChanel = null;
         this._manager = null;
         this._takeIn = null;
         this._exit = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
