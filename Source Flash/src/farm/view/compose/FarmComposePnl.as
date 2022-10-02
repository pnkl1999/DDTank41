package farm.view.compose
{
   import baglocked.BaglockedManager;
   import com.pickgliss.effect.AlphaShinerAnimation;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.control.FarmComposeHouseController;
   import farm.view.compose.event.SelectComposeItemEvent;
   import farm.view.compose.item.ComposeItem;
   import farm.view.compose.item.ComposeMoveScroll;
   import farm.view.compose.vo.FoodComposeListTemplateInfo;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import shop.view.ShopItemCell;
   import trainer.data.ArrowType;
   
   public class FarmComposePnl extends Sprite implements Disposeable
   {
       
      
      private var _selectComposeBtn:BaseButton;
      
      private var _composeActionBtn:SimpleBitmapButton;
      
      private var _itemComposeVec:Vector.<ComposeItem>;
      
      private var _composeScroll:ComposeMoveScroll;
      
      private var _bg1:DisplayObject;
      
      private var _bg2:DisplayObject;
      
      private var _maxCount:int = -1;
      
      private var _foodID:int;
      
      private var _selectComposeBtnShine:IEffect;
      
      private var _result:ShopItemCell;
      
      private var _configmPnl:ConfirmComposeAlertFrame;
      
      private var _confirmComposeFoodAlertFrame:ConfirmComposeFoodAlertFrame;
      
      public function FarmComposePnl()
      {
         super();
         this._itemComposeVec = new Vector.<ComposeItem>();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:Point = null;
         _loc1_ = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:ComposeItem = null;
         this._bg1 = ComponentFactory.Instance.creat("asset.farmHouse.composebg1");
         addChild(this._bg1);
         this._bg2 = ComponentFactory.Instance.creat("farm.farmHouse.composebg2");
         addChild(this._bg2);
         this._composeScroll = new ComposeMoveScroll();
         addChild(this._composeScroll);
         _loc1_ = PositionUtils.creatPoint("farm.composeMoveScroll.point");
         this._composeScroll.x = _loc1_.x;
         this._composeScroll.y = _loc1_.y;
         this._selectComposeBtn = ComponentFactory.Instance.creatComponentByStylename("farmHouse.btnSelectHouseCompose");
         addChild(this._selectComposeBtn);
         this._composeActionBtn = ComponentFactory.Instance.creatComponentByStylename("farmHouse.btnComposeAction");
         addChild(this._composeActionBtn);
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            _loc5_ = ComponentFactory.Instance.creat("asset.farm.baseImage5");
            _loc6_ = ComponentFactory.Instance.creat("farmHouse.composeItem",[_loc5_]);
            PositionUtils.setPos(_loc6_,"farm.houseCompose.point" + _loc2_);
            this._itemComposeVec.push(_loc6_);
            addChild(_loc6_);
            _loc2_++;
         }
         var _loc3_:Sprite = new Sprite();
         _loc3_.graphics.beginFill(16777215,0);
         _loc3_.graphics.drawRect(0,0,50,50);
         _loc3_.graphics.endFill();
         this._result = new ShopItemCell(_loc3_);
         this._result.cellSize = 50;
         PositionUtils.setPos(this._result,"farm.composePnl.cellPos");
         this._selectComposeBtn.addChild(this._result);
         this._selectComposeBtn.mouseChildren = true;
         var _loc4_:Object = new Object();
         _loc4_[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
         this._selectComposeBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._selectComposeBtn,_loc4_);
         this._selectComposeBtnShine.play();
         this.upComposeBtn();
      }
      
      private function upComposeBtn() : void
      {
         this._composeActionBtn.enable = this._maxCount > 0;
         this.playSelectComposeBtnShine();
      }
      
      private function setCellInfo(param1:int, param2:ItemTemplateInfo, param3:int = 1) : void
      {
         if(param1 < 0 || param1 > 4)
         {
            return;
         }
         this._itemComposeVec[param1].info = param2;
         this._itemComposeVec[param1].useCount = param3;
         if(this._maxCount == -1)
         {
            this._maxCount = this._itemComposeVec[param1].maxCount;
         }
         else
         {
            this._maxCount = this._maxCount > this._itemComposeVec[param1].maxCount ? int(int(this._itemComposeVec[param1].maxCount)) : int(int(this._maxCount));
         }
      }
      
      private function initEvent() : void
      {
         this._composeActionBtn.addEventListener(MouseEvent.CLICK,this.__showComfigCompose);
         this._selectComposeBtn.addEventListener(MouseEvent.CLICK,this.__showConfirmComposeFoodAlertFrame);
         this._selectComposeBtn.addEventListener(MouseEvent.ROLL_OVER,this.__onMouseRollover);
         this._selectComposeBtn.addEventListener(MouseEvent.ROLL_OUT,this.__onMouseRollout);
         this._selectComposeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__onMouseDown);
         PlayerManager.Instance.Self.getBag(BagInfo.VEGETABLE).addEventListener(BagEvent.UPDATE,this.__bagUpdate);
      }
      
      protected function __bagUpdate(param1:Event) : void
      {
         this.update();
      }
      
      private function __showComfigCompose(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._itemComposeVec[0].info != null)
         {
            this._configmPnl = ComponentFactory.Instance.creatComponentByStylename("farm.confirmComposeAlert.confirmCompose");
            this._configmPnl.maxCount = this._maxCount;
            LayerManager.Instance.addToLayer(this._configmPnl,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            this._configmPnl.addEventListener(SelectComposeItemEvent.COMPOSE_COUNT,this.__configmCount);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("farm.componse.selected.me"));
         }
      }
      
      private function __showConfirmComposeFoodAlertFrame(param1:MouseEvent) : void
      {
         this.stopSelectComposeBtnShine();
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._confirmComposeFoodAlertFrame = ComponentFactory.Instance.creatComponentByStylename("farm.confirmComposeAlert.confirmComposeFoodAlertFrame");
         this._confirmComposeFoodAlertFrame.addEventListener(SelectComposeItemEvent.SELECT_FOOD,this.__selectFood);
         this._confirmComposeFoodAlertFrame.addEventListener(FrameEvent.RESPONSE,this.__confirmComposeFoodAlertFrameResponse);
         LayerManager.Instance.addToLayer(this._confirmComposeFoodAlertFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function closeConfirmComposeFoodAlertFrame() : void
      {
         if(this._confirmComposeFoodAlertFrame)
         {
            this._confirmComposeFoodAlertFrame.removeEventListener(SelectComposeItemEvent.SELECT_FOOD,this.__selectFood);
            this._confirmComposeFoodAlertFrame.dispose();
            this._confirmComposeFoodAlertFrame = null;
         }
      }
      
      private function __confirmComposeFoodAlertFrameResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.closeConfirmComposeFoodAlertFrame();
         }
         this.playSelectComposeBtnShine();
      }
      
      private function __selectFood(param1:SelectComposeItemEvent) : void
      {
         this.stopSelectComposeBtnShine();
         SoundManager.instance.play("008");
         this._result.info = param1.data as ItemTemplateInfo;
         this._foodID = this._result.info.TemplateID;
         if(this._selectComposeBtn.backgound is MovieClip)
         {
            (this._selectComposeBtn.backgound as MovieClip).gotoAndStop(4);
         }
         this._maxCount = -1;
         this.update();
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK5))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.CHOOSE_PET_FOOD_FORMULA);
         }
         this.closeConfirmComposeFoodAlertFrame();
      }
      
      private function __configmCount(param1:SelectComposeItemEvent) : void
      {
         this._configmPnl.removeEventListener(SelectComposeItemEvent.COMPOSE_COUNT,this.__configmCount);
         var _loc2_:int = int(param1.data);
         if(this._foodID && _loc2_)
         {
            if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK5))
            {
               PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.CHOOSE_COOK_NUM);
               PetBagController.instance().petModel.IsFinishTask5 = true;
            }
            SocketManager.Instance.out.sendCompose(this._foodID,_loc2_);
         }
      }
      
      public function clearInfo() : void
      {
         this._result.info = null;
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this.setCellInfo(_loc1_,null,0);
            _loc1_++;
         }
         if(this._selectComposeBtn.backgound is MovieClip)
         {
            (this._selectComposeBtn.backgound as MovieClip).gotoAndStop(1);
         }
         this.upComposeBtn();
      }
      
      private function stopSelectComposeBtnShine() : void
      {
         if(this._selectComposeBtn && this._selectComposeBtn.backgound is MovieClip && this._result.info)
         {
            (this._selectComposeBtn.backgound as MovieClip).gotoAndStop(4);
         }
         if(!this._result.info && !this._confirmComposeFoodAlertFrame)
         {
            this._selectComposeBtnShine.stop();
         }
      }
      
      private function playSelectComposeBtnShine() : void
      {
         if(this._selectComposeBtn && this._selectComposeBtn.backgound is MovieClip && this._result.info)
         {
            (this._selectComposeBtn.backgound as MovieClip).gotoAndStop(4);
         }
         if(!this._result.info && !this._confirmComposeFoodAlertFrame)
         {
            this._selectComposeBtnShine.play();
         }
      }
      
      private function __onMouseDown(param1:MouseEvent) : void
      {
         if(this._selectComposeBtn && this._selectComposeBtn.backgound is MovieClip && this._result.info)
         {
            (this._selectComposeBtn.backgound as MovieClip).gotoAndStop(4);
         }
      }
      
      private function __onMouseRollover(param1:MouseEvent) : void
      {
         this.stopSelectComposeBtnShine();
      }
      
      private function __onMouseRollout(param1:MouseEvent) : void
      {
         this.playSelectComposeBtnShine();
      }
      
      private function update() : void
      {
         var _loc2_:FoodComposeListTemplateInfo = null;
         var _loc1_:int = 0;
         if(this._foodID != 0)
         {
            for each(_loc2_ in FarmComposeHouseController.instance().getComposeDetailByID(this._foodID))
            {
               this.setCellInfo(_loc1_++,ItemManager.Instance.getTemplateById(_loc2_.VegetableID),_loc2_.NeedCount);
            }
            this.upComposeBtn();
         }
      }
      
      private function removeEvent() : void
      {
         this._composeActionBtn.removeEventListener(MouseEvent.CLICK,this.__showComfigCompose);
         this._selectComposeBtn.removeEventListener(MouseEvent.CLICK,this.__showConfirmComposeFoodAlertFrame);
         this._selectComposeBtn.removeEventListener(MouseEvent.ROLL_OVER,this.__onMouseRollover);
         this._selectComposeBtn.removeEventListener(MouseEvent.ROLL_OUT,this.__onMouseRollout);
         this._selectComposeBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onMouseDown);
         PlayerManager.Instance.Self.getBag(BagInfo.VEGETABLE).removeEventListener(BagEvent.UPDATE,this.__bagUpdate);
      }
      
      public function dispose() : void
      {
         var _loc1_:ComposeItem = null;
         this.removeEvent();
         this._maxCount = -1;
         this.clearInfo();
         this._foodID = 0;
         for each(_loc1_ in this._itemComposeVec)
         {
            if(_loc1_)
            {
               ObjectUtils.disposeObject(_loc1_);
               _loc1_ = null;
            }
         }
         this._itemComposeVec.splice(0,this._itemComposeVec.length);
         if(this._selectComposeBtn)
         {
            ObjectUtils.disposeObject(this._selectComposeBtn);
            this._selectComposeBtn = null;
         }
         if(this._bg2)
         {
            ObjectUtils.disposeObject(this._bg2);
            this._bg2 = null;
         }
         if(this._bg1)
         {
            ObjectUtils.disposeObject(this._bg1);
            this._bg1 = null;
         }
         if(this._composeScroll)
         {
            ObjectUtils.disposeObject(this._composeScroll);
            this._composeScroll = null;
         }
         if(this._composeActionBtn)
         {
            ObjectUtils.disposeObject(this._composeActionBtn);
            this._composeActionBtn = null;
         }
         if(this._result)
         {
            ObjectUtils.disposeObject(this._result);
            this._result = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this._selectComposeBtnShine)
         {
            EffectManager.Instance.removeEffect(this._selectComposeBtnShine);
            this._selectComposeBtnShine = null;
         }
      }
   }
}
