package guildMemberWeek.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class GuildMemberWeekHelpFrame extends Frame
   {
       
      
      private var _view:Sprite;
      
      private var _submitButton:TextButton;
      
      public function GuildMemberWeekHelpFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._view = new Sprite();
         this._submitButton = ComponentFactory.Instance.creat("ddtstore.HelpFrame.EnterBtn");
         this._submitButton.text = LanguageMgr.GetTranslation("ok");
         this._submitButton.y = 400;
         this._view.addChild(this._submitButton);
         addToContent(this._view);
         escEnable = true;
         enterEnable = false;
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._submitButton.addEventListener(MouseEvent.CLICK,this._submit);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._submitButton.removeEventListener(MouseEvent.CLICK,this._submit);
      }
      
      public function setView(param1:DisplayObject) : void
      {
         this._view.addChild(param1);
      }
      
      private function _submit(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.close();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.close();
         }
      }
      
      private function close() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         ObjectUtils.disposeObject(this._view);
         ObjectUtils.disposeObject(this);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(this._submitButton)
         {
            ObjectUtils.disposeObject(this._submitButton);
            this._submitButton = null;
         }
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
