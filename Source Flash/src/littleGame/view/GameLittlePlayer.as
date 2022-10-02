package littleGame.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.view.FaceContainer;
   import ddt.view.chat.ChatEvent;
   import flash.events.Event;
   import littleGame.character.LittleGameCharacter;
   import littleGame.events.LittleLivingEvent;
   import littleGame.model.LittlePlayer;
   
   public class GameLittlePlayer extends GameLittleLiving
   {
       
      
      private var _facecontainer:FaceContainer;
      
      protected var _nameField:PlayerNameField;
      
      public function GameLittlePlayer(player:LittlePlayer)
      {
         super(player);
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE,this.__getFace);
         _living.addEventListener(LittleLivingEvent.HeadChanged,this.__headChanged);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE,this.__getFace);
         if(this._facecontainer)
         {
            this._facecontainer.removeEventListener(Event.COMPLETE,this.onFaceComplete);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._nameField);
         this._nameField = null;
         ObjectUtils.disposeObject(this._facecontainer);
         this._facecontainer = null;
      }
      
      private function __getFace(evt:ChatEvent) : void
      {
         var id:int = 0;
         var delay:int = 0;
         var data:Object = evt.data;
         if(data["playerid"] == this.player.playerInfo.ID)
         {
            id = data["faceid"];
            delay = data["delay"];
            this.showFace(id);
         }
      }
      
      private function onFaceComplete(event:Event) : void
      {
         if(this._facecontainer && contains(this._facecontainer))
         {
            removeChild(this._facecontainer);
         }
      }
      
      private function showFace(id:int) : void
      {
         if(this._facecontainer == null)
         {
            this._facecontainer = new FaceContainer();
            this._facecontainer.addEventListener(Event.COMPLETE,this.onFaceComplete);
            this._facecontainer.y = -100;
         }
         addChild(this._facecontainer);
         this._facecontainer.scaleX = 1;
         this._facecontainer.setFace(id);
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._nameField = ComponentFactory.Instance.creatCustomObject("littleGame.PlayerName",[this.player.playerInfo]);
         this._nameField.x = -this._nameField.width >> 1;
         addChild(this._nameField);
      }
      
      override protected function createBody() : void
      {
         var ch:LittleGameCharacter = new LittleGameCharacter(this.player.playerInfo);
         ch.soundEnabled = false;
         ch.addEventListener(Event.COMPLETE,this.onComplete);
         _body = addChild(ch);
         __directionChanged(null);
         if(_living.currentAction)
         {
            LittleGameCharacter(_body).doAction(_living.currentAction);
         }
         else
         {
            LittleGameCharacter(_body).doAction("stand");
         }
      }
      
      private function onComplete(event:Event) : void
      {
         var ch:LittleGameCharacter = null;
         ch = null;
         ch = event.currentTarget as LittleGameCharacter;
         ch.removeEventListener(Event.COMPLETE,this.onComplete);
         ch.x = -ch.registerPoint.x;
         ch.y = -ch.registerPoint.y;
         __directionChanged(null);
      }
      
      override protected function centerBody() : void
      {
         var ch:LittleGameCharacter = _body as LittleGameCharacter;
         if(_body && ch)
         {
            _body.x = _body.scaleX == 1 ? Number(Number(-ch.registerPoint.x)) : Number(Number(ch.registerPoint.x));
         }
      }
      
      override protected function __doAction(event:LittleLivingEvent) : void
      {
         if(_body)
         {
            LittleGameCharacter(_body).doAction(_living.currentAction);
         }
      }
      
      protected function __headChanged(event:LittleLivingEvent) : void
      {
         LittleGameCharacter(_body).setFunnyHead(int(event.paras[0]));
      }
      
      protected function get player() : LittlePlayer
      {
         return _living as LittlePlayer;
      }
   }
}
