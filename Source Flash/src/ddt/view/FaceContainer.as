package ddt.view
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class FaceContainer extends Sprite
   {
       
      
      private var _face:MovieClip;
      
      private var _oldScale:int;
      
      private var _isActingExpression:Boolean;
      
      private var _nickName:TextField;
      
      private var _expressionID:int;
      
      public function FaceContainer(param1:Boolean = false)
      {
         super();
         this.init();
      }
      
      public function get nickName() : TextField
      {
         return this._nickName;
      }
      
      public function get expressionID() : int
      {
         return this._expressionID;
      }
      
      public function set isShowNickName(param1:Boolean) : void
      {
         if(param1)
         {
            this._nickName.y = this._face.y - 20 - this._face.height / 2;
            this._nickName.x = -this._face.width / 2;
            this._nickName.visible = true;
         }
         else
         {
            this._nickName.y = 0;
            this._nickName.x = 0;
            this._nickName.visible = false;
         }
      }
      
      public function get isActingExpression() : Boolean
      {
         return this._isActingExpression;
      }
      
      public function setNickName(param1:String) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._nickName.text = param1 + ":";
         this.addChild(this._nickName);
         this._nickName.visible = false;
      }
      
      private function init() : void
      {
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.color = "0xff0000";
         this._nickName = new TextField();
         this._nickName.defaultTextFormat = _loc1_;
      }
      
      private function __timerComplete(param1:TimerEvent) : void
      {
         this.clearFace();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function clearFace() : void
      {
         if(this._face != null)
         {
            if(this._face.parent)
            {
               this._face.stop();
               this._face.parent.removeChild(this._face);
            }
            this._face.removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
            this._face = null;
            this._nickName.visible = false;
         }
      }
      
      public function setFace(param1:int) : void
      {
         if(this._oldScale == 0)
         {
            this._oldScale = scaleX;
         }
         this.clearFace();
         this._face = FaceSource.getFaceById(param1);
         this._expressionID = param1;
         if(this._face != null)
         {
            this._isActingExpression = true;
            if(param1 == 42)
            {
               this.scaleX = 1;
               this._face.scaleX = 1;
            }
            else
            {
               scaleX = this._oldScale;
            }
            this._face.addEventListener(Event.ENTER_FRAME,this.__enterFrame);
            addChild(this._face);
         }
      }
      
      public function doClearFace() : void
      {
         this._isActingExpression = false;
         this.clearFace();
      }
      
      private function __enterFrame(param1:Event) : void
      {
         if(this._face.currentFrame >= this._face.totalFrames)
         {
            this._isActingExpression = false;
            this.clearFace();
         }
      }
      
      public function dispose() : void
      {
         this.clearFace();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
