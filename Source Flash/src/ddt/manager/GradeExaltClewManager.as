package ddt.manager
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.Experience;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.states.StateType;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatInputView;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class GradeExaltClewManager
   {
      
      public static const LIGHT:int = 1;
      
      public static const BLACK:int = 2;
      
      private static var instance:GradeExaltClewManager;
       
      
      private var _asset:MovieClip;
      
      private var _grade:int;
      
      private var _isSteup:Boolean = false;
      
      private var _character:RoomCharacter;
      
      private var _info:PlayerInfo;
      
      private var _increBlood:FilterFrameText;
      
      public function GradeExaltClewManager()
      {
         super();
      }
      
      public static function getInstance() : GradeExaltClewManager
      {
         if(instance == null)
         {
            instance = new GradeExaltClewManager();
         }
         return instance;
      }
      
      public function setup() : void
      {
         if(this._isSteup)
         {
            return;
         }
         this.addEvent();
         this._isSteup = true;
      }
      
      private function addEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__GradeExalt);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__GradeExalt);
      }
      
      private function __GradeExalt(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Grade"] && PlayerManager.Instance.Self.IsUpGrade && PlayerManager.Instance.Self.Grade > 15)
         {
            if(param1.target.Grade == this._grade)
            {
               return;
            }
            this._grade = param1.target.Grade;
            if(StateManager.currentStateType != StateType.FIGHTING)
            {
               this.show(BLACK);
            }
         }
      }
      
      public function show(param1:int) : void
      {
         CacheSysManager.lock(CacheConsts.ALERT_IN_MOVIE);
         this.hide();
         this._asset = ComponentFactory.Instance.creat("asset.core.upgradeClewMcOne");
         this._asset.addEventListener(Event.ENTER_FRAME,this.__cartoonFrameHandler);
         this._asset.gotoAndPlay(1);
         this._increBlood = ComponentFactory.Instance.creatComponentByStylename("core.upgradeMoive.text");
         this._asset.leftMC.wenzi.addChild(this._increBlood);
         var _loc2_:int = PlayerManager.Instance.Self.Grade;
         if(_loc2_ == 1)
         {
            this._increBlood.text = "100";
         }
         else
         {
            this._increBlood.text = (Experience.getBasicHP(_loc2_) - Experience.getBasicHP(_loc2_ - 1)).toString();
         }
         this._character = CharactoryFactory.createCharacter(PlayerManager.Instance.Self,"room") as RoomCharacter;
         this._character.showGun = false;
         this._character.show(false,-1);
         this._character.width = 300;
         this._character.height = 400;
         this._asset.MC.addChild(this._character);
         this._character.x = 195;
         this._character.y = 140;
         SoundManager.instance.play("063");
         this._asset.x = 220;
         this._asset.y = 80;
         this._asset.buttonMode = this._asset.mouseChildren = this._asset.mouseEnabled = false;
         if(param1 == LIGHT)
         {
            LayerManager.Instance.addToLayer(this._asset,LayerManager.STAGE_TOP_LAYER,false);
         }
         else
         {
            LayerManager.Instance.addToLayer(this._asset,LayerManager.STAGE_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         }
         var _loc3_:ChatData = new ChatData();
         _loc3_.msg = LanguageMgr.GetTranslation("tank.manager.GradeExaltClewManager");
         _loc3_.channel = ChatInputView.SYS_NOTICE;
         ChatManager.Instance.chat(_loc3_);
      }
      
      private function end() : void
      {
         this._asset.gotoAndStop(this._asset.totalFrames);
         this.hide();
      }
      
      private function __cartoonFrameHandler(param1:Event) : void
      {
         if(this._asset == null)
         {
            return;
         }
         if(this._asset.currentFrame == this._asset.totalFrames)
         {
            this.end();
            CacheSysManager.unlock(CacheConsts.ALERT_IN_MOVIE);
            CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_MOVIE,1000);
         }
      }
      
      public function hide() : void
      {
         if(this._asset)
         {
            this._asset.removeEventListener(Event.ENTER_FRAME,this.__cartoonFrameHandler);
         }
         if(this._asset && this._asset.parent)
         {
            this._asset.parent.removeChild(this._asset);
         }
         this._asset = null;
         if(this._increBlood)
         {
            ObjectUtils.disposeObject(this._increBlood);
         }
         this._increBlood = null;
         if(this._character)
         {
            ObjectUtils.disposeObject(this._character);
         }
         this._character = null;
      }
   }
}
