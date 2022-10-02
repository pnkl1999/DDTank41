package farm.viewx.helper
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   
   public class HelperBeginFrame extends BaseAlerFrame
   {
       
      
      private var _explainText:FilterFrameText;
      
      private var _explainText2:FilterFrameText;
      
      private var _explainText3:FilterFrameText;
      
      private var _bgTitle:DisplayObject;
      
      public var modelType:int;
      
      private var _seedID:int;
      
      private var _seedTime:int;
      
      private var _needCount:int;
      
      private var _haveCount:int;
      
      private var _getCount:int;
      
      private var _needMoney:int;
      
      private var _moneyType:int;
      
      private var _moneyTypeText:String;
      
      private var _ifNeed:Boolean;
      
      private var _isDDTMoney:Boolean = false;
      
      private var _showPayMoneyBG:Image;
      
      private var _money:int;
      
      private var _outFun:Function;
      
      public function HelperBeginFrame()
      {
         super();
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.escEnable = true;
         _loc1_.title = LanguageMgr.GetTranslation("ddt.farm.beginFrame.title");
         _loc1_.bottomGap = 37;
         _loc1_.buttonGape = 90;
         _loc1_.customPos = ComponentFactory.Instance.creat("farm.confirmHelperBeginAlertBtnPos");
         this.info = _loc1_;
         height = 250;
         this._needCount = 0;
         this._ifNeed = false;
         this.intView();
         this.intEvent();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         if(this.modelType == 2 || this.modelType == 3)
         {
            if(this._needCount > 0)
            {
               this._explainText.text = LanguageMgr.GetTranslation("ddt.farm.beginFrame.expText1",this._needCount,this._needMoney);
               this._explainText.text += this._moneyTypeText;
               this._explainText3.x = 57;
               this._explainText3.y = 75;
               this._explainText2.x = 105;
               this._explainText2.y = 50;
               PositionUtils.setPos(this._explainText,"farm.helperBeginExplainPos2");
               _submitButton.y = 102;
               _cancelButton.y = 102;
               addToContent(this._explainText2);
            }
            else
            {
               this._explainText3.x = 57;
               this._explainText3.y = 75;
               _submitButton.y = 102;
               _cancelButton.y = 102;
            }
            return;
         }
         if(this._needCount > 0)
         {
            this._explainText.text = LanguageMgr.GetTranslation("ddt.farm.beginFrame.expText1",this._needCount,this._needMoney);
            this._explainText.text += this._moneyTypeText;
            this._explainText2.x = 106;
            this._explainText2.y = 50;
            this._explainText3.x = 55;
            this._explainText3.y = 75;
            PositionUtils.setPos(this._explainText,"farm.helperBeginExplainPos2");
            _submitButton.y = 102;
            _cancelButton.y = 102;
            addToContent(this._explainText2);
         }
         else
         {
            _submitButton.y = 102;
            _cancelButton.y = 102;
         }
      }
      
      private function intView() : void
      {
         this._bgTitle = ComponentFactory.Instance.creat("assets.farm.titleSmall");
         PositionUtils.setPos(this._bgTitle,"farm.HelperBeginTitlePos");
         addChild(this._bgTitle);
         this._explainText = ComponentFactory.Instance.creatComponentByStylename("assets.farm.beginFrame.explainText");
         this._explainText.text = LanguageMgr.GetTranslation("ddt.farm.beginFrame.expText");
         PositionUtils.setPos(this._explainText,"farm.helperBeginExplainPos1");
         addToContent(this._explainText);
         this._explainText2 = ComponentFactory.Instance.creatComponentByStylename("assets.farm.beginFrame.explainText2");
         this._explainText2.text = LanguageMgr.GetTranslation("ddt.farm.beginFrame.expText2");
         this._explainText3 = ComponentFactory.Instance.creatComponentByStylename("assets.farm.beginFrame.explainText3");
         this._explainText3.text = LanguageMgr.GetTranslation("ddt.farm.beginFrame.expText3");
         addToContent(this._explainText3);
      }
      
      private function intEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
      }
      
      protected function __framePesponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.submit();
               break;
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
               this.dispose();
               break;
            case FrameEvent.CANCEL_CLICK:
               removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
               this.dispose();
         }
      }
      
      private function submit() : void
      {
         var _loc1_:int = 0;
         if(this.modelType == 1 || this.modelType == 0)
         {
            _loc1_ = PlayerManager.Instance.Self.Money;
            if(_loc1_ - this._needMoney < 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.madelLack"));
               this.dispose();
               return;
            }
         }
         else if(_isBand)
         {
            _loc1_ = PlayerManager.Instance.Self.Gift;
            if(_loc1_ - this._needMoney < 0)
            {
               _isBand = false;
            }
         }
         else if(this.modelType == 2 || this.modelType == 4)
         {
            if(this.checkMoney(false,this._needMoney))
            {
               return;
            }
            _isBand = false;
         }
         var _loc2_:Array = new Array();
         _loc2_.push(true);
         _loc2_.push(this._seedID);
         _loc2_.push(this._seedTime);
         _loc2_.push(this._haveCount);
         _loc2_.push(this._getCount);
         _loc2_.push(this._moneyType);
         _loc2_.push(this._needMoney);
         _loc2_.push(_isBand);
         SocketManager.Instance.out.sendBeginHelper(_loc2_);
         this.dispose();
      }
      
      public function checkMoney(param1:Boolean, param2:int, param3:Function = null) : Boolean
      {
         this._money = param2;
         this._outFun = param3;
         if(PlayerManager.Instance.Self.Money < param2)
         {
            LeavePageManager.showFillFrame();
            return true;
         }
         return false;
      }
      
      private function __poorManResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      private function removeEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
      }
      
      private function removeView() : void
      {
         if(this._explainText)
         {
            ObjectUtils.disposeObject(this._explainText);
         }
         this._explainText = null;
      }
      
      public function get seedID() : int
      {
         return this._seedID;
      }
      
      public function set seedID(param1:int) : void
      {
         this._seedID = param1;
      }
      
      public function get seedTime() : int
      {
         return this._seedTime;
      }
      
      public function set seedTime(param1:int) : void
      {
         this._seedTime = param1;
      }
      
      public function get needCount() : int
      {
         return this._needCount;
      }
      
      public function set needCount(param1:int) : void
      {
         var _loc4_:int = 0;
         this._needCount = param1;
         var _loc2_:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_SEED_TYPE);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_].TemplateID;
            if(this._seedID == _loc4_)
            {
               this._needMoney = this._needCount * _loc2_[_loc3_].AValue1;
               this._moneyType = _loc2_[_loc3_].APrice1;
               if(this._needCount * _loc2_[_loc3_].getItemPrice(1).giftValue > 0)
               {
                  this._isDDTMoney = true;
                  this._moneyTypeText = LanguageMgr.GetTranslation("ddtMoney");
               }
               if(this._needCount * _loc2_[_loc3_].getItemPrice(1).moneyValue > 0)
               {
                  this._isDDTMoney = false;
                  this._moneyTypeText = LanguageMgr.GetTranslation("money");
               }
            }
            _loc3_++;
         }
      }
      
      public function get haveCount() : int
      {
         return this._haveCount;
      }
      
      public function set haveCount(param1:int) : void
      {
         this._haveCount = param1;
      }
      
      public function get getCount() : int
      {
         return this._getCount;
      }
      
      public function set getCount(param1:int) : void
      {
         this._getCount = param1;
      }
      
      override public function dispose() : void
      {
         this.removeView();
         this.removeEvent();
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
