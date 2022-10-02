package littleGame.view
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   import littleGame.model.LittleSelf;
   
   public class ClickGame extends Sprite implements Disposeable
   {
       
      
      private var _clickTextField:TextField;
      
      private var _startTime:int;
      
      private var _clickCount:int = 0;
      
      private var _self:LittleSelf;
      
      private var _asset:MovieClip;
      
      public function ClickGame()
      {
         super();
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         var text:TextField = null;
         text = null;
         var pen:Graphics = graphics;
         pen.beginFill(0,0);
         pen.drawRect(0,0,StageReferance.stageWidth,StageReferance.stageHeight);
         pen.endFill();
         text = new TextField();
         text.defaultTextFormat = new TextFormat("Arial",20,65280,true);
         text.autoSize = "left";
         text.text = "Click Screen!!!";
         text.mouseEnabled = false;
         text.x = StageReferance.stageWidth - text.width >> 1;
         addChild(text);
         this._clickTextField = new TextField();
         this._clickTextField.defaultTextFormat = new TextFormat("Arial",20,16711680,true);
         this._clickTextField.autoSize = "left";
         this._clickTextField.mouseEnabled = false;
         addChild(this._clickTextField);
         var cls:Class = getDefinitionByName("littlegame.object.normalBoguInhaled") as Class;
         this._asset = new cls() as MovieClip;
         addChild(this._asset);
      }
      
      private function addEvent() : void
      {
      }
      
      private function __shutdown(event:Event) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
         this.dispose();
      }
      
      private function __startup(event:Event) : void
      {
         this._startTime = getTimer();
         addEventListener(MouseEvent.CLICK,this.__clicked);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__clicked);
      }
      
      private function __clicked(event:MouseEvent) : void
      {
         var now:int = getTimer();
         ++this._clickCount;
         this._clickTextField.text = "click:" + this._clickCount;
         this._clickTextField.x = StageReferance.stageWidth - this._clickTextField.width >> 1;
         this._clickTextField.y = StageReferance.stageHeight - this._clickTextField.height >> 1;
         if(this._asset["water"].totalFrames >= this._asset["water"].currentFrame + 2)
         {
            this._asset["water"].gotoAndStop(this._asset["water"].currentFrame + 4);
         }
         else
         {
            this._asset["water"].gotoAndStop(this._asset["water"].totalFrames);
         }
         this._asset.play();
         this.__shutdown(null);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
