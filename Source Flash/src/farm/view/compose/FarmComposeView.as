package farm.view.compose
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import store.HelpFrame;
   import trainer.data.ArrowType;
   
   public class FarmComposeView extends Frame
   {
       
      
      private var _helpBtn:BaseButton;
      
      private var _houseBtn:SelectedButton;
      
      private var _composeBtn:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _currentType:int = -1;
      
      private var _hosePnl:FarmHousePnl;
      
      private var _composePnl:FarmComposePnl;
      
      private var _info:SelfInfo;
      
      private var _titleBg:DisplayObject;
      
      public function FarmComposeView()
      {
         super();
         this.initView();
         this.initEvent();
         escEnable = true;
      }
      
      public function get info() : SelfInfo
      {
         return this._info;
      }
      
      public function set info(param1:SelfInfo) : void
      {
         this._info = param1;
      }
      
      private function initView() : void
      {
         this._titleBg = ComponentFactory.Instance.creat("assets.farmCompose.title");
         addChild(this._titleBg);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("farmHouse.NotesButton");
         addToContent(this._helpBtn);
         this._houseBtn = ComponentFactory.Instance.creatComponentByStylename("farmShop.button.house");
         addToContent(this._houseBtn);
         this._composeBtn = ComponentFactory.Instance.creatComponentByStylename("farmShop.button.compose");
         addToContent(this._composeBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._houseBtn);
         this._btnGroup.addSelectItem(this._composeBtn);
         this._btnGroup.selectIndex = 0;
         this._hosePnl = new FarmHousePnl();
         addToContent(this._hosePnl);
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__composeHelp);
         addEventListener(FrameEvent.RESPONSE,this.__frameHandler);
      }
      
      private function __frameHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
               if(PetBagController.instance().petModel.IsFinishTask5)
               {
                  PetBagController.instance().showPetFarmGuildArrow(ArrowType.OPEN_FARM_SHOP,-60,"farmTrainer.openFarmShopArrowPos","asset.farmTrainer.openFarmShop","farmTrainer.openFarmShopTipPos");
                  break;
               }
         }
      }
      
      private function __composeHelp(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:DisplayObject = ComponentFactory.Instance.creat("farmHouse.HelpPrompt");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("farm.HelpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("ddt.farmHouse.readme");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __changeHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this.switchView(true);
               break;
            case 1:
               this.switchView(false);
               if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK5))
               {
                  PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.CLICK_COOK_TAB);
               }
         }
         this._currentType = this._btnGroup.selectIndex;
      }
      
      private function switchView(param1:Boolean) : void
      {
         this._hosePnl.visible = param1;
         if(this._composePnl == null)
         {
            this._composePnl = new FarmComposePnl();
            addToContent(this._composePnl);
            this._composePnl.y = -15;
         }
         this._composePnl.visible = !param1;
         this._composePnl.clearInfo();
      }
      
      private function removeEvent() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__composeHelp);
         removeEventListener(FrameEvent.RESPONSE,this.__frameHandler);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK5))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.OPEN_STORAGE);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._info = null;
         this._currentType = -1;
         if(this._helpBtn)
         {
            ObjectUtils.disposeObject(this._helpBtn);
            this._helpBtn = null;
         }
         if(this._titleBg)
         {
            ObjectUtils.disposeObject(this._titleBg);
            this._titleBg = null;
         }
         if(this._composePnl)
         {
            ObjectUtils.disposeObject(this._composePnl);
            this._composePnl = null;
         }
         if(this._hosePnl)
         {
            ObjectUtils.disposeObject(this._hosePnl);
            this._hosePnl = null;
         }
         if(this._btnGroup)
         {
            ObjectUtils.disposeObject(this._btnGroup);
            this._btnGroup = null;
         }
         if(this._composeBtn)
         {
            ObjectUtils.disposeObject(this._composeBtn);
            this._composeBtn = null;
         }
         if(this._houseBtn)
         {
            ObjectUtils.disposeObject(this._houseBtn);
            this._houseBtn = null;
         }
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
