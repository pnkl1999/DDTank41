package ddt.view.chat.chatBall
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   
   public class ChatBallTextAreaBuff extends ChatBallTextAreaBase
   {
       
      
      private var _movie:MovieClip;
      
      public function ChatBallTextAreaBuff()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this._movie = ComponentFactory.Instance.creat("tank.view.ChatTextfieldAsset");
         tf = null;
         tf = this._movie["tf"];
         tf.wordWrap = false;
         tf.autoSize = TextFieldAutoSize.LEFT;
         tf.multiline = false;
         tf.x = 0;
         tf.y = 0;
         addChild(tf);
      }
      
      override public function set text(param1:String) : void
      {
         clear();
         _text = param1;
         tf.text = _text;
         tf.width = tf.textWidth;
         tf.height = tf.textHeight;
      }
      
      override public function dispose() : void
      {
         this._movie = null;
         super.dispose();
      }
   }
}
