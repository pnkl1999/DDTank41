package ddt.view.chat.chatBall
{
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class ChatBallTextAreaPlayer extends ChatBallTextAreaBase
   {
       
      
      private const _SMALL_W:int = 80;
      
      private const _MIDDLE_W:int = 100;
      
      private const _BIG_H:int = 70;
      
      private const _BIG_W:int = 120;
      
      protected var hiddenTF:TextField;
      
      private var _textWidth:int;
      
      private var _indexOfEnd:int;
      
      public function ChatBallTextAreaPlayer()
      {
         super();
      }
      
      override protected function initView() : void
      {
         tf.filters = [new GlowFilter(16777215,1,2,2,10)];
         tf.autoSize = TextFieldAutoSize.LEFT;
         tf.multiline = true;
         tf.wordWrap = true;
         addChild(tf);
         tf.x = 0;
         tf.y = 0;
      }
      
      override public function set text(param1:String) : void
      {
         tf.htmlText = param1;
         param1 = tf.text;
         this.chooseSize(param1);
         tf.text = param1;
         tf.width = this._textWidth;
         if(tf.height >= this._BIG_H)
         {
            tf.height = this._BIG_H;
         }
         this._indexOfEnd = 0;
         if(tf.numLines > 4)
         {
            this._indexOfEnd = tf.getLineOffset(4) - 3;
            param1 = param1.substring(0,this._indexOfEnd) + "...";
         }
         tf.text = param1;
      }
      
      protected function chooseSize(param1:String) : void
      {
         this._indexOfEnd = -1;
         var _loc2_:TextFormat = tf.defaultTextFormat;
         this.hiddenTF = new TextField();
         this.setTextField(this.hiddenTF);
         _loc2_.letterSpacing = 1;
         this.hiddenTF.defaultTextFormat = _loc2_;
         _loc2_.align = TextFormatAlign.CENTER;
         tf.defaultTextFormat = _loc2_;
         this.hiddenTF.text = param1;
         var _loc3_:int = this.hiddenTF.textWidth;
         if(_loc3_ < this._SMALL_W)
         {
            this._textWidth = this._SMALL_W;
            return;
         }
         if(_loc3_ < this._SMALL_W * 2 + 10)
         {
            this._textWidth = this._MIDDLE_W;
            return;
         }
         this._textWidth = this._BIG_W;
      }
      
      override public function get width() : Number
      {
         return tf.width;
      }
      
      override public function get height() : Number
      {
         return tf.height;
      }
      
      public function setTextField(param1:TextField) : void
      {
         param1.autoSize = TextFieldAutoSize.LEFT;
      }
      
      override public function dispose() : void
      {
         this.hiddenTF = null;
      }
   }
}
