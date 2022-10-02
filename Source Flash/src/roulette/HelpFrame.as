package roulette
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class HelpFrame extends Frame
   {
       
      
      private var _view:Sprite;
      
      private var _submitButton:TextButton;
      
      public function HelpFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._view = new Sprite();
         this._submitButton = ComponentFactory.Instance.creat("roulette.helpFrameEnter");
         this._submitButton.text = LanguageMgr.GetTranslation("ok");
         this._view.addChild(this._submitButton);
         addToContent(this._view);
         escEnable = true;
         enterEnable = true;
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._submitButton.addEventListener(MouseEvent.CLICK,this._submit);
      }
      
      public function setView(param1:DisplayObject) : void
      {
         this._view.addChild(param1);
      }
      
      private function _submit(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.dispose();
         }
      }
      
      public function set submitButtonPos(param1:String) : void
      {
         PositionUtils.setPos(this._submitButton,param1);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this._response);
         if(this._submitButton)
         {
            this._submitButton.removeEventListener(MouseEvent.CLICK,this._submit);
            ObjectUtils.disposeObject(this._submitButton);
         }
         this._submitButton = null;
         if(this._view)
         {
            ObjectUtils.disposeAllChildren(this._view);
         }
         this._view = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
