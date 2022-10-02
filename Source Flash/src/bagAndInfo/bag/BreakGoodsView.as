package bagAndInfo.bag
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   
   public class BreakGoodsView extends BaseAlerFrame
   {
      
      private static const EnterKeyCode:int = 13;
      
      private static const ESCkeyCode:int = 27;
       
      
      private var _input:FilterFrameText;
      
      private var _NumString:FilterFrameText;
      
      private var _tipString:FilterFrameText;
      
      private var _inputBG:Bitmap;
      
      private var _cell:BagCell;
      
      public function BreakGoodsView()
      {
         super();
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.split");
         info = _loc1_;
         this._input = ComponentFactory.Instance.creatComponentByStylename("breakGoodsInput");
         this._inputBG = ComponentFactory.Instance.creatBitmap("asset.core.bg007");
         this._inputBG.x = this._input.x - 1;
         this._inputBG.y = this._input.y - 2;
         addToContent(this._inputBG);
         addToContent(this._input);
         this._NumString = ComponentFactory.Instance.creatComponentByStylename("breakGoodsNumText");
         this._NumString.text = LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.num");
         addToContent(this._NumString);
         this._tipString = ComponentFactory.Instance.creatComponentByStylename("breakGoodsPleasEnterText");
         this._tipString.text = LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.input");
         addToContent(this._tipString);
         submitButtonEnable = false;
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._input.addEventListener(Event.CHANGE,this.__input);
         this._input.addEventListener(KeyboardEvent.KEY_UP,this.__onInputKeyUp);
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         addEventListener(Event.ADDED_TO_STAGE,this.__onToStage);
      }
      
      private function __onToStage(param1:Event) : void
      {
         this.__getFocus(null);
      }
      
      private function __onInputKeyUp(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case EnterKeyCode:
               this.okFun();
               break;
            case ESCkeyCode:
               this.dispose();
         }
      }
      
      private function __getFocus(param1:Event) : void
      {
         this._input.setFocus();
      }
      
      private function removeEvent() : void
      {
         if(this._input)
         {
            this._input.removeEventListener(Event.CHANGE,this.__input);
            this._input.removeEventListener(KeyboardEvent.KEY_UP,this.__onInputKeyUp);
         }
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         removeEventListener(Event.ADDED_TO_STAGE,this.__onToStage);
      }
      
      private function __input(param1:Event) : void
      {
         submitButtonEnable = this._input.text != "";
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __okClickCall(param1:ComponentEvent) : void
      {
         this.okFun();
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.okFun();
         }
      }
      
      private function getFocus() : void
      {
         if(stage)
         {
            stage.focus = this._input;
         }
      }
      
      private function okFun() : void
      {
         SoundManager.instance.play("008");
         var _loc1_:int = int(this._input.text);
         if(_loc1_ > 0 && _loc1_ < this._cell.itemInfo.Count)
         {
            this._cell.dragCountStart(_loc1_);
            this.dispose();
         }
         else if(_loc1_ == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.wrong2"));
            this._input.text = "";
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.right"));
            this._input.text = "";
         }
      }
      
      override public function dispose() : void
      {
         SoundManager.instance.play("008");
         this.removeEvent();
         ObjectUtils.disposeObject(this._inputBG);
         this._inputBG = null;
         ObjectUtils.disposeObject(this._input);
         this._input = null;
         ObjectUtils.disposeObject(this._NumString);
         this._NumString = null;
         ObjectUtils.disposeObject(this._tipString);
         this._tipString = null;
         this._cell = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
      
      public function get cell() : BagCell
      {
         return this._cell;
      }
      
      public function set cell(param1:BagCell) : void
      {
         this._cell = param1;
      }
   }
}
