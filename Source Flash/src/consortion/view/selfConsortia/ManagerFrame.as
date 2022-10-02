package consortion.view.selfConsortia
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaAssetLevelOffer;
   import consortion.event.ConsortionEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ManagerFrame extends Frame
   {
       
      
      private var _bg:Bitmap;
      
      private var _word:Bitmap;
      
      private var _taxBtn:BaseButton;
      
      private var _okBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      private var _shopLevelTxt1:TextInput;
      
      private var _shopLevelTxt2:TextInput;
      
      private var _shopLevelTxt3:TextInput;
      
      private var _shopLevelTxt4:TextInput;
      
      private var _shopLevelTxt5:TextInput;
      
      private var _smithTxt:TextInput;
      
      private var _skillTxt:TextInput;
      
      private var _valueArray:Array;
      
      public function ManagerFrame()
      {
         this._valueArray = [100,100,100,100,100,100,100];
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.ConsortiaAssetManagerFrame.titleText");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.core.consortionManager.BG");
         this._word = ComponentFactory.Instance.creatBitmap("asset.core.ConsortiaAssetManager.buttomWord");
         this._taxBtn = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.offerBtn");
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.okBtn");
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.cancelBtn");
         this._shopLevelTxt1 = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.shopLevelTxt1");
         this._shopLevelTxt2 = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.shopLevelTxt2");
         this._shopLevelTxt3 = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.shopLevelTxt3");
         this._shopLevelTxt4 = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.shopLevelTxt4");
         this._shopLevelTxt5 = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.shopLevelTxt5");
         this._smithTxt = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.smithTxt");
         this._skillTxt = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.skillTxt");
         addToContent(this._bg);
         addToContent(this._word);
         addToContent(this._taxBtn);
         addToContent(this._okBtn);
         addToContent(this._cancelBtn);
         addToContent(this._shopLevelTxt1);
         addToContent(this._shopLevelTxt2);
         addToContent(this._shopLevelTxt3);
         addToContent(this._shopLevelTxt4);
         addToContent(this._shopLevelTxt5);
         addToContent(this._smithTxt);
         addToContent(this._skillTxt);
         this._okBtn.text = LanguageMgr.GetTranslation("ok");
         this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
         if(PlayerManager.Instance.Self.DutyLevel == 1)
         {
            this.inputText(this._shopLevelTxt1);
            this.inputText(this._shopLevelTxt2);
            this.inputText(this._shopLevelTxt3);
            this.inputText(this._shopLevelTxt4);
            this.inputText(this._shopLevelTxt5);
            this.inputText(this._smithTxt);
            this.inputText(this._skillTxt);
         }
         else
         {
            this.DynamicText(this._shopLevelTxt1);
            this.DynamicText(this._shopLevelTxt2);
            this.DynamicText(this._shopLevelTxt3);
            this.DynamicText(this._shopLevelTxt4);
            this.DynamicText(this._shopLevelTxt5);
            this.DynamicText(this._smithTxt);
            this.DynamicText(this._skillTxt);
         }
         this._shopLevelTxt1.text = "100";
         this._shopLevelTxt2.text = "100";
         this._shopLevelTxt3.text = "100";
         this._shopLevelTxt4.text = "100";
         this._shopLevelTxt5.text = "100";
         this._smithTxt.text = "100";
         this._skillTxt.text = "100";
      }
      
      private function inputText(param1:TextInput) : void
      {
         param1.textField.restrict = "0-9";
         param1.textField.maxChars = 8;
         param1.mouseChildren = true;
         param1.mouseEnabled = true;
         param1.textField.selectable = true;
      }
      
      private function DynamicText(param1:TextInput) : void
      {
         param1.textField.selectable = false;
         param1.mouseEnabled = false;
         param1.mouseChildren = false;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__okHandler);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._taxBtn.addEventListener(MouseEvent.CLICK,this.__taxHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.USE_CONDITION_CHANGE,this.__conditionChangeHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__okHandler);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._taxBtn.removeEventListener(MouseEvent.CLICK,this.__taxHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.USE_CONDITION_CHANGE,this.__conditionChangeHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __okHandler(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked && this.checkChange())
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.DutyLevel == 1)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.ConsortiaAssetManagerFrame.okFunction"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         }
         else
         {
            this.dispose();
         }
      }
      
      private function checkChange() : Boolean
      {
         var _loc1_:int = this.checkInputValue(this._shopLevelTxt1);
         var _loc2_:int = this.checkInputValue(this._shopLevelTxt2);
         var _loc3_:int = this.checkInputValue(this._shopLevelTxt3);
         var _loc4_:int = this.checkInputValue(this._shopLevelTxt4);
         var _loc5_:int = this.checkInputValue(this._shopLevelTxt5);
         var _loc6_:int = this.checkInputValue(this._smithTxt);
         var _loc7_:int = this.checkInputValue(this._skillTxt);
         var _loc8_:Array = [_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_];
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         while(_loc10_ < 7)
         {
            if(this._valueArray[_loc10_] != _loc8_[_loc10_])
            {
               _loc9_ = true;
            }
            _loc10_++;
         }
         return _loc9_;
      }
      
      private function __alertResponse(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         if((param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK) && this.checkChange())
         {
            _loc2_ = this.checkInputValue(this._shopLevelTxt1);
            _loc3_ = this.checkInputValue(this._shopLevelTxt2);
            _loc4_ = this.checkInputValue(this._shopLevelTxt3);
            _loc5_ = this.checkInputValue(this._shopLevelTxt4);
            _loc6_ = this.checkInputValue(this._shopLevelTxt5);
            _loc7_ = this.checkInputValue(this._smithTxt);
            _loc8_ = this.checkInputValue(this._skillTxt);
            _loc9_ = [_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_];
            SocketManager.Instance.out.sendConsortiaEquipConstrol(_loc9_);
         }
      }
      
      private function checkInputValue(param1:TextInput) : int
      {
         if(param1.text == "")
         {
            return 0;
         }
         return int(param1.text);
      }
      
      private function __cancelHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __taxHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ConsortionModelControl.Instance.alertTaxFrame();
      }
      
      private function __conditionChangeHandler(param1:ConsortionEvent) : void
      {
         var _loc2_:Vector.<ConsortiaAssetLevelOffer> = ConsortionModelControl.Instance.model.useConditionList;
         var _loc3_:int = _loc2_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc2_[_loc4_].Type == 1)
            {
               switch(_loc2_[_loc4_].Level)
               {
                  case 1:
                     this._shopLevelTxt1.text = this._valueArray[0] = String(_loc2_[_loc4_].Riches);
                     break;
                  case 2:
                     this._shopLevelTxt2.text = this._valueArray[1] = String(_loc2_[_loc4_].Riches);
                     break;
                  case 3:
                     this._shopLevelTxt3.text = this._valueArray[2] = String(_loc2_[_loc4_].Riches);
                     break;
                  case 4:
                     this._shopLevelTxt4.text = this._valueArray[3] = String(_loc2_[_loc4_].Riches);
                     break;
                  case 5:
                     this._shopLevelTxt5.text = this._valueArray[4] = String(_loc2_[_loc4_].Riches);
               }
            }
            else if(_loc2_[_loc4_].Type == 2)
            {
               this._smithTxt.text = this._valueArray[5] = String(_loc2_[_loc4_].Riches);
            }
            else if(_loc2_[_loc4_].Type == 3)
            {
               this._skillTxt.text = this._valueArray[6] = String(_loc2_[_loc4_].Riches);
            }
            _loc4_++;
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._word = null;
         this._taxBtn = null;
         this._okBtn = null;
         this._cancelBtn = null;
         this._shopLevelTxt1 = null;
         this._shopLevelTxt2 = null;
         this._shopLevelTxt3 = null;
         this._shopLevelTxt4 = null;
         this._shopLevelTxt5 = null;
         this._smithTxt = null;
         this._skillTxt = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
