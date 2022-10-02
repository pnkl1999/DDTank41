package littleGame.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import littleGame.LittleGameManager;
   import littleGame.character.LittleGameCharacter;
   import littleGame.events.LittleGameEvent;
   import littleGame.events.LittleLivingEvent;
   import littleGame.model.LittleSelf;
   
   public class GameLittleSelf extends GameLittlePlayer
   {
       
      
      private var _self:LittleSelf;
      
      public function GameLittleSelf(self:LittleSelf)
      {
         this._self = self;
         super(self);
      }
      
      override protected function createBody() : void
      {
         super.createBody();
         if(_body)
         {
            LittleGameCharacter(_body).soundEnabled = LittleGameManager.Instance.Current.soundEnabled;
         }
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         this._self.addEventListener(LittleLivingEvent.GetScore,this.__getScore);
         LittleGameManager.Instance.Current.addEventListener(LittleGameEvent.SoundEnabledChanged,this.__soundChanged);
      }
      
      private function __soundChanged(event:Event) : void
      {
         if(_body)
         {
            LittleGameCharacter(_body).soundEnabled = LittleGameManager.Instance.Current.soundEnabled;
         }
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._self.removeEventListener(LittleLivingEvent.GetScore,this.__getScore);
         LittleGameManager.Instance.Current.removeEventListener(LittleGameEvent.SoundEnabledChanged,this.__soundChanged);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._self = null;
      }
      
      private function __getScore(event:LittleLivingEvent) : void
      {
         var shape:ScoreShape = null;
         shape = null;
         SoundManager.instance.play("165");
         shape = new ScoreShape();
         shape.setScore(event.paras[0]);
         shape.x = -shape.width >> 1;
         shape.y = -180;
         addChild(shape);
         TweenLite.to(shape,0.3,{
            "delay":1,
            "alpha":0,
            "y":-320,
            "onComplete":ObjectUtils.disposeObject,
            "onCompleteParams":[shape]
         });
      }
   }
}
