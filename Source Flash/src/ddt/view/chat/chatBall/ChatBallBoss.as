package ddt.view.chat.chatBall
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class ChatBallBoss extends ChatBallBase
   {
       
      
      public function ChatBallBoss()
      {
         POP_DELAY = 2000;
         super();
         this.init();
      }
      
      private function init() : void
      {
         _field = new ChatBallTextAreaBoss();
         _field.addEventListener(Event.COMPLETE,this.__onTextDisplayCompleted);
      }
      
      override public function setText(param1:String, param2:int = 0) : void
      {
         clear();
         if(paopaoMC == null)
         {
            this.newPaopao();
         }
         if(param2 == 1)
         {
            (_field as ChatBallTextAreaBoss).animation = false;
         }
         else
         {
            (_field as ChatBallTextAreaBoss).animation = true;
         }
         var _loc3_:int = this.globalToLocal(new Point(500,10)).x;
         _field.x = _loc3_ < 0 ? Number(Number(0)) : Number(Number(_loc3_));
         _field.text = param1;
         fitSize(_field);
         this.show();
      }
      
      override public function show() : void
      {
         super.show();
      }
      
      private function newPaopao() : void
      {
         paopaoMC = ComponentFactory.Instance.creat("ChatBall16000");
         _chatballBackground = new ChatBallBackground(paopaoMC);
         addChild(paopao);
      }
      
      private function __onTextDisplayCompleted(param1:Event) : void
      {
         beginPopDelay();
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
