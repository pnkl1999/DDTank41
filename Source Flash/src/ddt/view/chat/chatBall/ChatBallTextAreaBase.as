package ddt.view.chat.chatBall
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class ChatBallTextAreaBase extends MovieClip
   {
       
      
      protected var _text:String;
      
      protected var tf:TextField;
      
      public function ChatBallTextAreaBase()
      {
         super();
         this.tf = new TextField();
         this.tf.multiline = true;
         this.tf.mouseEnabled = false;
         this.tf.wordWrap = true;
         this.initView();
      }
      
      protected function initView() : void
      {
         addChild(this.tf);
      }
      
      public function set text(param1:String) : void
      {
         this.clear();
         this._text = param1;
         this.tf.text = this._text;
      }
      
      public function set format(param1:TextFormat) : void
      {
         this.tf.defaultTextFormat = param1;
      }
      
      protected function clear() : void
      {
         this._text = "";
         this.tf.text = "";
      }
      
      public function drawEdge() : void
      {
         graphics.clear();
         graphics.moveTo(this.tf.x,this.tf.y);
         graphics.lineStyle(1,16763921);
         graphics.lineTo(this.tf.x + this.tf.width,this.tf.y);
         graphics.lineTo(this.tf.x + this.tf.width,this.tf.y + this.tf.height);
         graphics.lineTo(this.tf.x,this.tf.y + this.tf.height);
         graphics.lineTo(this.tf.x,this.tf.y);
      }
      
      public function dispose() : void
      {
         this.tf = null;
      }
   }
}
