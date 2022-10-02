package ddt.view.chat.chatBall
{
   import flash.text.StyleSheet;
   import flash.text.TextFieldAutoSize;
   import road7th.utils.StringHelper;
   
   public class ChatBallTextAreaNPC extends ChatBallTextAreaBase
   {
       
      
      private var _plainString:String;
      
      protected const maxTxtWidth:int = 140;
      
      public function ChatBallTextAreaNPC()
      {
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
      }
      
      override public function set text(param1:String) : void
      {
         clear();
         _text = param1;
         _text = "<p>" + _text + "</p>";
         this._plainString = StringHelper.rePlaceHtmlTextField(_text);
         this.setFormat();
         tf.autoSize = TextFieldAutoSize.LEFT;
         tf.width = this.maxTxtWidth;
         tf.htmlText = _text;
         this.fitScale();
      }
      
      protected function setFormat() : void
      {
         var _loc1_:StyleSheet = new StyleSheet();
         _loc1_.parseCSS("p{font-size:12px;text-align:center;font-weight:normal;}" + ".red{color:#FF0000}" + ".blue{color:#0000FF}" + ".green{color:#00FF00}");
         tf.styleSheet = _loc1_;
      }
      
      protected function fitScale() : void
      {
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:int = tf.numLines;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = tf.getLineLength(_loc3_);
            if(_loc1_ < _loc4_)
            {
               _loc1_ = _loc4_;
            }
            _loc3_++;
         }
         if(_loc1_ < 8)
         {
            tf.width = _loc1_ * 17;
         }
         else
         {
            tf.width = this.maxTxtWidth;
         }
      }
   }
}
