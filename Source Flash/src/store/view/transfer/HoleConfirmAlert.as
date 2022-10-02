package store.view.transfer
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   
   public class HoleConfirmAlert extends BaseAlerFrame
   {
       
      
      private var _state1:Boolean;
      
      private var _state2:Boolean;
      
      private var _beforeCheck:SelectedCheckButton;
      
      private var _afterCheck:SelectedCheckButton;
      
      private var _textField:FilterFrameText;
      
      public function HoleConfirmAlert(param1:int, param2:int)
      {
         super();
         var _loc3_:AlertInfo = new AlertInfo();
         _loc3_.submitLabel = LanguageMgr.GetTranslation("ok");
         _loc3_.cancelLabel = LanguageMgr.GetTranslation("cancel");
         _loc3_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         this.info = _loc3_;
         this.addEvent();
         if(param1 == -1)
         {
            this._beforeCheck.enable = false;
         }
         else
         {
            this._beforeCheck.selected = param1 == 1 ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         }
         if(param2 == -1)
         {
            this._afterCheck.enable = false;
         }
         else
         {
            this._afterCheck.selected = param2 == 1 ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         }
      }
      
      override protected function init() : void
      {
         super.init();
         this._beforeCheck = ComponentFactory.Instance.creatComponentByStylename("store.transfer.HoleBeforeCheck");
         addToContent(this._beforeCheck);
         this._afterCheck = ComponentFactory.Instance.creatComponentByStylename("store.transfer.HoleAfterCheck");
         addToContent(this._afterCheck);
         this._textField = ComponentFactory.Instance.creatComponentByStylename("store.transfer.HoleTipLabel");
         this._textField.htmlText = LanguageMgr.GetTranslation("store.view.transfer.HoleLabel");
         addToContent(this._textField);
      }
      
      private function addEvent() : void
      {
         this._beforeCheck.addEventListener(Event.SELECT,this.__selectChanged);
         this._afterCheck.addEventListener(Event.SELECT,this.__selectChanged);
      }
      
      private function __selectChanged(param1:Event) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:SelectedCheckButton = param1.currentTarget as SelectedCheckButton;
         if(_loc2_ == this._beforeCheck)
         {
            this._state1 = this._beforeCheck.selected;
         }
         else if(_loc2_ == this._afterCheck)
         {
            this._state2 = this._beforeCheck.selected;
         }
      }
      
      private function removeEvent() : void
      {
         this._beforeCheck.removeEventListener(Event.SELECT,this.__selectChanged);
         this._afterCheck.removeEventListener(Event.SELECT,this.__selectChanged);
      }
      
      public function get state1() : Boolean
      {
         return this._beforeCheck.enable && this._beforeCheck.selected;
      }
      
      public function get state2() : Boolean
      {
         return this._afterCheck.enable && this._afterCheck.selected;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._beforeCheck)
         {
            ObjectUtils.disposeObject(this._beforeCheck);
            this._beforeCheck = null;
         }
         if(this._afterCheck)
         {
            ObjectUtils.disposeObject(this._afterCheck);
            this._afterCheck = null;
         }
         if(this._textField)
         {
            ObjectUtils.disposeObject(this._textField);
            this._textField = null;
         }
         super.dispose();
      }
   }
}
