package email.view
{
   import com.pickgliss.ui.controls.Frame;
   import ddt.manager.SoundManager;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class BaseEmailRightView extends Frame
   {
       
      
      protected var _sender:TextField;
      
      protected var _topic:TextField;
      
      protected var _ta:TextField;
      
      public function BaseEmailRightView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      protected function initView() : void
      {
         this._sender = new TextField();
         this._sender.maxChars = 36;
         this._sender.defaultTextFormat = new TextFormat("Arial",12,0);
         this._topic = new TextField();
         this._topic.maxChars = 22;
         this._topic.defaultTextFormat = new TextFormat("Arial",12,0);
         this._ta = new TextField();
      }
      
      protected function addEvent() : void
      {
      }
      
      protected function removeEvent() : void
      {
      }
      
      protected function btnSound() : void
      {
         SoundManager.instance.play("043");
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._sender.parent)
         {
            this._sender.parent.removeChild(this._sender);
         }
         this._sender = null;
         if(this._topic.parent)
         {
            this._topic.parent.removeChild(this._topic);
         }
         this._topic = null;
         if(this._ta.parent)
         {
            this._ta.parent.removeChild(this._ta);
         }
         this._ta = null;
      }
   }
}
