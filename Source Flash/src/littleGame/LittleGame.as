package littleGame
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.manager.ChatManager;
   import ddt.manager.InviteManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.chat.ChatView;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import littleGame.events.LittleGameEvent;
   import littleGame.events.LittleGameSocketEvent;
   import littleGame.menu.LittleMenuBar;
   import littleGame.model.LittleLiving;
   import littleGame.model.Scenario;
   import littleGame.view.GameScene;
   import littleGame.view.LittleScoreBar;
   import littleGame.view.LittleSoundButton;
   
   public class LittleGame extends BaseStateView
   {
       
      
      private var _scene:GameScene;
      
      private var _game:Scenario;
      
      private var _chatField:ChatView;
      
      private var _menu:LittleMenuBar;
      
      private var _scoreBar:LittleScoreBar;
      
      private var _soundButton:LittleSoundButton;
      
      private var _inhaleNote:DisplayObject;
      
      public function LittleGame()
      {
         super();
      }
      
      private function configUI() : void
      {
         this._scene = new GameScene(this._game);
         addChild(this._scene);
         this._menu = ComponentFactory.Instance.creatCustomObject("LittleMenuBar");
         addChild(this._menu);
         this._scoreBar = new LittleScoreBar(PlayerManager.Instance.Self);
         this._scoreBar.x = 706;
         this._scoreBar.y = -2;
         addChild(this._scoreBar);
         this._soundButton = ComponentFactory.Instance.creatCustomObject("LittleSoundButton");
         addChild(this._soundButton);
         if(SharedManager.Instance.allowMusic || SharedManager.Instance.allowSound)
         {
            this._game.soundEnabled = true;
         }
         else
         {
            this._game.soundEnabled = false;
         }
         SoundManager.instance.allowSound = CharacterSoundManager.instance.allowSound = !!this._game.soundEnabled ? Boolean(Boolean(SharedManager.Instance.allowSound)) : Boolean(Boolean(false));
         SoundManager.instance.allowMusic = CharacterSoundManager.instance.allowMusic = !!this._game.soundEnabled ? Boolean(Boolean(SharedManager.Instance.allowMusic)) : Boolean(Boolean(false));
         this._soundButton.state = !!this._game.soundEnabled ? int(int(1)) : int(int(2));
         this._inhaleNote = ComponentFactory.Instance.creat("asset.littleGame.InhaleNote");
         this._inhaleNote.x = StageReferance.stageWidth - this._inhaleNote.width >> 1;
         addChild(this._inhaleNote);
         ChatManager.Instance.state = ChatManager.CHAT_LITTLEGAME;
         this._chatField = ChatManager.Instance.view;
         this._chatField.output.isLock = true;
         addChild(this._chatField);
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(LittleGameSocketEvent.ADD_SPRITE,this.__addSprite);
         SocketManager.Instance.addEventListener(LittleGameSocketEvent.REMOVE_SPRITE,this.__removeSprite);
         SocketManager.Instance.addEventListener(LittleGameSocketEvent.MOVE,this.__livingMove);
         SocketManager.Instance.addEventListener(LittleGameSocketEvent.UPDATE_POS,this.__updatePos);
         SocketManager.Instance.addEventListener(LittleGameSocketEvent.UPDATELIVINGSPROPERTY,this.__updateLivingProperty);
         SocketManager.Instance.addEventListener(LittleGameSocketEvent.DOMOVIE,this.__doMovie);
         SocketManager.Instance.addEventListener(LittleGameSocketEvent.DOACTION,this.__doAction);
         SocketManager.Instance.addEventListener(LittleGameSocketEvent.ADD_OBJECT,this.__addObject);
         SocketManager.Instance.addEventListener(LittleGameSocketEvent.REMOVE_OBJECT,this.__removeObject);
         SocketManager.Instance.addEventListener(LittleGameSocketEvent.INVOKE_OBJECT,this.__invokeObject);
         SocketManager.Instance.addEventListener(LittleGameSocketEvent.GETSCORE,this.__selfGetScore);
         SocketManager.Instance.addEventListener(LittleGameSocketEvent.KICK_PLAYE,this.__kickPlaye);
         this._game.addEventListener(LittleGameEvent.SelfInhaleChanged,this.__inhaledChanged);
         this._soundButton.addEventListener(MouseEvent.CLICK,this.__soundClick);
      }
      
      private function __kickPlaye(event:LittleGameSocketEvent) : void
      {
         LittleGameManager.Instance.kickPlayer(event.pkg);
      }
      
      private function __invokeObject(event:LittleGameSocketEvent) : void
      {
         LittleGameManager.Instance.invokeObject(this._game,event.pkg);
      }
      
      private function __soundClick(event:MouseEvent) : void
      {
         if(SharedManager.Instance.allowMusic || SharedManager.Instance.allowSound)
         {
            this._game.soundEnabled = !this._game.soundEnabled;
            SoundManager.instance.allowSound = CharacterSoundManager.instance.allowSound = !!this._game.soundEnabled ? Boolean(Boolean(SharedManager.Instance.allowSound)) : Boolean(Boolean(false));
            SoundManager.instance.allowMusic = CharacterSoundManager.instance.allowMusic = !!this._game.soundEnabled ? Boolean(Boolean(SharedManager.Instance.allowMusic)) : Boolean(Boolean(false));
            this._soundButton.state = !!this._game.soundEnabled ? int(int(1)) : int(int(2));
            SoundManager.instance.play("015");
         }
      }
      
      private function __inhaledChanged(event:Event) : void
      {
         if(this._game.selfInhaled)
         {
            this._game.removeEventListener(LittleGameEvent.SelfInhaleChanged,this.__inhaledChanged);
            if(this._inhaleNote)
            {
               ObjectUtils.disposeObject(this._inhaleNote);
            }
            this._inhaleNote = null;
         }
      }
      
      private function __netDelay(event:LittleGameSocketEvent) : void
      {
         LittleGameManager.Instance.setNetDelay(this._game,event.pkg);
      }
      
      private function __pong(event:LittleGameSocketEvent) : void
      {
         LittleGameManager.Instance.pong(this._game,event.pkg);
      }
      
      private function __setClock(event:LittleGameSocketEvent) : void
      {
         LittleGameManager.Instance.setClock(this._game,event.pkg);
      }
      
      private function __selfGetScore(event:LittleGameSocketEvent) : void
      {
         LittleGameManager.Instance.getScore(this._game,event.pkg);
      }
      
      private function __doAction(event:LittleGameSocketEvent) : void
      {
         LittleGameManager.Instance.doAction(this._game,event.pkg);
      }
      
      private function __doMovie(event:LittleGameSocketEvent) : void
      {
         LittleGameManager.Instance.doMovie(this._game,event.pkg);
      }
      
      private function __removeObject(event:LittleGameSocketEvent) : void
      {
         LittleGameManager.Instance.removeObject(this._game,event.pkg);
      }
      
      private function __addObject(event:LittleGameSocketEvent) : void
      {
         var type:String = event.pkg.readUTF();
         LittleGameManager.Instance.addObject(this._game,type,event.pkg);
      }
      
      private function __updateLivingProperty(event:LittleGameSocketEvent) : void
      {
         LittleGameManager.Instance.updateLivingProperty(this._game,event.pkg);
      }
      
      private function __updatePos(event:LittleGameSocketEvent) : void
      {
         LittleGameManager.Instance.updatePos(this._game,event.pkg);
      }
      
      private function __livingMove(event:LittleGameSocketEvent) : void
      {
         var living:LittleLiving = LittleGameManager.Instance.livingMove(this._game,event.pkg);
      }
      
      private function __addSprite(event:LittleGameSocketEvent) : void
      {
         LittleGameManager.Instance.addLiving(this._game,event.pkg);
      }
      
      private function __removeSprite(event:LittleGameSocketEvent) : void
      {
         LittleGameManager.Instance.removeLiving(this._game,event.pkg);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(LittleGameSocketEvent.ADD_SPRITE,this.__addSprite);
         SocketManager.Instance.removeEventListener(LittleGameSocketEvent.REMOVE_SPRITE,this.__removeSprite);
         SocketManager.Instance.removeEventListener(LittleGameSocketEvent.MOVE,this.__livingMove);
         SocketManager.Instance.removeEventListener(LittleGameSocketEvent.UPDATE_POS,this.__updatePos);
         SocketManager.Instance.removeEventListener(LittleGameSocketEvent.UPDATELIVINGSPROPERTY,this.__updateLivingProperty);
         SocketManager.Instance.removeEventListener(LittleGameSocketEvent.DOMOVIE,this.__doMovie);
         SocketManager.Instance.removeEventListener(LittleGameSocketEvent.DOACTION,this.__doAction);
         SocketManager.Instance.removeEventListener(LittleGameSocketEvent.ADD_OBJECT,this.__addObject);
         SocketManager.Instance.removeEventListener(LittleGameSocketEvent.REMOVE_OBJECT,this.__removeObject);
         SocketManager.Instance.removeEventListener(LittleGameSocketEvent.INVOKE_OBJECT,this.__invokeObject);
         SocketManager.Instance.removeEventListener(LittleGameSocketEvent.GETSCORE,this.__selfGetScore);
         SocketManager.Instance.removeEventListener(LittleGameSocketEvent.SETCLOCK,this.__setClock);
         SocketManager.Instance.removeEventListener(LittleGameSocketEvent.NET_DELAY,this.__netDelay);
         SocketManager.Instance.removeEventListener(LittleGameSocketEvent.KICK_PLAYE,this.__kickPlaye);
         this._game.removeEventListener(LittleGameEvent.SelfInhaleChanged,this.__inhaledChanged);
         this._soundButton.removeEventListener(MouseEvent.CLICK,this.__soundClick);
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         InviteManager.Instance.enabled = false;
         CacheSysManager.lock(CacheConsts.ALERT_IN_FIGHT);
         this._game = data as Scenario;
         KeyboardShortcutsManager.Instance.forbiddenFull();
         LittleGameManager.Instance.setMainStage(this);
         this.configUI();
         LittleGameManager.Instance.setGameScene(this._scene);
         this.addEvent();
         super.enter(prev,data);
         this._game.startup();
         SoundManager.instance.playMusic(this._game.music);
      }
      
      override public function getType() : String
      {
         return StateType.LITTLEGAME;
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         InviteManager.Instance.enabled = true;
         CacheSysManager.unlock(CacheConsts.ALERT_IN_FIGHT);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_FIGHT);
         this.removeEvent();
         KeyboardShortcutsManager.Instance.cancelForbidden();
         ObjectUtils.disposeObject(this._soundButton);
         this._soundButton = null;
         ObjectUtils.disposeObject(this._menu);
         this._menu = null;
         ObjectUtils.disposeObject(this._scene);
         this._scene = null;
         ObjectUtils.disposeObject(this._game);
         this._game = null;
         ObjectUtils.disposeObject(this._inhaleNote);
         this._inhaleNote = null;
         this._chatField = null;
         SoundManager.instance.allowSound = SharedManager.Instance.allowSound;
         SoundManager.instance.allowMusic = SharedManager.Instance.allowMusic;
         SoundManager.instance.playMusic("062",true,false);
         CharacterSoundManager.instance.allowSound = false;
         CharacterSoundManager.instance.allowMusic = false;
         CharacterFactory.Instance.releaseResource();
         super.leaving(next);
      }
   }
}
